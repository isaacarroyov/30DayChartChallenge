library(dplyr)
library(ggplot2)
library(ggtext)
library(MetBrewer)
library(gganimate)
# LOAD DATA
df <- read.csv("data/Male-Female-Ratio-of-Suicide-Rates.csv")
# DATA PROCESSING
df <- df %>%
  rename(male_female_suicide_ratio = Male.female.suicide.ratio) %>%
  filter(Entity=="Mexico" | Entity=="Latin America & Caribbean" | Entity=="North America" | Entity=="World") %>%
  select(Entity, Year, male_female_suicide_ratio) %>%
  as.data.frame()


# DATA VISUALIZATION
theme_set(theme_minimal(base_family = "Georgia"))

p1 <- df %>%
  ggplot(aes(x=Year, y=male_female_suicide_ratio, color = Entity)) + 
  geom_line(size=2, lineend = "round", linejoin="bevel") +
  scale_color_manual(values = met.brewer("Java",4)) +
  scale_x_continuous(breaks = seq(1990,2017,3)) +
  scale_y_continuous(breaks = seq(1,7,1), limits = c(1,7)) +
  labs(title = "Male-to-female ratio of suicide rates from 1990 to 2017",
       subtitle = "The <b>male-to-female suicide ratio</b> is the ratio between male and female suicide rate. A figure greater than one means suicide rates were higher in men; the higher the number, the large the difference between the genders.<br><br>From 1990 to 2017, <span style='color:#E1242C'><b>Mexico</b></span> had the highest rate compared with <span style='color:#6B2972'><b>Latin America & Caribbean</b></span>, <span style='color:#FB6B00'><b>North America</b></span> and <span style='color:#007354'><b>the World</b></span>",
       caption = "Source: Our World in Data in <em>Suicide: Suicide by gender</em><br>Visualization by Isaac Arroyo (@unisaacarroyov on Twitter)") +
  theme(
    legend.position = "none",
    panel.background = element_rect(fill='transparent', color = 'transparent'),
    plot.background = element_rect(fill='white', color = 'transparent'),
    panel.grid = element_blank(),
    panel.grid.major.y = element_line(linetype = 'dotted', color = 'gray70', size = 0.35),
    panel.grid.minor.y = element_line(linetype = 'dotted', color = 'gray70', size = 0.35),
    axis.title = element_blank(),
    axis.text = element_text(size=10, face = 'bold'),
    plot.title = element_textbox_simple(face = 'bold', size = 18, margin = margin(0,0,10,0)),
    plot.subtitle = element_textbox_simple(size = 11, margin = margin(0,0,5,0)),
    plot.caption = element_textbox_simple(halign = 1, size = 8, face = 'bold', color = 'gray60', margin = margin(10,0,0,0))
  )
p1
ggsave("./day_22/30daychartchallenge_day_22_animation.png",
       units = "px", width = 1080, height = 1080, scale = 1.7)
# CREATE ANIMATION
animation <- p1 +
  transition_reveal(Year) +
  ease_aes('linear')

# RENDER
animate(animation, nframes = 300, duration = 10, fps = 30, end_pause = 1, rewind = F)

# SAVE ANIMATION
anim_save(filename = "30daychartchallange_day_22_animation.gif", animation = animation, path = "./day_22/")
