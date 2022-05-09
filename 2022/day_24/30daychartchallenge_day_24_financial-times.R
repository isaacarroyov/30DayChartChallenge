library(dplyr)
library(ggplot2)
library(ggtext)

# Global mean sea level rise is measured
# relative to the 1993 - 2008 average sea level

# LOAD DATA
df <- read.csv("./data/climate-change.csv")

# PROCESS DATA
df <- df %>%
  filter(Entity == "World", !is.na(Average)) %>%
  select(Entity, Date, Average) %>%
  rename(world_average_sea_level = Average, recorded_date = Date) %>%
  mutate(recorded_date = lubridate::ymd(recorded_date)) %>%
  group_by(recorded_date = lubridate::floor_date(recorded_date,"month")) %>%
  summarise(mean_world_average_sea_level = mean(world_average_sea_level)) 

# Data Visualization
theme_set(theme_minimal(base_family = "Verdana"))

df %>%
  ggplot(aes(x=recorded_date, y=mean_world_average_sea_level)) + 
  geom_line() +
  #scale_x_date(breaks = seq(from = as.Date("1880-01-01"), to = as.Date("2020-12-31"), length.out = 10)) + 
  labs(title = "HOLA me llamo Isaac Arroyo",
       subtitle = "HOLA DE NUEVO",
       caption = "Data: Our World in Data in _Climate Changte Impact Data Explorer_<br>Visualization by Isaac Arroyo (@unisaacarroyov on Twitter)") +
  theme(
    plot.title = element_textbox_simple(),
    plot.subtitle = element_textbox_simple(),
    plot.caption = element_textbox_simple(halign = 1),
    
    axis.title.x = element_blank()
  )
  
