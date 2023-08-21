# tweets-and-trust
Master Thesis In Social Sciences for a Digital Society

# tweets-and-trust Master Thesis In Social Sciences for a Digital Society

**Full Process of Tweet Data Collection and Preparation**

STEP 1: getting members list. A list of Twitter accounts of members of the house of representatives was compiled. For x Representatives, the Twitter account could be found in on the website of tweedekamer.nl. For the other representatives, the Twitter account was manually looked up. In total, 147 out of 150 representatives have a Twitter account. R script: scrape_twitter_accounts.R. R script creates data file TK_leden_full.rds 

STEP 2: scraping tweets from members (time-consuming). The Academic Twitter API via the R package academictwitteR was used to scrape the tweets (Barrie & Ho, 2021). R script: scrape_tweets.R. R script uses data file TK_leden_full.rds. R script creates data file tweets_full_2017_2021.rds. 

STEP 3: adding member info to tweets and filtering tweets by time. As I am interested in the Tweets that representatives have tweeted as representatives, the data was filtered to only include tweets that have been posted by representatives during the time that they have served as representatives. R script: tweets_merging_and_filtering.R. R script uses data files tweets_full_2017_2021.rds and TK_leden_full.rds. R script creates data file tweets_filtered_2017_2021.rds

STEP 4: Expanding URLs (time-consuming). URLs from each Tweets were extracted and expanded using longurl. R script: expand_urls.R. R script uses data file tweets_filtered_2017_2021.rds. R script creates data file expanded_tweets_full.rds.

**Full Process of Manual Coding of Sources**

STEP 1: Compiling a list of most-shared URL domains. R script: tweets_analysis.R. R script uses data file expanded_tweets_full.rds. R script creates data file code_urls.csv.

STEP 2: Manually coding URLs. URLs were manually coded in Microsoft Excel. Excel uses data file code_urls.csv. Excel saves data file code_urls.csv.

STEP 3: Preparing manual coding, descriptives of manual codings. R script: manual_coding_descriptives_preparation.R. R script uses data files expanded_tweets_full.rds and code_urls.csv. R script saves data file manual_coding_prepared.rds.

**Full Process of Scraping and Preparing MBFC Data**

This code was written as part of my internship in semester one at Penn State University. I rescraped the records in June, which added around 700 records compared to the version from half a year earlier. 

STEP 1: Scraping MBFC Data (written during internship) Media and URLs ratings from MBFC were scraped from the webstie, using, the rvest R package (Wickham, 2022). The list of all URLs was retrieved through scrap- ing the sitemap of the website. R code: MBFC_scrape.R. R code creates data file mbfc_full_12-06-2023.rds.

STEP 2: Preparing and Cleaning MBFC Data (written during internship) Some MBFC records had missing source URLs which were looked up manually. Duplicates were removes, taking the shortest URL domain (e.g., Bloomberg.com and Bloomberg.com/citylab), picking the most recent version of multiple records for remaining duplicates that have the same bias category. Records that have mismatched categories were removed. After cleaning, the data contains. R code: MBFC_data_preparation.R. R code uses data file mbfc_full_12-06-2023.rds. R code creates data file mbfc_full_prepared.rds.

STEP 3: Preparing MBFC Data Study 2 Dutch (n = 8) and Belgian (n = 3) domains were removed, because the coding seemed inaccurate. This makes sense considering that MBFC is an American-maintained website. Dutch-language domains were manually coded (see manual coding). R code: MBFC_descriptives_preparation_thesis.R. R code uses data file mbfc_full_prepared.rds. R code creates data file mbfc_full_prepared_thesis.rds.

**Analyses**

tweets_analysis.Rmd is the main file for all analyses of study 1 public_analysis.Rmd is the main file for all analyses of study 2 Furthermore, some descriptive statistics were calculates with MBFC_descriptives_preparation_thesis.Rmd and manual_coding_descriptives_preparation.Rmd

**Data**
For reproduction, the data can be requested to the author (r.buma@student.vu.nl or alteratively roanbuma@live.nl).
