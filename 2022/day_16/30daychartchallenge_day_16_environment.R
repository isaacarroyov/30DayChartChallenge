library(dplyr)
library(ggplot2)

# LOAD DATA
df_forest_share <- read.csv("data/forest-area-as-share-of-land-area.csv")
df_mammals <- read.csv("data/endemic-mammal-species-by-country.csv")
df_amphibians <- read.csv("data/endemic-amphibian-species-by-country.csv")
df_birds <- read.csv("data/endemic-bird-species-by-country.csv")

# Filter forest share 
df_forest_share <- df_forest_share %>%
  filter(Year==2020) %>%
  select(Entity, Code, Forest.cover)

# Merge animals into one data frame
df_endemic_species <- df_mammals %>%
  filter(Code != "") %>%
  inner_join(df_birds, by="Code", na_matches="never") %>%
  inner_join(df_amphibians, by="Code", na_matches="never") %>%
  rename(Country = Entity.x,
         total_endemic_mammals = Mammals..total.endemic.,
         total_endemic_birds = Birds..total.endemic.,
         total_endemic_amphibians = Amphibians..total.endemic.
         ) %>%
  select(Country, Code, total_endemic_mammals,
         total_endemic_birds, total_endemic_amphibians) %>%
  rowwise() %>%
  mutate(total_endemic_species = sum(total_endemic_mammals,
                                     total_endemic_birds,
                                     total_endemic_amphibians)) %>%
  arrange(desc(total_endemic_species)) %>%
  as.data.frame()

# Merge forest share and endemic species
df <- df_endemic_species %>%
  inner_join(df_forest_share, by="Code", na_matches = "never") %>%
  rename(percentage_forest = Forest.cover) %>%
  select(Country, Code, total_endemic_species,
         total_endemic_mammals, total_endemic_birds,
         total_endemic_amphibians, percentage_forest)

# Number of endemic animals in 2020 worldwide
total_endemic_species_world <- sum(df$total_endemic_species)

# Countries with more than de 70% share of those species
df_more_than_70_percent_endemic_animals_world <- df %>%
  slice_max(total_endemic_species, n=15)


# Correlation
df_more_than_70_percent_endemic_animals_world %>%
  select(total_endemic_species, percentage_forest) %>%
  cor()

# Add continet
df_more_than_70_percent_endemic_animals_world <- df_more_than_70_percent_endemic_animals_world %>%
  mutate(continent = c("Asia","America","Oceania","Africa",
                       "America","America","America","Oceania",
                       "Asia","Asia","America","Asia",
                       "America","America","Asia")
         )

df_more_than_70_percent_endemic_animals_world %>%
  write.csv(., file = "./data/top15_countries_endemic_species_animals.csv") 
