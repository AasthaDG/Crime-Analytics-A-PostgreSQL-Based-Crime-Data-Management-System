COPY temp_human_rights FROM 
'D:\DS_SEM_II\DMQL\archive\crime\crime\35_Human_rights_violation_by_police.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',');

COPY nature_of_complaints FROM 
'D:\path\to\27_Nature_of_complaints_received_by_police.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');

COPY Crimes_IPC FROM 'path/to/01_District_wise_crimes_committed_IPC_2001_2012.csv' DELIMITER ',' CSV HEADER;
COPY Victims FROM 'path/to/07_Victims_of_rape.csv' DELIMITER ',' CSV HEADER;
COPY Crimes_IPC FROM 'path/to/cleaned_crimes_ipc.csv' DELIMITER ',' CSV HEADER;
copy Crimes_IPC FROM 'path/to/01_District_wise_crimes_committed_IPC_2001_2012.csv' DELIMITER ',' CSV HEADER;

-- Similarly Uploaded from other CSVS :
