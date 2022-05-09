import numpy as np
import pandas as pd
import ee
import geopandas
import geemap
import eemont
ee.Initialize()

# FUNCTIONS
def mes_esp(number):
    meses_list = ["Enero","Febrero","Marzo","Abril","Mayo","Junio",
                  "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
    if number == 1:
        return meses_list[number-1]
    elif number == 2:
        return meses_list[number-1]
    elif number == 3:
        return meses_list[number-1]
    elif number == 4:
        return meses_list[number-1]
    elif number == 5:
        return meses_list[number-1]
    elif number == 6:
        return meses_list[number-1]
    elif number == 7:
        return meses_list[number-1]
    elif number == 8:
        return meses_list[number-1]
    elif number == 9:
        return meses_list[number-1]
    elif number == 10:
        return meses_list[number-1]
    elif number == 11:
        return meses_list[number-1]
    else: return meses_list[11]

# CODE

# Región de interés (roi)
yuc_info = geopandas.read_file('PATH/TO/YOUR/data.shp') # My case: Yucatan
yuc_info = yuc_info.to_crs(4326)
roi_centroid = (yuc_info.geometry.centroid.y.values[0], yuc_info.geometry.centroid.x.values[0])
fc = geemap.geopandas_to_ee(yuc_info)
roi = fc.geometry()

# Filtro de fecha
filter_date = ee.Filter.calendarRange(start=2019, end=2021, field='year')

# Obtener la Image Collection
precipitation_ImgCollection = ee.ImageCollection("UCSB-CHG/CHIRPS/PENTAD")\
                              .select(['precipitation'])\
                              .filter(filter_date)

# Get time series
precipitation_FeatureColletcion = precipitation_ImgCollection\
                                  .getTimeSeriesByRegion(
                                      reducer=ee.Reducer.mean(),
                                      geometry=roi,
                                      scale=1000,
                                      naValue=-9999,
                                      bands='precipitation')

# Create dataframe
df = geemap.ee_to_pandas(precipitation_FeatureColletcion)

# Prepare data
df['date'] = pd.to_datetime(df['date'])
df = df.set_index('date')
df = df.drop(columns='reducer')
df = df.resample("M").mean()

# Save data
df.to_csv("./../data/earth_engine_precipitation_yuc_2019-2021.csv", index = True)