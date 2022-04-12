library(dplyr)
library(lubridate)
library(ggplot2)
library(ggtext)
library(grid)

# CARGAR DATOS
df <- read.csv("./2022/data/datos_historicos_USD_MXN.csv")

# PROCESAR DATOS
df <- df %>%
  mutate(Fecha = as.Date(Fecha, format = "%d.%m.%Y")) %>%
  rename( variance = X..var.) %>%
  mutate(variance = strsplit(variance, "%")) %>%
  mutate(variance = as.numeric(variance)) %>%
  group_by(week_fecha = floor_date(Fecha, "week")) %>%
  summarise(mean_cierre = mean(Cierre),
            mean_apertura = mean(Apertura),
            mean_max = mean(Máximo),
            mean_min = mean(Mínimo))



# DATA VISUALIZATION
# Visualizar el cambio del precio de dolar en pesos a traves del tiempo
# principalmente la columna de cierre
#   - Cada punto es un valor de la columna de cierre


df %>%
  ggplot(aes(x=week_fecha)) +
  geom_rect(xmin=as.Date("2020-03-01"), xmax=as.Date("2020-05-31"), ymin=10, ymax=25, fill='#E3EBF0', alpha=0.1) +
  geom_path(aes(y=mean_cierre), size=0.5, color='#3E51B5') +
  geom_textbox(
    data = tribble(
      ~x, ~y, ~label,
      as.Date("2017-07-01"), 23.5, '**Primer trimestre del protocolo "Quédate en casa" (Marzo - Mayo del 2020)**'
    ),
    aes(x=x,y=y,label=label),
    size=3, family='Georgia', box.colour = 'white'
  ) +
  #geom_point(aes(y=mean_cierre), size=0.5, color = '#3E51B5') + 
  scale_colour_gradient2(low='#E3120B', mid='#E3EBF0', high='#3E51B5') +
  labs(title = "El dólar a través del tiempo",
       subtitle = "Datos históricos del valor del dólar estadounidense en pesos mexicanos en los últimos 10 años. ",
       caption = "Datos: Portal Investing.com <br> Visualización por Isaac Arroyo (@unisaacarroyov)") +
  scale_y_continuous() +
  theme(
    plot.title = element_textbox_simple(size=15, margin = margin(20,0,10,0), color='#E3120B', face = 'bold', family='Georgia'),
    plot.subtitle = element_textbox_simple(size=12, margin = margin(0,0,20,0), color = '#121212', face = 'bold', family='Georgia'),
    plot.caption = element_markdown(size=6, family='Georgia', face='bold', color='gray40'),
    legend.position = 'top',
    plot.title.position = 'plot',
    plot.background = element_rect(fill = 'white', color = 'white'),
    panel.background = element_blank(),
    panel.grid = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.text.x = element_text(face='bold', size= 10, family='Georgia'),
    panel.grid.major.y = element_line(size=0.5, color = '#D7D7D7'),
  )
ggsave("./2022/day_12/30daychartchallenge_day_12_the_economist.svg",
       width = 675, height = 540, units = "px", scale=3)
