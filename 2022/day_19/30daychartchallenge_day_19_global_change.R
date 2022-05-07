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
  ggplot(aes(x=Year, y=life_expectancy, color = Entity, label = Entity)) + 
  geom_line() + 
  scale_color_manual(values = met.brewer("Java",6)) + 
  coord_cartesian(clip = 'off') + 
  #ylab("Life Expectancy in **Years**") +
  labs(title = "Are getting old? Thankfully, <b>yes</b>. Are we going to be inmortals? <b>I don't think so</b> (or perhaps it's to soon to answer that question)",
       subtitle = "Subtitle",
       caption = "Data: Our World in Data <br> Visualization by Isaac Arroyo (@unisaacarroyov on Twitter)") +
  annotate(geom = "text", x=2023, y=65, family = "Optima", label = "Hola") + 
  theme(
    plot.background = element_rect(fill='white'),
    panel.background = element_blank(),
    panel.grid = element_blank(),
    legend.position = "none",
    panel.grid.major.y = element_line(color = 'gray80', linetype = 'dotted', size = 0.5),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.title = element_textbox_simple(size = 15, margin = margin(0,0,10,0)),
    plot.subtitle = element_textbox_simple(size = 12, margin = margin(0,0,10,0)),
    plot.caption = element_textbox_simple(halign = 1, size = 8, margin = margin(10,0,0,0), face = 'italic', color = 'gray55'),
    axis.title = element_blank()
  )

  