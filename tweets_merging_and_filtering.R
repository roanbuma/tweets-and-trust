# import data
tweets = readRDS("data/tweets_full_2017_2021.rds") #note: excludes HattevdWoude (scraped later)
TK_leden = readRDS("data/TK_leden_full.RDS")

# select relevant variables from TK_leden
TK_leden = TK_leden %>%
  select(Persoon_Id, Roepnaam, Achternaam, Geslacht, Van, Afkorting, twitter, user_id)

# select relevant variables from tweets
tweets = tweets %>%
  select(id, text, author_id, created_at)

# merge tweets and TK_leden
tweets = tweets %>%
  left_join(TK_leden, by = c("author_id"="user_id"))

# counting
t_users = unique(tweets$twitter)
tk_users = TK_leden$twitter
no_tweets_users = tk_users[!tk_users %in% t_users]
no_tweets_users

# exclude tweets that were tweeted before TK member entered parliament
tweets = tweets %>%
  # compare created_at to the entrance of TK member
  mutate(during_stay = created_at > Van) %>%
  # filter on that
  filter(during_stay == TRUE) %>%
  # remove variable
  select(-during_stay)

# counting
t_users = unique(tweets$twitter)
tk_users = TK_leden$twitter
no_tweets_users_in_sample = tk_users[!tk_users %in% t_users]
no_tweets_users_in_sample = no_tweets_users_in_sample[!no_tweets_users_in_sample %in% no_tweets_users]
no_tweets_users_in_sample

# save data
saveRDS(tweets, "data/tweets_filtered_2017_2021.rds")







