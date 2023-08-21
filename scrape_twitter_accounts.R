## ----------------------------------------------------------------------------------------
# packages
library(tidyverse)
library(academictwitteR)


## ----------------------------------------------------------------------------------------
# read TK leden data
TK_leden = readRDS("TK_leden_full.RDS")


## ----------------------------------------------------------------------------------------
# replace @ in some twitter accounts with empty chr
TK_leden = TK_leden %>%
  mutate(twitter = str_replace(twitter,"@",""))


## ---- eval=FALSE-------------------------------------------------------------------------
## # EXTRACT TWITTER USERNAMES FROM TK DATA, GET USER ID FOR EACH USERNAME
## start = Sys.time()
## 
## twitter_accounts = TK_leden %>%
##   # filter to remove accounts that don't include a twitter
##   filter(!is.na(twitter)) %>%
##   # extract twitter usernames as a vector
##   pull(twitter)
## 
## user_ids = tibble(twitter=character(),user_id=numeric())
## 
## count = 0
## 
## for (account in twitter_accounts){
##   # add try because some usernames do not return a user_id, else loop stopts on error
##   user_id = try(get_user_id(account, get_bearer()))
##   row = tibble(twitter=account,user_id=user_id)
##   user_ids = rbind(user_ids, row)
##   count=count+1
##   print(count)
## }
## 
## end = Sys.time()
## end-start
## 
## # replace empty with NA
## user_ids = user_ids %>%
##   mutate(user_id = ifelse(user_id == "Error in make_query(url = url, params = params, bearer_token = bearer_token,  : \n  something went wrong. Status code: 400\n", NA, user_id))
## 
## # save user IDs in RDS file
## saveRDS(user_ids, "twitter_user_ids.RDS")


## ----------------------------------------------------------------------------------------
user_ids = readRDS("twitter_user_ids.RDS")

TK_leden_user_id = TK_leden %>%
  left_join(user_ids) %>%
  select(Persoon_Id, Roepnaam, Tussenvoegsel, Achternaam, Afkorting, twitter, user_id) %>%
  filter(!is.na(twitter))


## ----------------------------------------------------------------------------------------
# no user id
TK_leden_no_user_id = TK_leden %>%
  left_join(user_ids) %>%
  select(Persoon_Id, Roepnaam, Tussenvoegsel, Achternaam, Afkorting, twitter, user_id) %>%
  filter(is.na(user_id)) %>%
  select(!user_id)

# write csv file to manually fill in
write.csv(TK_leden_no_user_id, "TK_leden_no_user_id.csv")


## ----------------------------------------------------------------------------------------
# read filled in CSV that contains manually found twitter names
TK_leden_no_user_id_filled_in = read.csv("TK_leden_no_user_id_filled_in.csv", row.names = "X")


## ----------------------------------------------------------------------------------------
# combine both lists
combined = TK_leden_user_id %>% 
  filter(!is.na(user_id)) %>%
  select(!user_id) %>%
  rbind(TK_leden_no_user_id_filled_in)


## ---- eval=FALSE-------------------------------------------------------------------------
## # EXTRACT TWITTER USERNAMES FROM TK DATA, GET USER ID FOR EACH USERNAME
## start = Sys.time()
## 
## twitter_accounts = combined %>%
##   # filter to remove accounts that don't include a twitter
##   filter(!is.na(twitter)) %>%
##   # extract twitter usernames as a vector
##   pull(twitter)
## 
## user_ids = tibble(twitter=character(), user_id=numeric())
## 
## count = 0
## 
## for (account in twitter_accounts){
##   # add try because some usernames do not return a user_id, else loop stopts on error
##   user_id = try(get_user_id(account, get_bearer()))
##   row = tibble(twitter=account,user_id=user_id)
##   user_ids = rbind(user_ids, row)
##   count=count+1
##   print(count)
## }
## 
## end = Sys.time()
## end-start
## 
## # replace empty with NA (should be none at this stage)
## user_ids = user_ids %>%
##   mutate(user_id = ifelse(user_id == "Error in make_query(url = url, params = params, bearer_token = bearer_token,  : \n  something went wrong. Status code: 400\n", NA, user_id))
## 
## # save user IDs in RDS file
## saveRDS(user_ids, "twitter_user_ids_complete.RDS")


## ----------------------------------------------------------------------------------------
user_ids = readRDS("twitter_user_ids_complete.RDS")


## ----------------------------------------------------------------------------------------
TK_leden_twitters = combined %>%
  left_join(user_ids) %>%
  select(Persoon_Id, twitter, user_id)


## ----------------------------------------------------------------------------------------
TK_leden = TK_leden %>%
  # remove old twitter variable
  select(!twitter) %>%
  # add new twitter accounts
  left_join(TK_leden_twitters, by = "Persoon_Id")


## ----------------------------------------------------------------------------------------
# save full TK_leden data
saveRDS(TK_leden, "TK_leden_full.RDS")

