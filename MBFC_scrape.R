library(tidyverse)
library(rvest)
library(htm2txt) # htm2txt to convert html to text

# SCRAPE DETAILS FROM SOURCE / INPUT = MEDIA BIAS FACT CHECK URL

scrape_details_from_source = function(url) {
  html_contents = read_html(url, encoding = "UTF-8") %>%
    html_elements(".entry-content") %>% # read only entry content
    #html_elements("p") %>%  # read only par
    as.character() %>% # convert to character for htm2txt
    paste(collapse = "") %>% # paste to keep only a single long string
    htm2txt() %>% # convert to txt (could not use html_text2 as it did not consider <br> tags)
    strsplit("\n") # split on newline
  
  # fix issue of nested list
  html_contents = html_contents[[1]]
  
  # set values to NA before starting search
  # detailed report
  Reasoning = NA
  Bias_Rating = NA
  Factual_Reporting = NA
  Country = NA
  Press_Freedom_Rating = NA
  Media_Type = NA
  Traffic_Popularity = NA
  MBFC_Credibility_Rating = NA
  # URL
  Source = NA
  category = NA
  # last updated
  last_updated = NA
  
  # create empty df
  df = tibble(source = character(),
              category = character(),
              reasoning = character(),
              bias_rating = character(),
              factual_reporting = character(),
              country = character(),
              press_freedom_rating = character(),
              media_type = character(),
              traffic_popularity = character(),
              mbfc_credibility_rating = character(),
              last_updated = character())
  
  # Retrieve details from list
  for (i in html_contents) {
    if (is.na(category)) {
      category = str_extract(i, "LEAST BIASED|LEFT BIAS|LEFT-CENTER BIAS|RIGHT-CENTER BIAS|RIGHT BIAS|CONSPIRACY-PSEUDOSCIENCE|QUESTIONABLE SOURCE|PRO-SCIENCE|SATIRE")
    }
    if (is.na(Reasoning)) {
      Reasoning = str_extract(i, "Reasoning:.+") %>%
        str_remove("Reasoning:")
    }
    if (is.na(Bias_Rating)) {
      Bias_Rating = str_extract(i, "Bias Rating:.+") %>%
        str_remove("Bias Rating:")
    }
    if (is.na(Factual_Reporting)) {
      Factual_Reporting = str_extract(i, "Factual Reporting:.+") %>%
        str_remove("Factual Reporting:")
    }
    if (is.na(Country)) {
      Country = str_extract(i, "Country:.+") %>%
        str_remove("Country:")
    }
    if (is.na(Press_Freedom_Rating)) {
      Press_Freedom_Rating = str_extract(i, "Press Freedom Rating:.+") %>%
        str_remove("Press Freedom Rating:")
    }
    if (is.na(Media_Type)) {
      Media_Type = str_extract(i, "Media Type:.+") %>%
        str_remove("Media Type:")
    }
    if (is.na(Traffic_Popularity)) {
      Traffic_Popularity = str_extract(i, "Traffic/Popularity:.+") %>%
        str_remove("Traffic/Popularity:")
    }
    if (is.na(MBFC_Credibility_Rating)) {
      MBFC_Credibility_Rating = str_extract(i, "MBFC Credibility Rating:.+") %>%
        str_remove("MBFC Credibility Rating:")
    }
    if (is.na(Source)) {
      Source = str_extract(i, "(Source:.+)|(Sources:.+)") %>%
        str_remove("Source:")
    }
    if (is.na(last_updated)) {
      last_updated = str_extract(i, "Last Updated on .+") %>%
        str_remove("Last Updated on ")
    }
  }
  
  # save details in df
  df = df %>% add_row(category = category,
                      source = Source,
                      reasoning = Reasoning,
                      bias_rating = Bias_Rating,
                      factual_reporting = Factual_Reporting,
                      country = Country,
                      press_freedom_rating = Press_Freedom_Rating,
                      media_type = Media_Type,
                      traffic_popularity = Traffic_Popularity,
                      mbfc_credibility_rating = MBFC_Credibility_Rating,
                      last_updated = last_updated)
  
  return(df)
  
}


# SCRAPE LIST OF URLS FROM MBFC WEBSITE USING XML

#install.packages("devtools")
library(devtools)
#install_github("pixgarden/xsitemap")
library(xsitemap)
# retrieve sitemap
urls <- xsitemapGet("https://mediabiasfactcheck.com")
# define which parts to include
include = c("page-sitemap.xml",
            "page-sitemap2.xml",
            "page-sitemap3.xml",
            "page-sitemap4.xml",
            "page-sitemap5.xml",
            "page-sitemap6.xml",
            "page-sitemap7.xml")
# filter to only include pages and not posts
urls = urls %>%
  filter(origin %in% include)
# create list from df
url_list = urls$loc



# FILTERED SEARCH

# test filtered search
#scrape_filtered_search_table()
# save filtered search
#write_csv(df, "mbfc.csv")


# TESTING

# test scraping of individual news source and list of news sources:
test_url = "https://mediabiasfactcheck.com/fox-news"
test_list = c("https://mediabiasfactcheck.com/gop-gov/",
              "https://mediabiasfactcheck.com/fox-news/",
              "https://mediabiasfactcheck.com/cnn/",
              "https://mediabiasfactcheck.com/democratic-national-committee-dnc/",
              "https://mediabiasfactcheck.com/associated-press",
              "https://mediabiasfactcheck.com/american-cancer-society-bias/")
scrape_details_from_source(test_url)

for (i in test_list) {
  a = scrape_details_from_source(i)
  print(a)
}



# FINAL SCRAPING OF ALL MBFC PAGES USING THE XML SITEMAP AS INPUT

# create empty df
df = tibble(url = character(),
            source = character(),
            reasoning = character(),
            bias_rating = character(),
            factual_reporting = character(),
            country = character(),
            press_freedom_rating = character(),
            media_type = character(),
            traffic_popularity = character(),
            mbfc_credibility_rating = character())

tally = 0

start=Sys.time()

# loop over urls and add details
for (url in url_list) {
  if(url %in% df$url){
    next
  } 
  details = scrape_details_from_source(url)
  details$url = url
  df = rbind(df, details)
  # progress bar
  tally = tally + 1
  print(paste("Progress:",tally,"/",length(url_list)))
}

end=Sys.time()

duration=end-start
duration

#2.43 hours

saveRDS(df, "mbfc_full_12-06-2023.rds")


