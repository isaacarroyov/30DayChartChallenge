library(dplyr)
library(ggplot2)
library(ggtext)
library(MetBrewer)



# Load and prepare the data
# Source: https://sdg-tracker.org/cities
df <- read.csv("./2022/data/deaths-and-missing-persons-due-to-natural-disasters.csv")
df <- df %>% rename(death_missing_per_100k = X11.5.1...Number.of.deaths.and.missing.persons.attributed.to.disasters.per.100.000.population..number....VC_DSR_MTMP)

# Filter by 10 most populated countries in Latin American Countries
# Source: https://www.worldometers.info/geography/how-many-countries-in-latin-america/
df_latam <- df %>%
  filter(Entity == "Mexico" | Entity == "Brazil" | Entity == "Colombia" | Entity == "Argentina" | Entity == "Peru" | Entity == "Venezuela" | Entity == "Chile" | Entity == "Guatemala" | Entity == "Ecuador" | Entity == "Bolivia") %>%
  mutate(Year = factor(Year), Entity = factor(Entity))

# D A T A   V I S U A L I Z A T I O N
theme_set(theme_light(base_family = "Georgia"))

# Create a grid of lollipop plots (each grid is a year or a country)
df_latam %>%
  ggplot(aes(x=Entity, y=death_missing_per_100k, color = Entity, label= round(death_missing_per_100k,1))) +
  geom_point(size=0.5) +
  geom_text( aes(x=Entity, y= death_missing_per_100k),  size=0.55, family='Georgia', color='black') +
  geom_segment(aes(xend=Entity, y=0, yend=death_missing_per_100k), size=0.2, show.legend = F) +
  guides(color = guide_legend(keyheight = unit(10,'points'),
                              keywidth = unit(1,"points"),
                              title = "",
                              override.aes = list(size=2), nrow = 3
                              )
         ) +
  scale_color_manual(values = met.brewer("Redon", 10)) +
  ylim(0,57) +
  coord_polar(theta = 'y', clip = 'off', start = -pi/2) +
  facet_wrap(~Year) +
  labs(title = "<b>Sustainable Development Goal 11: Sustainable Cities and Communities</b>",
       subtitle = "<span style='font-size:7pt'><b>Target 11.5: Reduce the adverse effects of natural disasters</b></span><br><br><b>_Definition:_</b> **Indicator 11.5.1** is the number of deaths, missing persons and directly affected persons attributed to disasters per 100,000 population.<br><br>Indicators measured here report mortality rates, internally displaced persons, total numbers affected by natural disasters.<br><br>This visualization showcases the yearly behaviour of the ten most populated countries in Latin America (2020)",
       caption = "<b>data: our world in data (OWID)<br>visualization by isaac arroyo (@unisaacarroyov)</b>"
       ) +
  theme(
    plot.title = element_textbox_simple(margin = margin(5,0,20,0), size=9,  minwidth = 1),
    plot.subtitle = element_textbox_simple(margin = margin(0,0,10,0), size = 6.5, minwidth = 1),
    plot.caption = element_markdown(size=4, color='gray70'),
    plot.background = element_rect(fill = 'white'),
    plot.margin = margin(0,0,5,0),
    panel.background = element_rect(fill = 'white'),
    legend.position = "top",
    legend.text = element_text(size=6, face='bold'),
    legend.margin = margin(5,0,-5,0),
    legend.box.margin = margin(0,0,0,0),
    legend.background = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    panel.grid.major.x = element_line(color='gray90', linetype = "dashed", size=0.07),
    strip.background = element_blank(),
    strip.text = element_text(color='black', face = 'bold', family = 'Georgia', size = 7)
  )
ggsave("./2022/day_06/30daychartchallenge_day_06_owid.png",
       units = "px", width = 323, height = 576, scale = 12.25, dpi=1200)
