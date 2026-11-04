CREATE DATABASE IF NOT EXISTS hip_replacement_analytics;
USE hip_replacement_analytics;

DROP VIEW IF EXISTS vw_hip_replacement_analytics;
DROP TABLE IF EXISTS stg_hip_replacement_discharges;

CREATE TABLE stg_hip_replacement_discharges (
    health_service_area                 VARCHAR(100),
    hospital_county                     VARCHAR(100),
    operating_certificate_number        VARCHAR(30),
    facility_id                         INT,
    facility_name                       VARCHAR(255),
    age_group                           VARCHAR(30),
    zip_code_3_digits                   VARCHAR(3),
    gender                              VARCHAR(10),
    race                                VARCHAR(100),
    ethnicity                           VARCHAR(100),
    length_of_stay                      INT,
    type_of_admission                   VARCHAR(100),
    patient_disposition                 VARCHAR(150),
    discharge_year                      SMALLINT,
    ccs_diagnosis_code                  INT,
    ccs_diagnosis_description           VARCHAR(255),
    ccs_procedure_code                  INT,
    ccs_procedure_description           VARCHAR(255),
    apr_drg_code                        INT,
    apr_drg_description                 VARCHAR(255),
    apr_mdc_code                        INT,
    apr_mdc_description                 VARCHAR(255),
    apr_severity_of_illness_code        INT,
    apr_severity_of_illness_description VARCHAR(50),
    apr_risk_of_mortality               VARCHAR(50),
    apr_medical_surgical_description    VARCHAR(50),
    attending_provider_license_number   VARCHAR(30),
    operating_provider_license_number   VARCHAR(30),
    total_charges                       DECIMAL(14,2),
    total_costs                         DECIMAL(14,2),

    load_timestamp                      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_facility (facility_id),
    INDEX idx_year (discharge_year),
    INDEX idx_procedure (ccs_procedure_code),
    INDEX idx_drg (apr_drg_code),
    INDEX idx_county (hospital_county),
    INDEX idx_disposition (patient_disposition),
    INDEX idx_provider (operating_provider_license_number)
);

-- discharge records were loaded?
SELECT COUNT(*) AS total_discharge_records
FROM stg_hip_replacement_discharges;

-- How many distinct hospitals are represented?
SELECT COUNT(DISTINCT facility_id) AS distinct_hospitals
FROM stg_hip_replacement_discharges;

-- Which discharge years are available?
SELECT discharge_year, COUNT(*) AS discharge_records
FROM stg_hip_replacement_discharges
GROUP BY discharge_year
ORDER BY discharge_year;

-- What is the overall scope of the dataset?
SELECT
    COUNT(*) AS discharge_records,
    COUNT(DISTINCT facility_id) AS hospitals,
    COUNT(DISTINCT hospital_county) AS counties,
    MIN(discharge_year) AS first_discharge_year,
    MAX(discharge_year) AS last_discharge_year,
    SUM(total_charges) AS aggregate_reported_charges,
    SUM(total_costs) AS aggregate_reported_costs
FROM stg_hip_replacement_discharges;

-- Are there duplicate-looking discharge rows?
SELECT
    facility_id, discharge_year, age_group, gender,
    ccs_diagnosis_code, ccs_procedure_code, length_of_stay,
    total_charges, total_costs, COUNT(*) AS matching_rows
FROM stg_hip_replacement_discharges
GROUP BY
    facility_id, discharge_year, age_group, gender,
    ccs_diagnosis_code, ccs_procedure_code, length_of_stay,
    total_charges, total_costs
HAVING COUNT(*) > 1
ORDER BY matching_rows DESC;

-- Which fields contain missing values?
SELECT
    SUM(health_service_area IS NULL OR health_service_area = '') AS missing_service_area,
    SUM(hospital_county IS NULL OR hospital_county = '') AS missing_county,
    SUM(zip_code_3_digits IS NULL OR zip_code_3_digits = '') AS missing_zip3,
    SUM(gender IS NULL OR gender = '') AS missing_gender,
    SUM(race IS NULL OR race = '') AS missing_race,
    SUM(ethnicity IS NULL OR ethnicity = '') AS missing_ethnicity,
    SUM(length_of_stay IS NULL) AS missing_los,
    SUM(total_charges IS NULL) AS missing_charges,
    SUM(total_costs IS NULL) AS missing_costs
FROM stg_hip_replacement_discharges;

-- Are there invalid or unexpected numeric values?
SELECT *
FROM stg_hip_replacement_discharges
WHERE length_of_stay < 0
   OR total_charges < 0
   OR total_costs < 0
   OR discharge_year IS NULL
   OR facility_id IS NULL;

-- What are the observed procedure codes and descriptions?
SELECT
    ccs_procedure_code,
    ccs_procedure_description,
    COUNT(*) AS discharge_records
FROM stg_hip_replacement_discharges
GROUP BY ccs_procedure_code, ccs_procedure_description
ORDER BY discharge_records DESC;

-- How many records match the primary total/partial hip replacement code?
SELECT
    SUM(ccs_procedure_code = 153) AS total_partial_hip_replacement_records,
    COUNT(*) AS all_apr_drg_301_records
FROM stg_hip_replacement_discharges
WHERE apr_drg_code = 301;

-- Which records have APR-DRG 301 but a procedure code other than 153?
SELECT
    ccs_procedure_code,
    ccs_procedure_description,
    COUNT(*) AS discharge_records
FROM stg_hip_replacement_discharges
WHERE apr_drg_code = 301
  AND ccs_procedure_code <> 153
GROUP BY ccs_procedure_code, ccs_procedure_description
ORDER BY discharge_records DESC;

-- The view retains the full supplied APR-DRG 301 cohort and flags the
-- primary CCS 153 procedure cohort.
CREATE OR REPLACE VIEW vw_hip_replacement_analytics AS
SELECT
    *,
    CASE
        WHEN ccs_procedure_code = 153 THEN 'Primary CCS 153 cohort'
        ELSE 'Other procedure within APR-DRG 301'
    END AS procedure_cohort,
    CASE
        WHEN total_charges > 0 THEN total_costs / total_charges
        ELSE NULL
    END AS cost_to_charge_ratio
FROM stg_hip_replacement_discharges
WHERE apr_drg_code = 301;

-- Confirm the cohort size in the analytical view.
SELECT
    procedure_cohort,
    COUNT(*) AS discharge_records,
    COUNT(DISTINCT facility_id) AS hospitals
FROM vw_hip_replacement_analytics
GROUP BY procedure_cohort;

-- What is the total number of hip replacement discharges?
SELECT COUNT(*) AS hip_replacement_discharges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- How are discharges distributed by age group?
SELECT
    age_group,
    COUNT(*) AS discharge_records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_cohort
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY age_group
ORDER BY discharge_records DESC;

-- What is the discharge distribution by gender?
SELECT
    gender,
    COUNT(*) AS discharge_records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_cohort
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY gender;

-- How many procedures were recorded by county?
SELECT
    hospital_county,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY hospital_county
ORDER BY discharge_records DESC;

-- Which hospitals have the highest discharge volume?
SELECT
    facility_id,
    facility_name,
    hospital_county,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY facility_id, facility_name, hospital_county
ORDER BY discharge_records DESC
LIMIT 20;

-- What is the average, minimum, and maximum length of stay?
SELECT
    ROUND(AVG(length_of_stay), 2) AS average_los_days,
    MIN(length_of_stay) AS minimum_los_days,
    MAX(length_of_stay) AS maximum_los_days,
    ROUND(STDDEV_POP(length_of_stay), 2) AS los_standard_deviation
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- What are the average hospital charges and costs?
SELECT
    ROUND(AVG(total_charges), 2) AS average_charge_per_discharge,
    ROUND(AVG(total_costs), 2) AS average_cost_per_discharge,
    ROUND(SUM(total_charges), 2) AS aggregate_charges,
    ROUND(SUM(total_costs), 2) AS aggregate_costs
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- What are the most common discharge destinations?
SELECT
    patient_disposition,
    COUNT(*) AS discharge_records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_cohort
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY patient_disposition
ORDER BY discharge_records DESC;

-- What are the admission types in the cohort?
SELECT
    type_of_admission,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY type_of_admission
ORDER BY discharge_records DESC;

-- How are discharges distributed by risk of mortality?
SELECT
    apr_risk_of_mortality,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY apr_risk_of_mortality
ORDER BY COUNT(*) DESC;

-- Which counties have the highest average cost per discharge?
SELECT
    hospital_county,
    COUNT(*) AS discharge_records,
    COUNT(DISTINCT facility_id) AS hospitals,
    ROUND(AVG(total_costs), 2) AS average_cost,
    ROUND(AVG(length_of_stay), 2) AS average_los
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY hospital_county
HAVING COUNT(*) >= 30
ORDER BY average_cost DESC;

-- What are the most common diagnoses associated with the cohort?
SELECT
    ccs_diagnosis_code,
    ccs_diagnosis_description,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY ccs_diagnosis_code, ccs_diagnosis_description
ORDER BY discharge_records DESC
LIMIT 20;

-- How do gender and age group intersect in procedure utilization?
SELECT
    age_group,
    gender,
    COUNT(*) AS discharge_records,
    ROUND(AVG(length_of_stay), 2) AS average_los,
    ROUND(AVG(total_costs), 2) AS average_cost
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- How do race and ethnicity intersect in the discharge data?
SELECT
    race,
    ethnicity,
    COUNT(*) AS discharge_records,
    ROUND(AVG(length_of_stay), 2) AS average_los,
    ROUND(AVG(total_costs), 2) AS average_cost
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY race, ethnicity
HAVING COUNT(*) >= 20
ORDER BY discharge_records DESC;

-- Which operating providers have the highest procedure volume?
SELECT
    operating_provider_license_number,
    COUNT(*) AS discharge_records,
    COUNT(DISTINCT facility_id) AS hospitals,
    ROUND(AVG(length_of_stay), 2) AS average_los,
    ROUND(AVG(total_costs), 2) AS average_cost
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY operating_provider_license_number
ORDER BY discharge_records DESC
LIMIT 20;

-- How many hospitals does each operating provider appear in?
SELECT
    operating_provider_license_number,
    COUNT(DISTINCT facility_id) AS hospital_count,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY operating_provider_license_number
ORDER BY hospital_count DESC, discharge_records DESC;

-- Rank hospitals by procedure volume.
WITH hospital_volume AS (
    SELECT
        facility_id,
        facility_name,
        COUNT(*) AS discharge_records
    FROM vw_hip_replacement_analytics
    WHERE ccs_procedure_code = 153
    GROUP BY facility_id, facility_name
)
SELECT
    facility_id,
    facility_name,
    discharge_records,
    DENSE_RANK() OVER (ORDER BY discharge_records DESC) AS volume_rank
FROM hospital_volume
ORDER BY volume_rank, facility_name;

-- Rank hospitals by average cost, considering hospitals with at least 30 cases.
WITH hospital_cost AS (
    SELECT
        facility_id,
        facility_name,
        COUNT(*) AS discharge_records,
        AVG(total_costs) AS avg_cost
    FROM vw_hip_replacement_analytics
    WHERE ccs_procedure_code = 153
    GROUP BY facility_id, facility_name
    HAVING COUNT(*) >= 30
)
SELECT
    facility_id,
    facility_name,
    discharge_records,
    ROUND(avg_cost, 2) AS avg_cost,
    DENSE_RANK() OVER (ORDER BY avg_cost DESC) AS highest_cost_rank,
    DENSE_RANK() OVER (ORDER BY avg_cost ASC) AS lowest_cost_rank
FROM hospital_cost
ORDER BY highest_cost_rank;

-- Compare the distribution of LOS by severity category.
SELECT
    apr_severity_of_illness_description,
    COUNT(*) AS discharge_records,
    MIN(length_of_stay) AS min_los,
    ROUND(AVG(length_of_stay), 2) AS avg_los,
    MAX(length_of_stay) AS max_los,
    ROUND(STDDEV_POP(length_of_stay), 2) AS los_stddev
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY apr_severity_of_illness_description
ORDER BY AVG(length_of_stay) DESC;

-- Which hospitals have both above-average LOS and above-average costs?
WITH hospital_metrics AS (
    SELECT
        facility_id,
        facility_name,
        COUNT(*) AS discharge_records,
        AVG(length_of_stay) AS avg_los,
        AVG(total_costs) AS avg_cost
    FROM vw_hip_replacement_analytics
    WHERE ccs_procedure_code = 153
    GROUP BY facility_id, facility_name
    HAVING COUNT(*) >= 30
),
benchmarks AS (
    SELECT
        AVG(length_of_stay) AS cohort_avg_los,
        AVG(total_costs) AS cohort_avg_cost
    FROM vw_hip_replacement_analytics
    WHERE ccs_procedure_code = 153
)
SELECT
    h.facility_id,
    h.facility_name,
    h.discharge_records,
    ROUND(h.avg_los, 2) AS avg_los,
    ROUND(h.avg_cost, 2) AS avg_cost
FROM hospital_metrics h
CROSS JOIN benchmarks b
WHERE h.avg_los > b.cohort_avg_los
  AND h.avg_cost > b.cohort_avg_cost
ORDER BY h.avg_cost DESC;

-- What is the discharge disposition mix by hospital?
SELECT
    facility_id,
    facility_name,
    patient_disposition,
    COUNT(*) AS discharge_records,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (PARTITION BY facility_id), 2
    ) AS hospital_disposition_pct
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY facility_id, facility_name, patient_disposition
ORDER BY facility_name, discharge_records DESC;

-- How do average costs differ by age group and severity?
SELECT
    age_group,
    apr_severity_of_illness_description,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_costs), 2) AS average_cost,
    ROUND(AVG(length_of_stay), 2) AS average_los
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY age_group, apr_severity_of_illness_description
HAVING COUNT(*) >= 10
ORDER BY age_group, average_cost DESC;

-- What is the average cost-to-charge ratio by severity?
SELECT
    apr_severity_of_illness_description,
    COUNT(*) AS discharge_records,
    ROUND(
        SUM(total_costs) / NULLIF(SUM(total_charges), 0), 4
    ) AS aggregate_cost_to_charge_ratio
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY apr_severity_of_illness_description
ORDER BY aggregate_cost_to_charge_ratio DESC;

-- Which counties have the greatest total reported costs?
SELECT
    hospital_county,
    COUNT(*) AS discharge_records,
    COUNT(DISTINCT facility_id) AS hospitals,
    ROUND(SUM(total_costs), 2) AS aggregate_reported_costs,
    ROUND(SUM(total_charges), 2) AS aggregate_reported_charges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY hospital_county
ORDER BY aggregate_reported_costs DESC;

-- Produce a one-row executive KPI summary for a dashboard.
SELECT
    COUNT(*) AS total_discharges,
    COUNT(DISTINCT facility_id) AS hospitals,
    ROUND(AVG(length_of_stay), 2) AS average_length_of_stay_days,
    ROUND(AVG(total_costs), 2) AS average_cost_per_discharge,
    ROUND(AVG(total_charges), 2) AS average_charges_per_discharge,
    ROUND(SUM(total_costs), 2) AS total_reported_costs,
    ROUND(SUM(total_charges), 2) AS total_reported_charges,
    ROUND(
        100.0 * SUM(patient_disposition = 'Home w/ Home Health Services')
        / COUNT(*), 2
    ) AS home_health_discharge_pct,
    ROUND(
        100.0 * SUM(apr_severity_of_illness_description IN ('Major', 'Extreme'))
        / COUNT(*), 2
    ) AS major_extreme_severity_pct
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- Produce a final reconciliation of records by cohort.
SELECT
    COUNT(*) AS all_apr_drg_301_records,
    SUM(ccs_procedure_code = 153) AS ccs_153_records,
    SUM(ccs_procedure_code <> 153) AS other_procedure_records,
    COUNT(*) - SUM(ccs_procedure_code = 153)
               - SUM(ccs_procedure_code <> 153) AS reconciliation_difference
FROM vw_hip_replacement_analytics;

-- How many hip replacement discharge records are included in the analysis?
SELECT COUNT(*) AS total_hip_replacement_discharges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- How many distinct hospitals contributed hip replacement discharge records?
SELECT COUNT(DISTINCT facility_id) AS distinct_hospitals
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- Which age group had the most hip replacement discharges?
SELECT
    age_group,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY age_group
ORDER BY discharge_records DESC;

-- What percentage of hip replacement discharges came from each age group?
SELECT
    age_group,
    COUNT(*) AS discharge_records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_discharges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY age_group
ORDER BY discharge_records DESC;

-- Which gender category had the most hip replacement discharge records?
SELECT
    gender,
    COUNT(*) AS discharge_records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_discharges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY gender
ORDER BY discharge_records DESC;

-- Which counties had the highest number of hip replacement discharges?
SELECT
    hospital_county,
    COUNT(*) AS discharge_records,
    COUNT(DISTINCT facility_id) AS hospitals
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY hospital_county
ORDER BY discharge_records DESC;

-- Which hospitals had the highest number of hip replacement discharges?
SELECT
    facility_id,
    facility_name,
    hospital_county,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY facility_id, facility_name, hospital_county
ORDER BY discharge_records DESC
LIMIT 20;

-- What were the total reported charges across all hip replacement discharges?
SELECT
    ROUND(SUM(total_charges), 2) AS total_reported_charges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- How do average reported charges and costs compare overall?
SELECT
    ROUND(AVG(total_charges), 2) AS average_reported_charges_per_discharge,
    ROUND(AVG(total_costs), 2) AS average_reported_cost_per_discharge,
    ROUND(SUM(total_charges), 2) AS total_reported_charges,
    ROUND(SUM(total_costs), 2) AS total_reported_costs
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153;

-- Which hospitals had the highest average reported cost per discharge?
SELECT
    facility_id,
    facility_name,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_costs), 2) AS average_reported_cost_per_discharge
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY facility_id, facility_name
HAVING COUNT(*) >= 30
ORDER BY average_reported_cost_per_discharge DESC
LIMIT 20;

-- Which hospitals had the highest average reported charges per discharge?
SELECT
    facility_id,
    facility_name,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_charges), 2) AS average_reported_charges_per_discharge
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY facility_id, facility_name
HAVING COUNT(*) >= 30
ORDER BY average_reported_charges_per_discharge DESC
LIMIT 20;

-- How did average reported costs vary by age group?
SELECT
    age_group,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_costs), 2) AS average_reported_cost_per_discharge
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY age_group
ORDER BY average_reported_cost_per_discharge DESC;

-- How did average reported costs vary by severity of illness?
SELECT
    apr_severity_of_illness_description,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_costs), 2) AS average_reported_cost_per_discharge,
    ROUND(AVG(length_of_stay), 2) AS average_length_of_stay_days
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY apr_severity_of_illness_description
ORDER BY average_reported_cost_per_discharge DESC;

-- How did average reported charges vary by severity of illness?
SELECT
    apr_severity_of_illness_description,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_charges), 2) AS average_reported_charges_per_discharge
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY apr_severity_of_illness_description
ORDER BY average_reported_charges_per_discharge DESC;

-- What were the most common discharge destinations?
SELECT
    patient_disposition,
    COUNT(*) AS discharge_records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_discharges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY patient_disposition
ORDER BY discharge_records DESC;

-- Which discharge destinations were associated with the longest average stays?
SELECT
    patient_disposition,
    COUNT(*) AS discharge_records,
    ROUND(AVG(length_of_stay), 2) AS average_length_of_stay_days
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY patient_disposition
HAVING COUNT(*) >= 20
ORDER BY average_length_of_stay_days DESC;

-- How did average reported costs vary by discharge destination?
SELECT
    patient_disposition,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_costs), 2) AS average_reported_cost_per_discharge,
    ROUND(AVG(length_of_stay), 2) AS average_length_of_stay_days
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY patient_disposition
HAVING COUNT(*) >= 20
ORDER BY average_reported_cost_per_discharge DESC;

-- Which diagnosis categories were most frequently recorded in the cohort?
SELECT
    ccs_diagnosis_code,
    ccs_diagnosis_description,
    COUNT(*) AS discharge_records
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY ccs_diagnosis_code, ccs_diagnosis_description
ORDER BY discharge_records DESC
LIMIT 20;

-- How were hip replacement discharges distributed by risk of mortality?
SELECT
    apr_risk_of_mortality,
    COUNT(*) AS discharge_records,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_discharges
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY apr_risk_of_mortality
ORDER BY discharge_records DESC;

-- What were the average reported costs and charges by hospital county?
SELECT
    hospital_county,
    COUNT(*) AS discharge_records,
    ROUND(AVG(total_costs), 2) AS average_reported_cost_per_discharge,
    ROUND(AVG(total_charges), 2) AS average_reported_charges_per_discharge
FROM vw_hip_replacement_analytics
WHERE ccs_procedure_code = 153
GROUP BY hospital_county
HAVING COUNT(*) >= 30
ORDER BY average_reported_cost_per_discharge DESC;