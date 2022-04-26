library(dplyr)
library(ggplot2)
library(tidyr)
library(ggtext)
library(MetBrewer)

df <- read.csv("./data/ROSALIA_MOTOMAMI_Audio_Features.csv")

# Data processing
df <- df %>%
  mutate(
    loudness = ((loudness - min(loudness))/
                  (max(loudness)-min(loudness))),
    duration_min = (duration_ms/1000)/60
    ) %>%
  select(song_name, number_song, duration_min,
         danceability, energy, loudness,
         speechiness, acousticness, valence) %>%
  pivot_longer(cols = 4:9, names_to = "audio_feature", values_to = "values")



df %>%
  ggplot(aes(x=1, y=1, label=paste("song", number_song, "-",values), color=audio_feature, size=values) ) +
  geom_jitter() +
  geom_text(size=2, position=position_jitter(width = 0.05, height = 0.5), fontface='bold') +
  scale_color_manual(values = met.brewer('Signac', 6)) +
  scale_size_area(max_size = 15) +
  coord_cartesian(clip = "off") +
  theme_light() +
  facet_wrap(~song_name) +
  theme(
    #legend.position = "none",
    axis.text = element_blank(),
    panel.grid = element_blank(),
    #strip.text = element_text(color='black', size=5),
    strip.text = element_textbox_simple(size=6, color='black', height = 0.03),
    )

ggsave("./../2022/day_15/base_chart_day_15.svg", units = "px",
       width = 1080, height = 1080, scale = 1.5)
