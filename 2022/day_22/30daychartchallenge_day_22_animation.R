library(dplyr)

# LOAD DATA
df <- read.csv("data/Male-Female-Ratio-of-Suicide-Rates.csv")

# DATA PROCESSING
df %>%
  rename(male_female_suicide_ratio = Male.female.suicide.ratio) %>%
  filter(Entity=="Mexico" | Entity=="Latin America & Caribbean" | Entity=="North America" | Entity=="World") %>%
  select(Entity, Year, male_female_suicide_ratio) %>%
  write.csv("./../../male_female_suicide_ratio_americas_world.csv",row.names =  F )
