library(dplyr)
library(ggplot2)
library(ggtext)

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

# DATA VISUALIZATION
theme_set(theme_minimal(base_family = "Verdana"))

df %>%
  ggplot(aes(x=recorded_date, y=mean_world_average_sea_level)) + 
  geom_hline(yintercept = 0, size = 0.5, linetype = 'dashed', color = '#C25474') +
  geom_line(color = '#00777E', size = 0.6) +
  annotate(geom = "text", label = "The zero mark is the\n1993 to 2008\naverage sea level", family = "Verdana",
           x = as.Date("1890-01-01"), y = -23, vjust = 1,
           size = 2.5,
           color = '#C25474', fontface = 'bold') +
  geom_curve(
    data = tribble(
      ~x1,~x2,~y1,~y2,
      as.Date("1908-01-01"), as.Date("1915-10-01"), -33,-3
    ),
    aes(x=x1,xend=x2,y=y1,yend=y2),
    arrow = arrow(length = unit(5,'points')),
    curvature = 0.5,
    color = '#C25474',
    size = 0.7
  ) + 
  scale_x_date(breaks = seq(from = as.Date("1880-01-01"), to = as.Date("2020-12-31"), length.out = 10),
               date_labels = "%Y" ) + 
  scale_y_continuous(breaks = seq(-200,100,30), labels = paste(breaks = seq(-200,100,30),"mm") ) +
  coord_cartesian(clip = "off") +
  labs(title = "Climate Change Impact: Sea level rise",
       subtitle = "The climatic crisis has caused several significant changes globally; one of them is the rising sea level. Global mean sea level rise is measured (in millimetres) relative to the <span style='color:#C25474'><b>1993 - 2008 average sea level</b></span>.",
       caption = "Data: Our World in Data in _Climate Changte Impact Data Explorer_<br>Visualization by Isaac Arroyo (@unisaacarroyov on Twitter)") +
  theme(
    plot.title.position = "plot",
    plot.caption.position = "plot",
    panel.background = element_rect(fill='transparent', color = 'transparent'),
    plot.background = element_rect(fill = '#FFF0DD', color = '#FFF0DD'),
    panel.grid.major.y = element_line(color='#5E5047', linetype = 'dotted',size = 0.25),
    axis.ticks.x = element_line(size=0.25, lineend = 'round', color = '#5E5047'),
    axis.ticks.length.x = unit(5,"points"),
    plot.title = element_textbox_simple(size = 18, face = 'bold', margin = margin(0,0,8,0)),
    plot.subtitle = element_textbox_simple(size = 11, color = '#5E5047', margin = margin(0,0,0,0)),
    plot.caption = element_textbox_simple(halign = 1, color = '#5E5047', size = 8),
    axis.text.y = element_text(color = '#5E5047', size = 9),
    axis.text.x = element_text(color = '#5E5047', size = 9, margin = margin(5,0,10,0)),
    axis.title = element_blank(),
    panel.grid = element_blank(),
  )
  
ggsave("./day_24/30daychartchallenge_day_24_financial-times.png",
       units = "px", width = 1080, height = 1080, scale = 1.8)
