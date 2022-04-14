library(dplyr)
library(ggplot2)
library(ggtext)
library(ggrepel)
library(MetBrewer)
library(sysfonts)

# Load Spotify data
df <- read.csv("https://raw.githubusercontent.com/isaacarroyov/data_visualization_practice/master/data/spotify_songs_01_pca.csv")


# Correlation 
# x -> energy
# y -> loudness
# colour -> acousticness
theme_set(theme_minimal(base_family = "Optima"))

df %>%
  ggplot(aes(x=energy, y=loudness, color=acousticness, label=name)) +
  geom_point() +
  scale_color_gradientn(colours = met.brewer("Hiroshige")) +
  labs(title = '<b>Exploring my Spotify data: Energy, Loudness and Acousticness</b>',
       subtitle = 'The main audio features to explore are **Energy** (_x_-axis), a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity and **Loudness** (_y_-axis), the quality of a sound that is the primary psychological correlate of physical strength (amplitude) that ranges between -60 and 0 dB. An extra encoding is **Acousticness** (colour), the confidence measure from 0.0 to 1.0 of whether the track is acoustic. 1.0 represents high confidence the track is acoustic.<br><br>Interestingly, there is also a correlation between **Acousticness** and **Energy**',
       caption = "<b>Data: Spotify personal data.<br>Visualization by Isaac Arroyo (@unisaacarroyov)</b>") +
  xlab("Energy") + ylab("Loudness in decibels (dB)") +
  guides(color= guide_colorbar(title='<b>Acousticness</b>',
                               ticks = F, 
                               reverse = T,
                               title.position = "top",
                               barwidth = unit(450,"pt"),
                               barheight = unit(10, "pt"),
                               )) +
  theme(
    plot.background = element_rect(fill = 'white'),
    panel.grid = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    plot.title = element_textbox_simple(size=20, margin = margin(0,0,10,0)),
    plot.subtitle = element_textbox_simple(size=10, margin = margin(0,0,20,0)),
    plot.caption = element_markdown(size=8, color = 'gray60'),
    legend.title = element_markdown(size=10),
    axis.title = element_markdown(size=10, face = 'bold'),
    axis.text = element_text(face='italic', colour = 'gray30'),
    legend.text = element_text(face='italic', colour = 'gray30'),
    plot.title.position = 'plot',
    legend.position = "top",
    legend.margin = margin(0,30,0,0),
    panel.grid.major = element_line(linetype = 'dotted', size=0.1),
    panel.grid.minor = element_line(linetype = 'dotted', size=0.1),
  )

ggsave("./2022/day_13/30daychartchallenge_day_13_correlation.png",
       units = "px", width = 1080, height = 1080, scale = 1.8, dpi = 300)


