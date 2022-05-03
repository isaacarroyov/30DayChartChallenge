library(dplyr)
library(tidyr)
library(ggplot2)
library(ggtext)

# LOAD DATA
df <- read.csv("./data/DP_LIVE_03052022210917969.csv")

# DATA MANIPULATION
df_wider <- df %>%
  select(LOCATION, SUBJECT, Value) %>%
  pivot_wider(names_from = SUBJECT, values_from = Value) %>%
  as.data.frame()

# DATA VISUALIZATION
df_wider %>%
  ggplot(aes(y=LOCATION)) +
  geom_segment(aes(y=LOCATION,yend=LOCATION, x=0, xend= VEGELOSS2004 ), color='white', size = 0.5) + 
  geom_segment(aes(y=LOCATION,yend=LOCATION, x=VEGEGAIN2004, xend=VEGELOSS2004), color = '#07517A', size=0.35) +
  geom_point(aes(x=VEGEGAIN2004), color='#07517A', size=2) +
  geom_point(aes(x=VEGELOSS2004), shape= 23, color='#07517A', fill = '#DFEFF8', size = 2, stroke=1) +
  labs(title='title',
       subtitle ='subtitle',
       caption='Data: OECD (2022), Land cover change (indicator). doi: 10.1787/3dee7330-en (Accessed on 03 May 2022) <br> Visualization by Isaac Arroyo (@unisaacarroyov on twitter)') +
  theme(
    plot.background = element_rect(fill='white'),
    panel.background = element_rect(fill='#DFEFF8'),
    plot.title = element_textbox_simple(),
    plot.subtitle = element_textbox_simple(),
    plot.caption = element_textbox_simple(),
    axis.title = element_blank(),
    axis.text.y = element_text(face = 'bold'),
    axis.text.x = element_text(face = 'italic'),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(colour = 'white', size=0.5)
  )

