# Painting Dataset SQL Analysis

## Overview
This project involves solving a series of SQL problems related to a painting dataset. The tasks focus on data analysis and querying, covering various JOINs, aggregations, subqueries, and filtering techniques. The goal was to extract meaningful insights from the dataset and perform operations such as identifying the most popular painting styles, analyzing artist popularity, and detecting invalid data.

## Tasks Completed
### 1) Data Analysis Using SQL
Completed a series of SQL queries to analyze the painting dataset, including:
- Identifying paintings with the highest and lowest prices.
- Counting the number of paintings per artist or per museum.
- Finding the most popular painting styles and identifying the top museums by number of paintings.

### 2)Data Filtering and Aggregation
Used various SQL techniques to filter out data, perform aggregations, and calculate totals based on specific conditions. This included tasks such as:
- Finding paintings whose asking price was less than 50% of the regular price.
- Identifying museums that were open every single day.


## How I Managed to Complete the Tasks

### 1)Data Exploration and Schema Understanding
I began by exploring the schema of the dataset, understanding the relationships between tables like `work`, `artist`, `museum`, `subject`, and `product_size`. This allowed me to write efficient queries that used **INNER JOINs** and **GROUP BY** statements to retrieve necessary data.

### 2)Formulating Queries
Each question was broken down into logical steps:
- For example, in identifying the most expensive and least expensive paintings, I first located the maximum and minimum sale prices from the `product_size` table using subqueries and then fetched the paintings 
  with those prices.
- For tasks like finding the top museums or the most popular painting styles, I used aggregation (like `COUNT()`) and sorted the results using `ORDER BY` with `LIMIT` to get the top results.

### 3)Handling Data Issues
- Some tasks required handling invalid data, such as filtering out rows with NULL or empty strings in key columns. For example, I had to clean the museum hours data to remove invalid entries.
- There were instances where data types between columns didn't match (like `BIGINT` and `TEXT`), and I solved these by casting the columns to the same type using `::BIGINT`.

### 4)Optimizing Performance
As the dataset grew, performance became an issue for some queries. To address this:
- I ensured I only selected necessary columns and avoided using unnecessary `JOIN`s.
- Where possible, I used Common Table Expressions (CTEs) to simplify complex subqueries and enhance readability.

## Challenges Faced

### 1)Handling Different types of data types
One of the challenges was handling columns with different data types, especially when performing `JOIN`s. Some columns were of type `BIGINT` and others were `TEXT`. I had to cast these columns to the same data type to perform successful joins.

### 2)Data Quality Issues
The dataset contained invalid data entries such as missing or incorrectly formatted values in certain columns (e.g., museum hours, country information). I had to write queries to identify and clean these invalid records, which involved using regular expressions and conditional logic.

### 3)Complex Joins and Aggregations
Some queries required complex multi-table joins. For example, fetching the most popular painting styles involved joining the `work`, `subject`, and `museum` tables and using aggregations to count the number of paintings for each style. These queries had to be written carefully to avoid errors and ensure that the results were accurate.

### 4)Performance Considerations
Some queries, especially those involving large aggregations, ran slowly. To mitigate this, I used LIMIT and OFFSET in combination with ORDER BY to get only the top results when needed. I also made sure to index the columns that were frequently used in JOINs and WHERE clauses.

## Tools and Technologies Used

#### SQL: 
Used for querying the dataset, performing joins, and aggregations.
#### pgAdmin 4: 
Used to interact with the PostgreSQL database.
#### GitHub: 
For version control and repository management.
#### PostgreSQL: 
The database management system where the painting dataset is stored.

## Future Imporvements

### Data Cleaning: 
Further data cleaning steps can be implemented, especially to handle missing values in key columns.

### Query Optimization: 
Some queries can be optimized further by indexing frequently accessed columns, improving performance for larger datasets.

### Data Visualization: 
Once the dataset is cleaned and queries are optimized, I would like to integrate data visualization tools (like Power BI or Tableau) to create visual reports based on these queries.

## Conclusion
This project helped me practice various SQL techniques, including joins, grouping, subqueries, and aggregations. I was able to identify key insights from the painting dataset, like finding the most expensive paintings, the most popular subjects, and the museums with the most artworks. The process also improved my problem-solving skills, especially when dealing with invalid data and performance issues.

