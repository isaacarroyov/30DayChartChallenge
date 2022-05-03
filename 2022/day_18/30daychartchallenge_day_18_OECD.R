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
  geom_point(aes(x=VEGELOSS2004), shape= 23, color='#7A3007', fill = '#DFEFF8', size = 2, stroke=1) +
  scale_y_discrete(limits=rev) +
  scale_x_continuous(labels = scales::percent_format(scale=1)) +
  labs(title="Are we <span style='color:#07517A'><b>gaining</b></span> or <span style='color:#7A3007'><b>losing</b></span> vegetation? Depends on the country",
       subtitle ="The chart <b>showcases the changes in land cover since 2004</b>, this includes tree cover, grassland, wetland, shrubland and sparse vegetation converted to any other land cover type.<br>Countries like <span style='color:#07517A'><b>Israel (ISR), Costa Rica (CRI), Portugal (PRT)</b></span> and <span style='color:#07517A'><b>Denmark (DNK)</b></span> show an <span style='color:#07517A'><b> increase higher than 4.5%</b></span>. On the other side, <span style='color:#7A3007'><b>Israel (ISR)</b></span> and <span style='color:#7A3007'><b>Korea</b></span> exhibit <span style='color:#7A3007'><b>losses above 5%</b></span>",
       caption="Data: OECD (2022), Land cover change (indicator). doi: <em>10.1787/3dee7330-en</em> (Accessed on 03 May 2022) <br> Visualization by Isaac Arroyo (@unisaacarroyov on twitter)") +
  theme(
    plot.title.position = 'plot',
    plot.caption.position = 'plot',
    plot.background = element_rect(fill='white'),
    panel.background = element_rect(fill='#DFEFF8'),
    plot.title = element_textbox_simple(size=17, margin = margin(0,0,0,0), family = 'Georgia'),
    plot.subtitle = element_textbox_simple(size=10, margin = margin(15,0,15,0), family = 'Georgia'),
    plot.caption = element_textbox_simple(size=6, margin = margin(10,0,0,0), halign = 1, face='bold', color = 'gray60', family = 'Optima'),
    axis.title = element_blank(),
    axis.text.y = element_text(face = 'bold', family = 'Optima', size = 8),
    axis.text.x = element_text(face = 'bold.italic', family = 'Optima', size = 8),
    panel.grid.major.x = element_line(colour = 'white', size=0.5),
    panel.grid.minor.x = element_line(colour = 'white', size=0.5),
    panel.grid.major.y = element_blank(),
    axis.ticks = element_blank()
  )
ggsave("./day_18/30daychartchallenge_day_18_OECD.png",
       units = "px", height = 1350, width = 1080, scale=1.5)
