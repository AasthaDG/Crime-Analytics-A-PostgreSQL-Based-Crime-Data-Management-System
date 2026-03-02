
CREATE TABLE states (
    state_id SERIAL PRIMARY KEY,
    state_name VARCHAR(100) NOT NULL,
    population BIGINT,
    area_sq_km NUMERIC
);

CREATE TABLE districts (
    district_id SERIAL PRIMARY KEY,
    state_id INTEGER REFERENCES states(state_id) ON DELETE CASCADE,
    district_name VARCHAR(100) NOT NULL,
    population BIGINT
);


The tables i used were :
CREATE TABLE Crimes_Women (
    state_ut VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    rape INT,
    kidnapping_and_abduction INT,
    dowry_deaths INT,
    assault_on_women_with_intent_to_outrage_her_modesty INT,
    insult_to_modesty_of_women INT,
    cruelty_by_husband_or_his_relatives INT,
    importation_of_girls INT,
    PRIMARY KEY (state_ut, district, year)
);

CREATE TABLE Crimes_Children (
    state_ut VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    murder INT,
    rape INT,
    kidnapping_and_abduction INT,
    foeticide INT,
    abetment_of_suicide INT,
    exposure_and_abandonment INT,
    procuration_of_minor_girls INT,
    buying_of_girls_for_prostitution INT,
    selling_of_girls_for_prostitution INT,
    prohibition_of_child_marriage_act INT,
    other_crimes INT,
    total INT,
    PRIMARY KEY (state_ut, district, year)
);


CREATE TABLE Crimes_SC (
    state_ut VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    murder INT,
    rape INT,
    hurt INT,
    PRIMARY KEY (state_ut, district, year)
);

ALTER TABLE Crimes_SC
ADD COLUMN kidnapping_and_abduction INT,
ADD COLUMN dacoity INT,
ADD COLUMN robbery INT,
ADD COLUMN arson INT,
ADD COLUMN protection_of_civil_rights_act INT,
ADD COLUMN prevention_of_atrocities_act INT,
ADD COLUMN other_crimes_against_scs INT;

DROP TABLE IF EXISTS Crimes_IPC;

CREATE TABLE Crimes_IPC (
    state_ut VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    murder INT,
    attempt_to_murder INT,
    culpable_homicide_not_amounting_to_murder INT,
    rape INT,
    custodial_rape INT,
    other_rape INT,
    kidnapping_abduction INT,
    kidnapping_abduction_women_girls INT,
    kidnapping_abduction_others INT,
    dacoity INT,
    preparation_and_assembly_for_dacoity INT,
    robbery INT,
    burglary INT,
    theft INT,
    auto_theft INT,
    other_theft INT,
    riots INT,
    criminal_breach_of_trust INT,
    cheating INT,
    counterfeiting INT,
    arson INT,
    hurt_grievous_hurt INT,
    dowry_deaths INT,
    assault_on_women_with_intent_to_outrage_her_modesty INT,
    insult_to_modesty_of_women INT,
    cruelty_by_husband_or_his_relatives INT,
    importation_of_girls_from_foreign_countries INT,
    causing_death_by_negligence INT,
    other_ipc_crimes INT,
    total_ipc_crimes INT,
    PRIMARY KEY (state_ut, district, year)
);

CREATE TABLE trial_of_violent_crimes_by_courts (
    area_name VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    group_name VARCHAR(100) NOT NULL,
    sub_group_name VARCHAR(100) NOT NULL,
    trial_by_confession INT,
    trial_by_trial INT,
    trial_total INT,
    PRIMARY KEY (area_name, year, group_name, sub_group_name)
);

CREATE TABLE pending_trials_by_courts (
    area_name VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    group_name VARCHAR(100) NOT NULL,
    sub_group_name VARCHAR(100) NOT NULL,
    pt_1_3_years INT,
    pt_3_5_years INT,
    pt_5_10_years INT,
    pt_6_12_months INT,
    pt_less_than_6_months INT,
    pt_over_10_years INT,
    pt_total INT,
    PRIMARY KEY (area_name, year, group_name, sub_group_name)
);

-- Add district_id column to Crimes_Women
ALTER TABLE Crimes_Women ADD COLUMN district_id INT;

-- Update the new column with correct IDs
UPDATE Crimes_Women cw
SET district_id = d.district_id
FROM Districts d
JOIN States s ON d.state_id = s.state_id
WHERE cw.state_ut = s.state_ut_name AND cw.district = d.district_name;

-- Add the foreign key constraint
ALTER TABLE Crimes_Women 
ADD CONSTRAINT fk_crimes_women_district 
FOREIGN KEY (district_id) REFERENCES Districts(district_id) ON DELETE CASCADE;

-- Add year foreign key
ALTER TABLE Crimes_Women 
ADD CONSTRAINT fk_crimes_women_year 
FOREIGN KEY (year) REFERENCES Year(year);

ALTER TABLE Crimes_Women ALTER COLUMN district_id SET NOT NULL;


ALTER TABLE trial_of_violent_crimes_by_courts 
ADD COLUMN area_type VARCHAR(10) CHECK (area_type IN ('state', 'district'));

-- Update based on area_name content
UPDATE trial_of_violent_crimes_by_courts
SET area_type = CASE 
    WHEN area_name IN (SELECT state_ut_name FROM States) THEN 'state'
    ELSE 'district'
END;

-- Add state_id and district_id columns
ALTER TABLE trial_of_violent_crimes_by_courts 
ADD COLUMN state_id INT REFERENCES States(state_id),
ADD COLUMN district_id INT REFERENCES Districts(district_id);

-- Populate the IDs
UPDATE trial_of_violent_crimes_by_courts t
SET state_id = s.state_id
FROM States s
WHERE t.area_name = s.state_ut_name AND t.area_type = 'state';

UPDATE trial_of_violent_crimes_by_courts t
SET district_id = d.district_id
FROM Districts d
JOIN States s ON d.state_id = s.state_id
WHERE t.area_name = d.district_name AND t.area_type = 'district';

CREATE TABLE Nature_of_Complaints (
    record_id SERIAL PRIMARY KEY,
    district_id INT NOT NULL REFERENCES Districts(district_id),
    year INT NOT NULL,
    pc1_oral_complaints INT,
    pc2_written_complaints INT,
    pc3_distress_call_over_phoneNo_100_etc INT,
    pc4_complaints_initiated_sue_motto_by_police INT,
    pc5_total_complaints_sum_of_1_4_above INT,
    pc6_total_complaints_as_recorded_in_gd INT,
    pc7_ipc_cases_registered INT,
    pc8_sll_cases_registered INT,
    CONSTRAINT fk_nature_complaints_district FOREIGN KEY (district_id) REFERENCES Districts(district_id),
    CONSTRAINT fk_nature_complaints_year FOREIGN KEY (year) REFERENCES Year(year),
    CONSTRAINT unique_complaint_record UNIQUE (district_id, year)
);


UPDATE temp_complaints t
SET district_id = d.district_id
FROM district_mappings dm
JOIN districts d ON dm.canonical_name = d.district_name
WHERE t.area_name ILIKE dm.csv_pattern;

-- Exact match fallback
UPDATE temp_complaints t
SET district_id = d.district_id
FROM districts d 
WHERE LOWER(TRIM(t.area_name)) = LOWER(TRIM(d.district_name))
AND t.district_id IS NULL;

CREATE TABLE human_rights_violation_by_police (
    record_id SERIAL PRIMARY KEY,
    area_name TEXT NOT NULL,
    year INTEGER NOT NULL,
    group_name TEXT NOT NULL,
    sub_group_name TEXT NOT NULL,
    cases_registered INTEGER,
    policemen_chargesheeted INTEGER,
    policemen_convicted INTEGER,
    CONSTRAINT unique_violation_record UNIQUE (area_name, year, group_name, sub_group_name)
);

-- Add state_id column
ALTER TABLE human_rights_violation_by_police ADD COLUMN state_id INTEGER;

-- Standardize state names and match to IDs
UPDATE human_rights_violation_by_police h
SET 
    area_name = CASE 
        WHEN area_name ~* 'andhra' THEN 'Andhra Pradesh'
        WHEN area_name ~* 'tamil' THEN 'Tamil Nadu'
        ELSE INITCAP(area_name)
    END,
    state_id = s.state_id
FROM states s
WHERE h.area_name = s.state_ut_name;

-- Add foreign key constraints
ALTER TABLE human_rights_violation_by_police
    ALTER COLUMN state_id SET NOT NULL,
    ADD CONSTRAINT fk_state FOREIGN KEY (state_id) REFERENCES states(state_id),
    ADD CONSTRAINT fk_year FOREIGN KEY (year) REFERENCES year(year);



-- Add reference columns to main table
ALTER TABLE human_rights_violation_by_police
    ADD COLUMN group_id INTEGER,
    ADD COLUMN subgroup_id INTEGER;

-- Update references
UPDATE human_rights_violation_by_police h
SET 
    group_id = g.group_id,
    subgroup_id = sg.subgroup_id
FROM human_rights_groups g
JOIN human_rights_subgroups sg ON g.group_id = sg.group_id
WHERE h.group_name = g.group_name AND h.sub_group_name = sg.sub_group_name;

-- Final structure with all FKs
ALTER TABLE human_rights_violation_by_police
    ALTER COLUMN group_id SET NOT NULL,
    ALTER COLUMN subgroup_id SET NOT NULL,
    ADD CONSTRAINT fk_group FOREIGN KEY (group_id) REFERENCES human_rights_groups(group_id),
    ADD CONSTRAINT fk_subgroup FOREIGN KEY (subgroup_id) REFERENCES human_rights_subgroups(subgroup_id),
    DROP COLUMN group_name,
    DROP COLUMN sub_group_name;

-- Add state_id column
ALTER TABLE human_rights_violation_by_police ADD COLUMN state_id INT;

-- Clean and match state names
UPDATE human_rights_violation_by_police t
SET 
    area_name = TRIM(INITCAP(area_name)),
    state_id = s.state_id
FROM states s
WHERE LOWER(TRIM(t.area_name)) = LOWER(TRIM(s.state_ut_name));

-- Add constraints
ALTER TABLE human_rights_violation_by_police
    ALTER COLUMN state_id SET NOT NULL,
    ADD CONSTRAINT fk_state FOREIGN KEY (state_id) REFERENCES states(state_id),
    ADD CONSTRAINT fk_year FOREIGN KEY (year) REFERENCES year(year);
