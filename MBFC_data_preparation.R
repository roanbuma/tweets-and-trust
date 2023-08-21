## ----setup, include=FALSE-----------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
knitr::purl("MBFC_data_preparation.Rmd")


## ---- message=F---------------------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)
library(lubridate)

df = readRDS('mbfc_full_12-06-2023.rds')


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
dim1 = dim(df)

# case filtering
df = df %>%
  filter(!is.na(category)) # remove where category is NA (these aren't sources)

dim2 = dim(df)

dim2 - dim1


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df_manual = df %>%
  filter(is.na(source)) 

df_manual


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
### Manual look-up:

df[df$url=="https://mediabiasfactcheck.com/law-com/",]$source = "law.com"
df[df$url=="https://mediabiasfactcheck.com/significance-magazine/",]$source = "significancemagazine.com"
df[df$url=="https://mediabiasfactcheck.com/nc-policy-watch/",]$source = "ncpolicywatch.com"
df[df$url=="https://mediabiasfactcheck.com/numbers-usa/",]$source = "numbersusa.com"
df[df$url=="https://mediabiasfactcheck.com/oil-and-water-dont-mix/",]$source = "oilandwaterdontmix.org"
df[df$url=="https://mediabiasfactcheck.com/roanoke-times/",]$source = "roanoke.com"
df[df$url=="https://mediabiasfactcheck.com/online-updates/",]$source = "online-updates.net"
df[df$url=="https://mediabiasfactcheck.com/unbiased-america/",]$source = "unbiasedamerica.com" # doesnt exist anymore, now https://www.facebook.com/pg/UnbiasedAmerica/
df[df$url=="https://mediabiasfactcheck.com/der-standard-bias/",]$source = "derstandard.at"
df[df$url=="https://mediabiasfactcheck.com/4chan-bias/",]$source = "4chan.org"
df[df$url=="https://mediabiasfactcheck.com/riposte-laique-bias/",]$source = "ripostelaique.com"
df[df$url=="https://mediabiasfactcheck.com/the-grayzone/",]$source = "thegrayzone.com"
df[df$url=="https://mediabiasfactcheck.com/the-intergovernmental-panel-on-climate-change-ipcc/",]$source = "ipcc.ch"
df[df$url=="https://mediabiasfactcheck.com/american-conservative-movement-acm/",]$source = "americanconservativemovement.com"
df[df$url=="https://mediabiasfactcheck.com/the-vaccine-reaction/",]$source = "thevaccinereaction.org"
df[df$url=="https://mediabiasfactcheck.com/we-love-trump/",]$source = "welovetrump.com"
df[df$url=="https://mediabiasfactcheck.com/sc-connecticut-news/",]$source = "scconnnews.com"

# not a source:
df[df$url=="https://mediabiasfactcheck.com/rachel-maddow-bias-rating-2/",]$source = NA
df[df$url=="https://mediabiasfactcheck.com/dan-bongino-bias-rating/",]$source = NA
df[df$url=="https://mediabiasfactcheck.com/anthony-albanese-australia-fact-and-bias/",]$source = NA
df[df$url=="https://mediabiasfactcheck.com/mahmoud-abbas-facts-and-bias/",]$source = NA
df[df$url=="https://mediabiasfactcheck.com/bashar-al-assad-facts-and-bias/",]$source = NA
df[df$url=="https://mediabiasfactcheck.com/facts-and-bias-joe-biden/",]$source = NA
df[df$url=="https://mediabiasfactcheck.com/shavkat-mirziyoyev-facts-and-bias/",]$source = NA

# not exist anymore
df[df$url=="https://mediabiasfactcheck.com/worldpolitics-news/",]$source = NA


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
dim1 = dim(df)

# case filtering
df = df %>%
  filter(!is.na(source)) # remove where source is NA

dim2 = dim(df)

dim2 - dim1


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# fixing errors due to encoding
df = df %>%
  mutate(source = str_remove(source, "\ua0")) %>%
  mutate(reasoning = str_remove(reasoning, "\ua0")) %>%
  mutate(bias_rating = str_remove(bias_rating, "\ua0")) %>%
  mutate(factual_reporting = str_remove(factual_reporting, "\ua0")) %>%
  mutate(country = str_remove(country, "\ua0")) %>%
  mutate(media_type = str_remove(media_type, "\ua0")) %>%
  mutate(traffic_popularity = str_remove(traffic_popularity, "\ua0")) %>%
  mutate(mbfc_credibility_rating = str_remove(mbfc_credibility_rating, "\ua0"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# fixing specific errors
df$source = df$source %>%
  str_remove("Sources:") %>%
  str_remove(":") %>%# 1 case
  str_remove("\u00a0") # 2 cases


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# reduce length of URL in MBFC data
df = df %>%
  mutate(source = str_remove(source, "^ ")) %>% # unicode error
  mutate(source = str_remove(source, "^(http|https)(:|)//")) %>% # remove http(s)
  mutate(source = str_remove(source, "^www([0-9]|)\\.")) %>% #remove www
  mutate(source = str_remove(source, " ")) %>% # remove spaces
  mutate(source = str_remove(source, "/$")) # remove lagging slash

# fix special cases
df$source = df$source %>%
  str_replace("christiansfortruthdot com", "christiansfortruth.com") %>% 
  str_replace("altrighttv.+", "altrighttv.com") %>%
  str_replace("Wikipedia", "wikipedia.org") %>%
  str_replace("Fuckingnews", "thefingnews.com")

# remove stuff after slash for shorter source (problematic in some cases)
df = df %>%
  mutate(source_short = str_replace(source, "/.+$", ""))

# find non-URLS left 
df2 = df %>%
  filter(!str_detect(source, "\\.")) %>%
  select(source, source_short)

df2


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# remove non-URLs
df = df %>%
  filter(str_detect(source, "\\."))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# RUN ONLY ONCE TO GENERATE EMPTY DF
#output = tibble(source = character(), url_exists = logical())
#saveRDS(output, "output2.rds")


## ----eval=FALSE---------------------------------------------------------------------------------------------------------------------------------------------
## # library(RCurl)
## #
## # output = readRDS("output2.rds")
## #
## # t=nrow(output)
## #
## # for (i in df$source[1:100]) {
## #   if(i %in% output$source){
## #       next
## #     }
## #   exists = url.exists(i)
## #   row = tibble(source = i, url_exists = exists)
## #   output = rbind(output, row)
## #   #save
## #   saveRDS(output, "output2.RDS")
## #   #progress bar
## #   t=t+1
## #   print(t)
## # }


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$category = df$category %>%
  tolower() %>%
  as_factor() %>%
  fct_relevel(c("left bias","left-center bias","least biased","right-center bias","right bias","conspiracy-pseudoscience","questionable source","pro-science","satire"))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$reasoning = df$reasoning %>%
  # replace errors with correct unicode char
  str_replace("\ua0", "") %>%
  str_remove("\u00a0") %>%
  str_remove("^ ") %>%
  tolower()

# paste all reasonings with a comma and then split on comma to get a full list of all given reasons
all_reasonings = paste(df$reasoning, collapse = ",") %>%
  str_split(",") 
  

# fix list in list
all_reasonings = all_reasonings[[1]]

# remove NAs
all_reasonings = all_reasonings[all_reasonings != "NA"]

# add variable to df stating whether a reasoning is present
df$reasoning_true = ifelse(is.na(df$reasoning),  FALSE, TRUE)

# convert all_reasonings to df
all_reasonings_df = tibble(reasons = all_reasonings)

all_reasonings_df$reasons = all_reasonings_df$reasons %>%
  str_replace("^ ", "") %>%
  str_replace("\\.$", "")

#all_reasonings_df %>% group_by(reasons) %>% tally() 


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$bias_rating = df$bias_rating %>%
  # replace errors with correct unicode char
  str_remove("\u00a0") %>%
  # replace characters to simplify bias ratings
  str_remove("^ ") %>%
  str_replace("\u2013", " ") %>%
  str_replace("-", " ") %>%
  str_replace("/", " ") %>%
  str_replace("  ", " ") %>%
  str_replace("  ", " ") %>%
  str_replace(" and ", " ") %>%
  # lowercase
  tolower()

  # replace NA with NA labels
df$bias_rating = ifelse(df$bias_rating == "n a", NA, df$bias_rating)
df$bias_rating = ifelse(df$bias_rating == "not rated", NA, df$bias_rating)
df$bias_rating = ifelse(df$bias_rating == "unrated", NA, df$bias_rating)

sort(table(df$bias_rating),decreasing = T)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df = df %>%
mutate(orientation = case_when(
    str_detect(bias_rating, "right") ~ "right",
    str_detect(bias_rating, "left") ~ "left",
    str_detect(bias_rating, "least biased") ~ "least biased",
    !is.na(bias_rating) ~ "any other label"
  ))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$factual_reporting = df$factual_reporting %>%
  # encoding error
  str_replace("\ua0", " ") %>%
  str_remove("^ ") %>%
  # lowercase
  tolower() %>%
  # replace chars
  str_replace("-", " ") %>%
  str_replace("veryhigh", "very high")

# fix NA
df$factual_reporting = ifelse(df$factual_reporting == "n/a", NA, df$factual_reporting)

table(df$factual_reporting)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# recode fact reporting
df$factual_reporting = df$factual_reporting %>%
  as_factor() %>%
  fct_relevel(c("very low","low","mixed","mostly factual","high","very high"))

table(df$factual_reporting)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$country = df$country %>%
  # encoding error
  str_replace("\ua0", " ") %>%
  str_remove("^ ") %>%
  # lowercase
  tolower() %>%
  # remove press freedom index
  str_replace(" \\(.*","") %>%
  str_replace("\\(.*","")
  
sort(table(df$country, useNA = "ifany"), decreasing = T)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$press_freedom_rating = df$press_freedom_rating %>%
  tolower() %>%
  str_remove("^ ")

# replace NAs with na
df$press_freedom_rating = ifelse(df$press_freedom_rating == "n/a", NA, df$press_freedom_rating)

df$press_freedom_rating = df$press_freedom_rating %>%
  as_factor() %>%
  str_replace("minimal freedom", "limited freedom") %>% # india, checked other sources to confirm
  fct_relevel(c("total oppression","limited freedom","moderate freedom","mostly free","excellent"))

table(df$press_freedom_rating, useNA = "ifany")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$media_type = df$media_type %>%
  tolower() %>%
  str_remove("^ ")

sort(table(df$media_type, useNA = "ifany"), decreasing = T)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$traffic_popularity = df$traffic_popularity %>%
  # encoding error
  str_replace("\ua0", " ") %>%
  str_remove("^ ") %>%
  # lowercase
  tolower() 

df$traffic_popularity = case_when(
  df$traffic_popularity == "mediumtraffic" ~ "medium traffic", # 10 case
  df$traffic_popularity == "hightraffic" ~ "high traffic", # 1 case
  df$traffic_popularity == "medium" ~ "medium traffic", # 1 case
  df$traffic_popularity == "minimaltraffic" ~ "minimal traffic", # 6
  df$traffic_popularity == "high traffic (social media)" ~ "high traffic", # 1 case
  df$traffic_popularity == "high traffic (via social media)" ~ "high traffic", # 1 case
  df$traffic_popularity == "high traffic (when online)" ~ "high traffic", # 1 case
  TRUE ~ df$traffic_popularity
)

df$traffic_popularity = df$traffic_popularity %>%
  as_factor() %>%
  fct_relevel(c("minimal traffic","medium traffic","high traffic"))

table(df$traffic_popularity, useNA = "ifany")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$mbfc_credibility_rating = df$mbfc_credibility_rating %>%
  # encoding error
  str_replace("\ua0", " ") %>%
  str_remove("^ ") %>%
  # lowercase
  tolower() %>%
  # fix error
  str_replace("mixed credibility", "medium credibility") %>%
  str_replace("highcredibility", "high credibility") %>%
  str_replace("mediumcredibility", "medium credibility") %>%
  str_replace("lowcredibility", "low credibility")

# replace NA
df$mbfc_credibility_rating = ifelse(df$mbfc_credibility_rating == "n/a", NA, df$mbfc_credibility_rating)

df$mbfc_credibility_rating = df$mbfc_credibility_rating %>%
  as_factor() %>%
  fct_relevel(c("low credibility","medium credibility","high credibility"))

table(df$mbfc_credibility_rating)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df$last_updated = df$last_updated %>%
  str_remove(" by Media Bias Fact Check") %>%
  mdy()
  


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# find sources with more than one occurance
df_duplicates = df %>%
  group_by(source_short) %>%
  summarise(n_duplicates = n()-1)

# find sources with more than one occurance + different category
other_category_duplicates = df %>%
  group_by(source_short, category) %>%
  summarise(n = n()) %>%
  group_by(source_short) %>%
  summarise(other_category_duplicates = n()-1)

# check
df_duplicates %>%
  left_join(other_category_duplicates) %>%
  arrange(desc(other_category_duplicates), desc(n_duplicates))

df = df %>%
  left_join(df_duplicates) %>%
  left_join(other_category_duplicates)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# inspect
df %>%
  filter(other_category_duplicates > 0)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# isolate duplicates
df_no_duplicates = df %>%
  filter(n_duplicates == 0)
df_yes_duplicates = df %>%
  filter(n_duplicates > 0)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
before = nrow(df_yes_duplicates)

df_yes_duplicates = df_yes_duplicates %>%
  # calc length of source
  mutate(length = nchar(source)) %>%
  # group by short source
  group_by(source_short) %>%
  # filter out the longer sources
  filter(length == min(length)) %>%
  ungroup()

after = nrow(df_yes_duplicates)

after-before


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
before = nrow(df_yes_duplicates)

df_yes_duplicates = df_yes_duplicates %>%
  # group by source
  group_by(source) %>%
  # filter out older sources
  filter(last_updated == max(last_updated)) %>%
  ungroup()

after = nrow(df_yes_duplicates)
after-before


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
before = nrow(df_yes_duplicates)

length(df_yes_duplicates$source_short)
length(unique(df_yes_duplicates$source_short))

df_yes_duplicates$duplicate = duplicated(df_yes_duplicates$source_short)

# check if category is same
which_duplicate = df_yes_duplicates %>%
  group_by(source_short, category) %>%
  tally() %>%
  mutate(dupe = duplicated(source_short))

# check which source have a duplicate in a different category
which_duplicate_different_category = which_duplicate %>% 
  filter(dupe == "TRUE")

which_duplicate_different_category

`%!in%` <- Negate(`%in%`)

# remove duplicates
df_yes_duplicates = df_yes_duplicates %>% 
  # remove normal duplicates
  filter(duplicate == FALSE) %>%
  # remove all source if they have duplicates in different categories (1 source)
  filter(source_short %!in% which_duplicate_different_category$source_short)

after = nrow(df_yes_duplicates)
after-before


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# these two should be the same length
nrow(df_yes_duplicates)
length(unique(df_yes_duplicates$source_short))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# remove unneccesary columns
df_yes_duplicates = select(df_yes_duplicates, !c(length, duplicate))

# combine again
df = rbind(df_no_duplicates, df_yes_duplicates)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# check again for full data, should be same length
nrow(df)
length(unique(df$source_short))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df = df %>% arrange(desc(last_updated))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
# remove unneccessary columns in final data
df = df %>% select(!c(n_duplicates, other_category_duplicates))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
saveRDS(all_reasonings, "all_reasonings.rds")
saveRDS(all_reasonings_df, "all_reasonings_df.rds")
saveRDS(df, "mbfc_full_prepared.rds")

