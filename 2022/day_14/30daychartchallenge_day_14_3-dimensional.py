import pandas as pd
import plotly.express as px

# LOAD THE DATA
df = pd.read_csv("https://raw.githubusercontent.com/isaacarroyov/data_visualization_practice/master/data/spotify_songs_01_pca.csv")

fig = px.scatter_3d(df, x='energy', y='loudness', z='acousticness',
color='acousticness',
title = '<b>Exploring my Spotify data:<br>Energy, Loudness and Acousticness</b>',
width = 500, height=500,
template = 'simple_white',
labels = dict(
     loudness = "<b>Loudness</b> in<br>decibels <b>(dB)</b>",
     energy = "<b>Energy</b>",
     acousticness = "<b>Acousticness</b>"
),
color_continuous_scale=["#e76254", "#ef8a47", "#f7aa58", "#ffd06f", "#ffe6b7", "#aadce0", "#72bcd5", "#528fad", "#376795", "#1e466e"]
)

fig.update_layout(font_family="Optima",
title_font_size = 25,
margin = dict(t=60, r=0,b=20,l=0),
autosize = True,
coloraxis_colorbar=dict(
     thicknessmode="pixels", thickness=10, len=0.8
)
)
fig.update_traces(marker={'size': 5})

# SAVE AS HTML
fig.write_html("./2022/day_14/30daychartchallenge_day_14_3-dimensional.html")