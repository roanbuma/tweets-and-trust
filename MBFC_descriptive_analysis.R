## -----------------------------------------------------------------------------------------------------------------------------------------------------------
knitr::purl("MBFC_descriptive_analysis.Rmd")


## ----setup, include=FALSE-----------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df = readRDS("mbfc_full_prepared.rds")
all_reasonings = readRDS("all_reasonings.rds")
all_reasonings_df = readRDS("all_reasonings_df.rds")
output = readRDS("output.rds")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
library(tidyverse)
library(kableExtra)
library(viridis)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
category_descriptives = df %>%
  group_by(category) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2)) %>%
  rbind(tibble(category = "total", n = nrow(df), percentage = 100))

category_descriptives


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(df, aes(x = category)) +
  geom_bar(stat = "count") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Cons-Pseu","Ques-Source","Pro-Science","Satire"))+
  theme(axis.text.x = element_text(angle=45))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$reasoning_true, df$category)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
length(all_reasonings)

length(unique(all_reasonings))

length(all_reasonings)/sum(df$category=="questionable source")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
all_reasonings_df %>%
  group_by(reasons) %>%
  summarise(n = n(),
            percentage = round(n()/4441*100, 2)) %>%
  arrange(desc(percentage)) %>%
  filter(percentage > 1)

all_reasonings_df %>%
  group_by(reasons) %>%
  count %>%
  filter(n > 9) %>%
  ggplot(aes(x = reorder(reasons,n), y = n)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45)) +
  coord_flip()+
  labs(title = "Most common reasons for inclusion in Questionable category",
       subtitle = "Reasons with less than 10 occurances have been removed",
       x="")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
all_reasonings_df %>%
  mutate(orientation = case_when(
    str_detect(reasons, "left") ~ "left",
    str_detect(reasons, "right") ~ "right"
  )) %>%
  group_by(orientation) %>%
  tally()


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  group_by(bias_rating) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2)) %>%
  arrange(desc(percentage))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
orientation_counts = df %>%
  group_by(orientation) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2))

orientation_counts

saveRDS(orientation_counts, "orientation_counts.rds")

n_right_sources = df %>%
  filter(orientation == "right") %>%
  tally()

n_left_sources = df %>%
  filter(orientation == "left") %>%
  tally()

n_right_sources / n_left_sources


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(df, aes(x = orientation)) +
  geom_bar(stat = "count") +
  theme_bw()


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df = df %>%
  mutate(science = case_when(
    str_detect(bias_rating, "conspiracy") ~ "conspiracy/pseudoscience",
    str_detect(bias_rating, "pseudoscience") ~ "conspiracy/pseudoscience",
    str_detect(bias_rating, "psuedoscience") ~ "conspiracy/pseudoscience",
    str_detect(bias_rating, "pro science") ~ "pro science",
    !is.na(bias_rating) ~ "any other label"
  ))

df %>%
  group_by(science) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  group_by(factual_reporting) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(df, aes(x = factual_reporting)) +
  geom_bar(stat = "count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  group_by(country) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2)) %>%
  arrange(desc(percentage))

df %>%
  group_by(country) %>%
  count %>%
  filter(n > 9) %>%
  ggplot(aes(x = country, y = n)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45)) +
  labs(subtitle = "countries with less than 10 sources have been removed")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  group_by(press_freedom_rating) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2))

ggplot(df, aes(x = press_freedom_rating)) +
  geom_bar(stat = "count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  group_by(media_type) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2)) %>%
  arrange(desc(percentage))

df %>%
  group_by(media_type) %>%
  count %>%
  filter(n > 9) %>%
  ggplot(aes(x = media_type, y = n)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45)) +
  labs(subtitle = "media types with less than 10 sources have been removed")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  group_by(traffic_popularity) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2))

ggplot(df, aes(x = traffic_popularity)) +
  geom_bar(stat = "count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  group_by(mbfc_credibility_rating) %>%
  summarise(n = n(),
            percentage = round(n()/5157*100, 2))

ggplot(df, aes(x = mbfc_credibility_rating)) +
  geom_bar(stat = "count") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=45))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "least biased") %>%
  group_by(bias_rating) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "left bias") %>%
  group_by(bias_rating) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "left-center bias") %>%
  group_by(bias_rating) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "right-center bias") %>%
  group_by(bias_rating) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "right bias") %>%
  group_by(bias_rating) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "conspiracy-pseudoscience") %>%
  group_by(bias_rating) %>%
  summarise(n = n()) %>%
  arrange(desc(n))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "conspiracy-pseudoscience") %>%
  group_by(orientation) %>%
  summarise(n = n()) %>%
  arrange(desc(n))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "questionable source") %>%
  group_by(bias_rating) %>%
  summarise(n = n()) %>%
  arrange(desc(n))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(category == "questionable source") %>%
  group_by(orientation) %>%
  summarise(n = n()) %>%
  arrange(desc(n))


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$category, df$orientation, useNA = "ifany")

nrow(df)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table_category_orientation = df %>%
  group_by(category, orientation) %>%
  tally() %>%
  pivot_wider(names_from = orientation, values_from = n) %>%
  mutate(total = sum(left,right,`least biased`,`any other label`,`NA`, na.rm = T)) %>%
  mutate(percentage = round(total/nrow(df)*100,1)) %>%
  mutate(total_orientation = sum(left,right,`least biased`,`any other label`, na.rm = T)) %>%
  # calculate percentages
  mutate(left_percentage = round(left/total*100,1)) %>%
  mutate(right_percentage = round(right/total*100,1))

table_category_orientation_2 = table_category_orientation %>%
  select(!c(`NA`,`least biased`,`any other label`,total_orientation)) %>%
  relocate(category, total, percentage, left, left_percentage, right, right_percentage)

table_category_orientation_2[is.na(table_category_orientation_2)] = 0


table_category_orientation_2 = table_category_orientation_2 %>%
  rbind(tibble(category = "total",
               total = nrow(df),
               percentage = round(100,1),
               left = nrow(df %>% filter(orientation=="left")),
               left_percentage = round(nrow(df %>% filter(orientation=="left"))/nrow(df)*100,1),
               right = nrow(df %>% filter(orientation=="right")),
               right_percentage = round(nrow(df %>% filter(orientation=="right"))/nrow(df)*100,1),
               )
        )

table_category_orientation_2

table_category_orientation_2_kable = table_category_orientation_2 %>%
  kbl(format="latex",
      #col.names = c("cat","source","N","cat","source","N"),
      vline = "",
      toprule = "\\toprule",
      bottomrule = "\\bottomrule",
      midrule = "\\midrule",
      linesep = "")

nrow(df[is.na(df$bias_rating),])


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$category, df$science, useNA = "ifany")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$orientation, useNA = "ifany")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$category, useNA = "ifany")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$category, df$factual_reporting, useNA = "ifany")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(df, aes(x = category, fill=fct_rev(factual_reporting))) +
  geom_bar(stat = "count") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Consp-Pseu","Questionable","Pro-Science","Satire"))+
  #scale_fill_manual(values = c("darkgreen","green","yellow","orange","red","darkred"))+
  scale_fill_viridis(discrete = T, na.value = "grey50", direction=-1)+
  theme(axis.text.x = element_text(angle=15)) +
  labs(x = "",
       y = "",
       fill = "Factual Reporting",
       #title = "Bias Categories and Factual Reporting of MBFC",
       #subtitle = "Frequency of Factual Reporting Levels per Bias Category",
       #caption = "Data scraped 19-9-2022 from mediabiasfactcheck.com"
       )

ggsave("categories_and_factual_reporting.pdf", width = 6, height=2.5)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(df, aes(x = category, fill=fct_rev(factual_reporting))) +
  geom_bar(stat = "count", position="fill") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Consp-Pseu","Questionable","Pro-Science","Satire"))+
  #scale_fill_manual(values = c("darkgreen","green","yellow","orange","red","darkred"))+
  scale_fill_viridis(discrete = T, na.value = "grey50", direction=-1)+
  theme(axis.text.x = element_text(angle=15)) +
  labs(x = "",
       y = "",
       fill = "Factual Reporting",
       title = "Bias Categories and Factual Reporting of MBFC",
       subtitle = "Percentage of Factual Reporting Levels per Bias Category",
       caption = "Data scraped 19-9-2022 from mediabiasfactcheck.com")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$category, df$mbfc_credibility_rating, useNA = "ifany")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
#table(df$category, df$media_type)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
table(df$orientation, df$mbfc_credibility_rating)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(str_detect(reasoning, "propaganda")) %>%
  group_by(category) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(!is.na(reasoning)) %>%
  group_by(category) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
category_totals = df %>%
  group_by(category) %>%
  summarise(n_total = n())

category_totals_no_na = df %>%
  filter(!is.na(bias_rating)) %>%
  group_by(category) %>%
  summarise(n_total_no_na = n())


category_bias = df %>%
  group_by(category, orientation) %>%
  summarise(n_orientation = n())%>%
  left_join(category_totals) %>%
  left_join(category_totals_no_na)

category_bias %>%
  mutate(percentage = round(n_orientation / n_total * 100, 2)) %>%
  mutate(percentage2 = round(n_orientation / n_total_no_na * 100, 2)) %>%
  select(category, orientation, percentage, percentage2)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  ggplot(aes(x = category, fill=orientation)) +
  geom_bar(stat = "count") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Consp-Pseu","Questionable","Pro-Science","Satire"))+
  scale_fill_manual(values = c("grey","magenta","blue","red","grey"))+
  theme(axis.text.x = element_text(angle=15)) +
  labs(x = "",
       y = "",
       fill = "Bias Rating",
       title = "Bias Categories and Bias Ratings of MBFC",
       subtitle = "Frequency of 'left', 'right', 'least biased', and other labels in Bias Ratings for each Bias Category",
       caption = "Data scraped 19-9-2022 from mediabiasfactcheck.com")


# Paper version
df %>%
  filter(!is.na(bias_rating)) %>%
  ggplot(aes(x = category, fill=orientation)) +
  geom_bar(stat = "count") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Consp-Pseu","Questionable","Pro-Science","Satire"))+
  scale_fill_manual(values = c("grey","magenta","blue","red","grey"),
                      labels = c("Other Label","Least Biased","Left","Right"))+
  theme(axis.text.x = element_text(angle=15)) +
  labs(x = "Category",
       y = "",
       fill = "Bias Rating")

ggsave("mbfc_biascategories_biasratings.pdf", width = 7, height = 3)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df %>%
  filter(!is.na(bias_rating)) %>%
  ggplot(aes(x = category, fill=orientation)) +
  geom_bar(stat = "count", position = "fill") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Consp-Pseu","Questionable","Pro-Science","Satire"))+
  scale_fill_manual(values = c("grey","magenta","blue","red","grey"))+
  theme(axis.text.x = element_text(angle=15)) +
  labs(x = "",
       y = "",
       fill = "Bias Rating",
       title = "Bias Categories and Bias Ratings of MBFC",
       subtitle = "Percentage of 'left', 'right', 'least biased', and other labels in Bias Ratings for each Bias Category",
       caption = "Data scraped 19-9-2022 from mediabiasfactcheck.com")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df2 = df %>% left_join(output)


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df2 %>%
  group_by(check) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
df2 %>% group_by(check,category) %>%
  summarise(n())


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(df2, aes(x = category, fill=check)) +
  geom_bar(stat = "count") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Consp-Pseu","Questionable","Pro-Science","Satire"))+
  scale_fill_manual(values = c("green","red","grey"))+
  theme(axis.text.x = element_text(angle=15)) +
  labs(x = "",
       y = "",
       fill = "Website taken down",
       title = "Bias Categories and URL availability of MBFC",
       subtitle = "Frequency of website availability per MBFC category",
       caption = "Checked on 06-10-2022, from each website individually")


## -----------------------------------------------------------------------------------------------------------------------------------------------------------
ggplot(df2, aes(x = category, fill=check)) +
  geom_bar(stat = "count", position = "fill") +
  theme_bw() +
  scale_x_discrete(labels = c("Left","Cent-Left","Cent","Cent-Right","Right","Consp-Pseu","Questionable","Pro-Science","Satire"))+
  scale_fill_manual(values = c("green","red","grey"))+
  theme(axis.text.x = element_text(angle=15)) +
  labs(x = "",
       y = "",
       fill = "Website taken down",
       title = "Bias Categories and URL availability of MBFC",
       subtitle = "Percentage of website availability per MBFC category",
       caption = "Checked on 06-10-2022, from each website individually")

