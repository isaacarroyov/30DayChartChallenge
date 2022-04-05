# Day 5 : Slope
library(dplyr)
library(ggplot2)
library(ggtext)
library(GGally)
library(MetBrewer)

df <- read.csv("https://raw.githubusercontent.com/justinminsk/Pokemon-Stats/master/Pokemon.csv")

df <- df %>%
  filter(Legendary == "True")

pokemon_legends = df %>%
  group_by(Type.1) %>%
  summarise(Attack = mean(Attack),
            Defense = mean(Defense),
            ) %>%
  filter(Type.1 == "Water"|Type.1 == "Rock"|Type.1 == "Fire"|Type.1 == "Grass"|Type.1 == "Flying") 


# Create Data Visualization
theme_set(theme_light(base_family = "Georgia"))

pokemon_legends %>%
  ggparcoord(showPoints = T,
             columns = c(2,3),
             scale = 'globalminmax',
             groupColumn = 1) + 
  labs(title="Comparing <span style='font-size:20pt'>**Attack**</span> and <span style='font-size:20pt'>**Defense**</span> between Legendary Pokemons",
       subtitle = "In order to avoid a _spaghetti chart_, the number of pokemon types is reduced",
       caption="_**Data:**_ Pokemon dataset <br> _**Visualization by Isaac Arroyo (@unisaacarroyov)**_"
       ) +
  ylab("Score") +
  scale_colour_manual(values = met.brewer("Johnson",6)) +
  coord_cartesian(clip="off") +
  theme(
    plot.title.position = 'plot',
    plot.title = element_textbox_simple(size = 17),
    plot.subtitle = element_textbox_simple(size=11, padding = margin(5,0,5,0)),
    plot.caption = element_markdown(size = 8, color='gray80'),
    axis.title.x = element_blank(),
    axis.text.x = element_text(face='bold', size=13),
    axis.text.y = element_text(face='bold'),
    axis.title.y = element_text(face = 'bold', angle = 0, size=13),
    plot.background = element_rect(colour = 'white', fill = 'white'),
    panel.background = element_rect(colour = 'white', fill= 'white'),
    panel.grid.major.y = element_line(color='black', linetype = 'dotted', size=0.1),
    panel.grid.minor.y = element_line(color='black', linetype = 'dotted', size=0.1),
    panel.grid.major.x = element_line(color='gray95', linetype = 'solid', size=2),
    legend.position = "top",
    legend.title = element_blank(),
    legend.text = element_text(size=12, face='bold'),
    legend.box.margin = margin(10,100,0,0),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
  )
ggsave("./2022/day_05/30daychartchallenge_day_05_slope.png", width = 1080, height = 1080, scale = 1.8, units = "px")  
