library(dplyr)

# LOAD DATA
df <- read.csv("https://raw.githubusercontent.com/isaacarroyov/data_visualization_practice/master/data/share-electricity-nuclear.csv")

# DATA PROCESSING
df<- df %>%
  rename(percentage_share_electricity_from_nuclear = Nuclear....electricity.) %>%
  select(Entity, Year, percentage_share_electricity_from_nuclear) %>%
  filter(Entity == 'Japan' | Entity=='Ukraine')
  
  
df %>%
  tidyr::pivot_wider(names_from = Entity, values_from = percentage_share_electricity_from_nuclear) %>%
  as.data.frame() %>%
  write.csv("./data/share_nuclear_electricity_japan_ukraine.csv", row.names = F)
