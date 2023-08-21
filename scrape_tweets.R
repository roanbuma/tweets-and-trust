# load packages
library(tidyverse)
library(academictwitteR)

# load TK leden data
TK_leden = readRDS("TK_leden_full.RDS")

# input variables
start = "2017-01-01T00:00:00Z"
end =  "2023-03-24T00:00:00Z"
user_list = TK_leden$twitter

# scrape tweets from userlist and save to data path
get_all_tweets(users = user_list,
                       start_tweets = start,
                       end_tweets = end,
                       bearer_token = get_bearer(),
                       # n = infinite, get all tweets
                       n = Inf,
                       data_path = "tweets"
)

# resume collection if it was interrupted
resume_collection(data_path = "tweets",
                  bearer_token = get_bearer())

# bind tweets when scraping is done
tweets = bind_tweets("data/tweets_2017_2023")

# save file
saveRDS(tweets, "data/tweets_full_2017_2021.rds")

# how many TK leden have been scraped?
length(table(tweets$author_id))


