import pandas as pd
from sqlalchemy import create_engine

# MySQL connection string
conn_string = 'mysql://root:root@localhost/painting'


db = create_engine(conn_string)
conn = db.connect()

files = ['artist', 'canvas_size', 'image_link', 'museum_hours', 'museum', 'product_size', 'subject', 'work']


for file in files:
    df = pd.read_csv(f'c:\\Users\\ssaji\\OneDrive\\Desktop\\Sajib khan - SQL Project\\Case Study- Famous Paintings PostgreSQL+Python Project\\Kaggle Data\\{file}.csv')


    df.to_sql(file, con=conn, if_exists='replace', index=False)