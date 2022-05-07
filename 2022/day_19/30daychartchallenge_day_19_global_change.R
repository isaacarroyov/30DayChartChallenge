library(dplyr)
library(ggplot2)
library(ggtext)
library(ggrepel)
library(MetBrewer)

# LOAD DATA
df <- read.csv("./data/life-expectancy.csv")

# DATA PROCESSING
df <- df %>%
  rename(life_expectancy = Life.expectancy) %>%
  filter(Entity=='World' | Entity == "Americas" | Entity == "Africa" | Entity == "Europe" | Entity == "Oceania" | Entity == "Asia",
         Year>=1950) %>%
  select(Entity, Year, life_expectancy) %>%
  mutate(Entity = as.factor(Entity))



# DATA VISUALIZATION
theme_set(theme_minimal(base_family = 'Optima'))

df %>%
  ggplot(aes(x=Year, y=life_expectancy, color = Entity)) + 
  geom_line() + 
  scale_color_manual(values = met.brewer("Troy",6)) + 
  geom_richtext(
    data = tribble(
      ~x, ~y, ~notes,
      2020, 63, "**Africa:** 63.17 years old", 
      2020, 76, "**Americas:** 76.83 years old",
      2020, 74, "**Asia:** 73.59 years old", 
      2020, 78, "**Europe:** 78.58 years old", 
      2020, 80, "**Oceania:** 78.71 years old",
      2020, 72, "**World:** 72.58 years old", 
    ),
    aes(x=x, y=y, label= notes),
    fill = 'transparent', label.colour = 'transparent',
    color = met.brewer("Troy",6),
    size = 3.25, hjust = 0, family = 'Optima'
  ) + 
  coord_cartesian(clip = 'off') + 
  xlim(1950,2045) + 
  #ylab("Life Expectancy in **Years**") +
  labs(title = "<b>We are (on average) living more: Worldwide life expectancy in 2019</b>",
       subtitle = "All continents show an increasing life expectancy since 1950. Perhaps we are not going to be immortal (or is it too soon to answer that question?), but we are definitely living longer than before.",
       caption = "Data: Our World in Data <br> Visualization by Isaac Arroyo (@unisaacarroyov on Twitter)") +
  theme(
    plot.background = element_rect(fill='white'),
    panel.background = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    panel.grid.major = element_line(color = 'gray90', linetype = 'dotted', size = 0.5),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.title = element_textbox_simple(size = 15, margin = margin(5,0,15,0)),
    plot.subtitle = element_textbox_simple(size = 11, margin = margin(0,0,10,0)),
    plot.caption = element_textbox_simple(halign = 0, size = 8, margin = margin(10,0,0,0), face = 'italic', color = 'gray55'),
    axis.text = element_text(face = 'bold'),
    axis.title = element_blank()
  )
ggsave("./day_19/30daychartchallenge_day_19_global_change.png",
       units = "px", width = 1080, height = 1080, scale = 1.7)
  