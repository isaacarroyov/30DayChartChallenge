library(dplyr)
library(ggplot2)
library(ggtext)

# Load data
df <- read.csv('./2022/data/Global Temperature Anomalies.csv')

df <- df %>%
  mutate(condition = with(df, ifelse(Apr < 0, 1, 0))) %>%
  filter(Hemisphere!='Global')


theme_set(theme_minimal(base_family = 'Georgia'))


df %>%
  ggplot(aes(x=Year, y=Apr)) +
  geom_segment(data= subset(df, condition == 1),
               aes(x=Year, xend=Year, y=0, yend=Apr), color='#00798c', size=0.3) +
  geom_segment(data= subset(df, condition == 0),
               aes(x=Year, xend=Year, y=0, yend=Apr), color='#d1495b', size=0.3) +
  geom_point(size=0.7, color='#edae49') +
  geom_text(aes(label=Apr), size=0.6, color='black', family = 'Georgia') +
  ylim(-2,2) +
  xlim(1880, 2030) +
  facet_wrap(~Hemisphere, ncol=1) +
  coord_polar(start = 0, direction = 1) +
  labs(title= "Temperature anomalies in the Northern (_top_) and Southern (_bottom_) parts of the world",
       subtitle = "The visualization showcases the temperature anomaly changes from 1880 up to 2020. Temperatures **above zero** are <span style='color:#d1495b'>**red**</span>, and **below zero** are <span style='color:#00798c'>**blue**</span>",
       caption = "<b>data: _What's Warming The Earth?_ by Makeover Monday on data.world <br> Visualization by Isaac Arroyo (@unisaacarroyov)</b>") +
  theme(
    legend.position = 'none',
    plot.title.position = 'plot',
    panel.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    panel.grid = element_blank(),
    strip.text = element_blank(),
    plot.title = element_textbox_simple(margin = margin(10,0,20,0), size=10, face='bold'),
    plot.subtitle = element_textbox_simple(size=8),
    plot.caption = element_textbox_simple(size = 3, margin = margin(0,0,5,0), color='gray70'),
    panel.spacing.y = unit(-5,'lines'),
    plot.background = element_rect(fill='white', colour = 'white')
    
  )
ggsave("./2022/day_11/30daychartchallenge_day_11_circular.png", units = "px", width = 1080, height = 1920, scale = 1.5, dpi=600)
