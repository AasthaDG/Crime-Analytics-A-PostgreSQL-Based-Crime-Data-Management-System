
Overview:
This project establishes a robust Crime Analytics and Management System using PostgreSQL to efficiently store, organize, and analyze extensive crime data across various states and districts in India. The system facilitates crime pattern analysis, crime hotspot identification, and judicial efficiency assessment through structured and normalized data management.

Project Files:
create.sql: Contains all CREATE TABLE statements
load.sql: Contains all \copy commands to bulk-load CSVs
data/: Directory containing all CSV data files
readme.txt: This file

ER_Diagram.png: Visual representation of the relational schema

Data Source
All CSVs were exported from the “Crime in India” Kaggle dataset.
Link: Crime in India Dataset on Kaggle (https://www.kaggle.com/datasets/rajanand/crime-in-india)
Sample CSV files were generated for any missing tables.

Dataset Information
The dataset spans crime data from 2001 to 2020, covering all Indian states and Union Territories, and includes approximately 500,000 records.

Data Attributes
Case counts (registered, pending, convicted)
Victim demographics
Judicial outcomes
Temporal markers (year/month)

How to Run
Create a fresh PostgreSQL database:
createdb crime_analytics

Execute the schema creation script from the milestone2/ directory:
psql -d crime_analytics -f create.sql

Load the data:
psql -d crime_analytics -f load.sql

Verify the setup by running basic SQL queries in psql:

\dt
SELECT COUNT(*) FROM States;

Notes

Data filenames in load.sql can be modified as needed.
All tables are in Boyce-Codd Normal Form (BCNF); derived totals are computed at query time.
Refer to ER_Diagram.png for the Entity-Relationship diagram and detailed schema structure.

Primary Users
Law Enforcement Agencies: Analyze crime trends for effective resource allocation.
Policymakers: Inform crime prevention strategies.
Researchers: Conduct in-depth analyses of crime patterns.

Authors
Aastha Gade (aasthaga@buffalo.edu)
