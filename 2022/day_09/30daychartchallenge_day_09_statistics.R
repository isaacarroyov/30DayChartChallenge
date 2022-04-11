# Packages/Libraries
library(dplyr)
library(ggplot2)
library(ggdist)
library(ggtext)
library(MetBrewer)
library(patchwork)
# Values
# Exponential with lambda = 0.2 => E(X) = 1/lambda; Var(X) = 1/lambda**2
exponential_values = rexp(500, rate = 0.2)


# Central Limit Theorem function
make_dist_central_limit_theorem <- function (v ,iters, sample_size){
  vector_sample <- c()
  for (i in 1:iters){
    vector_sample[i] <- mean(sample(v, sample_size, replace = TRUE))
  }
  return(vector_sample)
}


# CLT Exponential
clt_exponential <- make_dist_central_limit_theorem(exponential_values, iters = 500, sample_size = 20)

# Create data frames
df <- data.frame(exponential_data = exponential_values,
                 exponential_clt = clt_exponential)


# Data Visualization
theme_set(theme_minimal(base_family = "Georgia"))
theme_update(
  panel.background = element_rect(fill = 'white', colour = 'white'),
  plot.background = element_rect(fill = 'white', colour = 'white'),
  panel.grid = element_blank(),
  axis.title = element_blank(),
  axis.text.y = element_blank(),
  plot.title = element_textbox_simple(size = 20, margin = margin(0,0,5,0)),
  plot.subtitle = element_textbox_simple(size=11),
  plot.caption = element_markdown(size=7, colour = "gray60"),
  axis.text.x = element_text(margin = margin(-15,0,0,0), face = 'bold', size=10)
)
# -> Create an arrange of 2x2 in illustrator
p1 <- df %>% ggplot(aes(x=exponential_data)) +
  stat_dots(dotsize=1.05, scale=1, color=NA, fill='#0C3B5A') +
  geom_segment(x=mean(df$exponential_data), xend=mean(df$exponential_data), y=0, yend=1) +
  stat_interval(aes(y = -.015), show.legend = F, height=0, .width = c(.25, .5, .95, 1)) +
  scale_color_manual(values = met.brewer("Hokusai2",4) ) +
  labs(title = "In the beginning...",
       subtitle = "we have a set of points or data following the **Exponential distribution**. Nevertheless, we are going to calculate the mean of a sample size of ten (random) elements with replacement (meaning that repeated elements could be in it) several times (five hundred)",
       #caption = "<span style='color:white'>Visualization by Isaac Arroyo (@unisaacarroyov)</span>"
       caption = "_Visualization by Isaac Arroyo (@unisaacarroyov)_"
       ) +
  geom_curve(
    data = tribble(
      ~x1,~x2,~y1,~y2,
      12, round(mean(df$exponential_data),2) + 0.5, 0.73, 0.6
    ),
    aes(x=x1,xend=x2,y=y1,yend=y2),
    arrow=arrow(length = unit(10,'points')),
    size = 0.6, color='black', curvature = -0.3) +
  annotate(geom = 'text', family= 'Georgia', size = 4,
           x= 7, y= 0.8, hjust=0,
           label = glue::glue("number of instances: 500")) +
  annotate(geom = 'text', family= 'Georgia', size = 4,
           x= 7, y= 0.75, hjust=0,
           label = glue::glue("expected value (or mean): {round(mean(df$exponential_data),3)} "))
p1
ggsave("./2022/day_09/30daychartchallenge_day_09_statistics_01.png",
       units = "px", scale=1.8, width = 1080, height = 1080 )


# ...
p2 <- df %>% ggplot(aes(x=exponential_clt)) + 
  stat_dots(dotsize=1.05, scale=1, color=NA, fill='#772B18') +
  geom_segment(x=mean(df$exponential_clt), xend=mean(df$exponential_clt), y=0, yend=1, size=1) +
  stat_interval(aes(y = -.015), show.legend = F, height=0, .width = c(.25, .5, .95, 1)) +
  scale_color_manual(values = met.brewer("OKeeffe2",4) ) +
  labs(title = "and later...",
       subtitle = "we will end up with a distribution looking like a **Gaussian distribution**. This is my quick and visual explanation of the **Central Limit Theorem**.",
       caption = "_Visualization by Isaac Arroyo (@unisaacarroyov)_") +
  geom_curve(
    data = tribble(
      ~x1,~x2,~y1,~y2,
      8, round(mean(df$exponential_clt),2) + 0.15, 0.8, 0.995
    ),
    aes(x=x1,xend=x2,y=y1,yend=y2),
    arrow=arrow(length = unit(10,'points')),
    size = 0.6, color='black', curvature = 0.5) +
  annotate(geom = 'text', family= 'Georgia', size = 4,
           x= 6, y= 0.77, hjust=0,
           label = glue::glue("the distribution's expected value is {round(mean(df$exponential_clt),3)} "))
p2
ggsave("./2022/day_09/30daychartchallenge_day_09_statistics_02.png",
       units = "px", scale=1.8, width = 1080, height = 1080 )


p1 + p2
ggsave("./2022/day_09/30daychartchallenge_day_09_statistics_both.png",
       units = "px", scale=1.8, width = 2160, height = 1080 )
