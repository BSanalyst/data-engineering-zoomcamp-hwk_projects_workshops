import pandas as pd
from sqlalchemy import create_engine



#Parquet
url_taxi_data = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet" 

#CSV
url_zone_data = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"



# Data into dataframes
df_taxi = pd.read_parquet(url_taxi_data)
df_zones = pd.read_csv(url_zone_data)



# engine to interact with postgres.
## will need to swap localhost:5432 with db:5432
from sqlalchemy import create_engine, text
engine = create_engine("postgresql+psycopg2://postgres:postgres@db:5432/ny_taxi")


df_taxi.to_sql(name='taxi_trips', con=engine, if_exists='replace')
df_zones.to_sql(name='taxi_zones', con=engine, if_exists='replace')

print("Data ingested successfully.")
print(f"Number of rows in taxi_trips: {len(df_taxi)}")