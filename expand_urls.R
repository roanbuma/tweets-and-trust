# libraries
library(longurl)
library(tidyverse)

# set wd to R file
setwd("C:/Users/roanb/Dropbox/VU/SOCRES/Master Scriptie/R")

# load data
tweets = readRDS("data/tweets_filtered_2017_2021.rds")

# set wd to expand_urls folder to save there
setwd("data/expand_urls")

# set sample for testing
#tweets = tweets[1:1000,]

# create column with urls
tweets$urls = str_extract_all(tweets$text, "(www|http:|https:)+[^\\s]+[\\w]")

# Define the function to apply over each row of the dataframe
expand_tweet_urls = function(url_list){
  # unlist the input
  unlisted = unlist(url_list)
  # if the list is not empty,
  if(length(unlisted)>0){
    # expand the urls 
    expanded = expand_urls(unlisted)
    # and paste them together into a single output
    output = paste(expanded$expanded_url, collapse=" ")
    return(output)
  }
  # if list is empty, return NA 
  else NA
}

# define test urls
# test1 = tweets$urls[1]
# test2 =  tweets$urls[3]
# test3 = tweets$urls[96]

# test function on test urls
# expand_tweet_urls(test1)
# expand_tweet_urls(test2)
# expand_tweet_urls(test3)

# GENERATE THE EXPANDED URLS -----

# start time
start=Sys.time()

# Set up a loop to apply the function over each row of the dataframe
for (i in seq_len(nrow(tweets))) {
  # Check if the result file for this row already exists
  if (file.exists(paste0("tweet_expand_url_", i, ".rds"))) {
    # If the file exists, skip this row and move on to the next one
    cat("Result for row ", i, " already exists, skipping.\n")
    next
  }
  
  # Use tryCatch() to catch any errors that might occur
  result <- tryCatch({
    expand_tweet_urls(tweets$urls[i])
  }, error = function(e) {
    # If an error occurs, print a message and return NULL
    cat("Error: ", conditionMessage(e), "\n")
    return(NULL)
  })
  
  # Save the result after each row using saveRDS()
  write_rds(result, file = paste0("tweet_expand_url_", i, ".rds"))
  
  # print progress
  print(paste("Progress:",i,"/",nrow(tweets),"(",i/nrow(tweets)*100,"%)"))
}

end=Sys.time()
difference = end-start


# READ THE OUTPUTS -----

# create empty df to append to
expanded_urls = tibble(url= c(NA))
# read all the expanded url files
for (i in seq_len(nrow(tweets))){
  file_name = paste0("tweet_expand_url_",i,".rds")
  file = readRDS(file_name)
  expanded_urls[i,] = c(file)
  #tweets_expanded$url[2] = file #tweets_expanded %>% rbind(file)
  print(paste("Read progress:",i,"/",nrow(tweets)))
}

expanded_tweets = tweets %>% cbind(expanded_urls)

# set wd to R file
setwd("C:/Users/roanb/Dropbox/VU/SOCRES/Master Scriptie/R")
# save expanded tweets
saveRDS(expanded_tweets, "data/expanded_tweets_full.rds")

