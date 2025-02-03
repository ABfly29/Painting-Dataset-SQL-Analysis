import pandas as pd
import glob
import os
from sqlalchemy import create_engine

# PostgreSQL connection string
conn_string = "postgresql://postgres:2909@localhost:5432/painting"

# Create database engine
engine = create_engine(conn_string)

# Define the folder path where CSV files are stored
folder_path = r"C:\Users\Admin\Downloads\artists"

# Get all CSV files from the folder
csv_files = glob.glob(os.path.join(folder_path, "*.csv"))

# Loop through each CSV file and import it into PostgreSQL
for file in csv_files:
    table_name = os.path.basename(file).replace(".csv", "")  # Extract table name from file name
    try:
        df = pd.read_csv(file)  # Read CSV into Pandas DataFrame
        df.to_sql(table_name, engine, schema='public', if_exists="replace", index=False)  # Import data into PostgreSQL
        print(f"Imported {file} into table {table_name}")
    except Exception as e:
        print(f"Failed to import {file} into table {table_name}: {e}")

# Verify the import
print("All files imported successfully!")
