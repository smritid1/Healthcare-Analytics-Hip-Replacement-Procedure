# Healthcare Analytics: Hip Replacement Procedures

### Hospital Utilization, Patient Demographics, Length of Stay, and Financial Analysis

## Project Overview

This project analyzes New York State hospital inpatient discharge data for hip replacement procedures during 2016. The objective is to explore hospital utilization, patient demographics, length of stay (LOS), discharge patterns, hospital-level differences, and healthcare costs using SQL, Python, Jupyter Notebook, and Power BI.

The project combines data cleaning, exploratory data analysis, SQL querying, healthcare KPI calculations, hospital benchmarking, and interactive dashboard development to identify patterns and generate data-driven insights.

The analysis focuses on understanding healthcare service utilization and operational efficiency through discharge-level data.

## Project Objectives

- Analyze hospital discharge patterns for hip replacement procedures.
- Explore patient demographics, including age group and gender.
- Evaluate average and median length of stay across different patient groups.
- Examine hospital utilization across health service areas and counties.
- Compare hospital-level discharge volume, length of stay, and reported costs.
- Analyze the relationship between severity of illness, mortality risk, length of stay, and reported costs.
- Understand patient discharge disposition patterns.
- Develop healthcare KPIs and interactive Power BI dashboards.
- Generate insights that can support healthcare operational analysis and decision-making.

## Tools and Technologies

| Tool | Purpose |
|---|---|
| MySQL | Data querying, filtering, aggregation, and analysis |
| Python | Data cleaning, analysis, and statistical exploration |
| Jupyter Notebook | Exploratory data analysis and documentation |
| Pandas | Data manipulation and analysis |
| NumPy | Numerical operations |
| Matplotlib | Data visualization |
| Seaborn | Statistical data visualization |
| Power BI | Interactive dashboard development |
| DAX | Healthcare KPI calculations and measures |
| GitHub | Project documentation and version control |

## Dataset Overview

The dataset contains hospital inpatient discharge records from New York State for the reporting year 2016.

**Dataset source:** New York State Department of Health – Hospital Inpatient Discharges.

The original dataset contains:

- **26,594** discharge records
- **30** columns
- Hospital, patient demographic, diagnosis, procedure, severity, discharge, and financial information

### Analytical Cohort

For this project, the analysis focuses on records matching the following criteria:

- `apr_drg_code = 301`
- `ccs_procedure_code = 153`

After applying these filters, the selected analytical cohort contains:

| Metric | Value |
|---|---:|
| Original records | 26,594 |
| Selected discharge records | 26,286 |
| Distinct hospital facilities | 151 |
| Distinct counties | 49 |
| Reporting year | 2016 |

The selected cohort contains 26,286 discharge records. These records represent the analytical population used throughout the project.

All selected records have an admission type classified as **Elective**.

## Dataset Features

The dataset contains several categories of information.

### 1. Hospital Information

- Health service area
- Hospital county
- Facility ID
- Facility name
- Operating certificate number

### 2. Patient Demographics

- Age group
- Gender
- Race
- Ethnicity
- Three-digit ZIP code

### 3. Diagnosis and Procedure Information

- CCS diagnosis code
- CCS diagnosis description
- CCS procedure code
- CCS procedure description
- APR-DRG code
- APR-DRG description
- APR-MDC code
- APR-MDC description

### 4. Healthcare and Discharge Information

- Length of stay
- Type of admission
- Patient disposition
- APR severity of illness
- APR risk of mortality
- APR medical/surgical description

### 5. Provider and Financial Information

- Attending provider license number
- Operating provider license number
- Total charges
- Total costs

## Healthcare Analytics Framework

The project primarily focuses on **Healthcare Efficiency**.

The analysis explores operational and financial indicators, including:

- Average length of stay
- Hospital discharge volume
- Hospital utilization
- Patient discharge disposition
- Average reported cost per discharge
- Hospital-level cost variation
- Severity-related differences in resource utilization

These indicators provide descriptive insights into hospital operations and resource utilization. They should not be interpreted as direct measures of clinical quality or patient outcomes.

## Key Performance Indicators (KPIs)

The following KPIs were calculated using the selected analytical cohort.

| KPI | Result |
|---|---:|
| Total Discharges | 26,286 |
| Total Hospitals | 151 |
| Total Counties | 49 |
| Average Length of Stay | 2.65 days |
| Median Length of Stay | 2 days |
| Average Reported Cost per Discharge | $20,910.35 |
| Average Reported Charges per Discharge | $59,440.01 |
| Aggregate Reported Costs | $549,649,448.36 |
| Aggregate Reported Charges | $1,562,440,170.56 |
| Major and Extreme Severity Share | 4.83% |

**Important:** Total charges and total costs are different financial measures. Reported charges represent billed amounts, while reported costs represent the reported cost associated with providing care. Neither measure should automatically be interpreted as actual payments, reimbursements, or hospital profit.

## Exploratory Data Analysis and Insights

### 1. Patient Demographic Analysis

The demographic analysis explores the distribution of hip replacement discharges across age groups and gender.

#### Gender Distribution

| Gender | Percentage of Discharges |
|---|---:|
| Female | 53.67% |
| Male | 46.33% |

Female patients account for a slightly higher share of discharge records than male patients.

#### Age Group Distribution

| Age Group | Percentage of Discharges |
|---|---:|
| 0–17 | 0.06% |
| 18–29 | 0.62% |
| 30–49 | 8.55% |
| 50–69 | 58.37% |
| 70 or Older | 32.41% |

**Key Insight:**

The majority of hip replacement discharge records belong to patients aged 50 and older. The 50–69 age group represents the largest share, followed by patients aged 70 or older.

### 2. Geographic and Hospital Distribution

The geographic analysis examines how hip replacement discharges are distributed across New York State health service areas and counties.

Key findings:

- The selected cohort includes 151 distinct hospital facilities.
- These facilities are located across 49 counties.
- New York City accounts for 44 facilities, representing approximately 29.14% of all facilities in the selected cohort.
- New York City has the highest average reported cost per discharge among the health service areas, at approximately $25,502.36.

**Key Insight:**

Hospital facilities and reported costs vary across geographic areas. These differences provide opportunities for further investigation into regional healthcare utilization and cost patterns.

### 3. Hospital Utilization Analysis

Hospital utilization analysis examines discharge volume and operating-provider license identifiers across facilities.

Key findings:

- The dataset contains 26,286 selected discharge records.
- There are 151 distinct hospital facilities.
- There are 627 distinct operating-provider license identifiers.

**Key Insight:**

The dataset provides a hospital-level view of discharge activity and operating-provider identifiers. These identifiers should not be interpreted as a verified count of employed surgeons.

### 4. Length of Stay (LOS) Analysis

Length of stay measures the number of days patients remain hospitalized.

The analysis evaluates average and median LOS across demographic groups, hospitals, patient disposition categories, and severity levels.

#### Overall LOS

| Metric | Result |
|---|---:|
| Average LOS | 2.65 days |
| Median LOS | 2 days |
| Aggregate LOS | 69,695 days |

#### LOS by Gender

| Gender | Average LOS |
|---|---:|
| Female | 2.77 days |
| Male | 2.51 days |

**Key Insight:**

Female discharge records have a higher average length of stay than male discharge records in this cohort. This is a descriptive comparison and does not establish the reason for the difference.

#### Hospital-Level LOS Comparison

Among the 15 hospitals with the highest discharge volumes:

- Syosset Hospital has the highest average LOS at approximately **3.22 days**.
- It recorded 441 discharge records.
- The dataset contains 11 distinct operating-provider license identifiers for this hospital.

This comparison helps identify hospital-level differences in length of stay among higher-volume facilities.

### 5. Patient Disposition Analysis

Patient disposition describes the recorded destination or discharge status when a patient leaves the hospital.

#### Discharge Distribution

| Patient Disposition | Percentage |
|---|---:|
| Home with Home Health Services | 55.01% |
| Home or Self Care | 20.50% |
| Skilled Nursing Home | 19.30% |
| Inpatient Rehabilitation Facility | 4.42% |

**Key Insight:**

More than half of the selected discharge records are associated with discharge to home with home health services.

Patients discharged to skilled nursing homes have an average LOS of approximately **3.63 days**, which is higher than the overall cohort average of 2.65 days.

This pattern may help identify differences in discharge planning and resource utilization.

### 6. Severity of Illness Analysis

The analysis examines the relationship between APR severity of illness classifications, average LOS, and reported costs.

#### Severity-Level Comparison

| Severity Level | Discharges | Average LOS (Days) | Average Reported Cost |
|---|---:|---:|---:|
| Minor | 11,735 | 2.37 | $20,335.44 |
| Moderate | 13,282 | 2.67 | $20,603.29 |
| Major | 1,195 | 4.58 | $27,578.21 |
| Extreme | 74 | 12.45 | $59,515.79 |

**Key Insights:**

- Minor and moderate severity categories account for most discharge records.
- Average LOS increases across the major and extreme severity categories.
- Average reported costs are also higher in the major and extreme severity categories.
- Extreme severity records have the highest average LOS and reported cost.

These findings show descriptive differences across administrative severity classifications. They do not establish that severity alone causes higher costs or longer hospital stays.

### 7. Risk of Mortality Analysis

The dataset includes APR risk-of-mortality classifications.

The analysis compares discharge volume, average LOS, and average reported costs across mortality-risk categories.

| Risk of Mortality | Discharges | Average LOS (Days) | Average Reported Cost |
|---|---:|---:|---:|
| Minor | 22,407 | 2.45 | $20,324.53 |
| Moderate | 3,298 | 3.36 | $22,606.33 |
| Major | 488 | 5.88 | $31,388.39 |
| Extreme | 93 | 9.54 | $46,929.96 |

**Key Insight:**

Average LOS and average reported costs are higher in the major and extreme mortality-risk categories than in the minor category.

These are administrative risk classifications, not actual mortality outcomes.

### 8. Healthcare Cost Analysis

The financial analysis examines reported hospital costs and charges across facilities, health service areas, patient groups, and administrative classifications.

#### Overall Financial Metrics

| Metric | Amount |
|---|---:|
| Average Reported Cost per Discharge | $20,910.35 |
| Average Reported Charges per Discharge | $59,440.01 |
| Aggregate Reported Costs | $549,649,448.36 |
| Aggregate Reported Charges | $1,562,440,170.56 |

#### Geographic Cost Analysis

New York City has the highest average reported cost per discharge among the health service areas, at approximately **$25,502.36**.

#### Hospital-Level Cost Analysis

NYU Lutheran Medical Center has the highest average reported cost per discharge among the hospitals in the selected cohort.

| Metric | Value |
|---|---:|
| Hospital | NYU Lutheran Medical Center |
| Average Reported Cost per Discharge | $84,601.41 |
| Discharges | 124 |
| County | Kings County |

**Key Insight:**

Reported costs vary across hospitals and geographic areas. These differences may reflect several factors, including patient characteristics, hospital operations, and resource utilization. Further case-mix-adjusted analysis would be required before drawing conclusions about hospital performance.

### 9. Relationship Between Length of Stay and Reported Costs

The project uses Spearman rank correlation to examine the relationship between length of stay and reported costs.

| Statistical Measure | Result |
|---|---:|
| Spearman Correlation | 0.393 |

**Key Insight:**

The analysis identifies a positive association between length of stay and reported costs. In general, discharge records with longer hospital stays tend to have higher reported costs.

However, correlation does not establish causation. This relationship does not prove that a longer stay directly causes higher costs.

## SQL Analysis – MySQL

The SQL component uses MySQL 8.0+ to perform structured data analysis and answer healthcare-related business questions.

The SQL analysis includes:

- Database and table creation
- Data profiling
- Data filtering and cohort selection
- Data aggregation
- Healthcare KPI calculations
- Hospital-level analysis
- Patient demographic analysis
- Length-of-stay analysis
- Cost and charges analysis
- Severity and mortality-risk analysis
- Patient disposition analysis
- Hospital benchmarking
- Common Table Expressions (CTEs)
- Subqueries
- Conditional aggregation
- Window functions
- Percentile and outlier screening
- Dashboard-ready analytical queries

The SQL file also contains English-language analytical questions followed by their corresponding SQL queries to support learning and practice.

**SQL file:** `hip_replacement_healthcare_analytics_study_queries.sql`

## Python and Jupyter Notebook Analysis

The Python component performs data cleaning, exploratory data analysis, statistical analysis, and visualization.

Libraries used:

- Pandas
- NumPy
- Matplotlib
- Seaborn
- SciPy (optional)

### Notebook Workflow

1. Import required libraries.
2. Load the original CSV dataset.
3. Explore dataset structure and data types.
4. Review the dataset's data dictionary.
5. Perform data profiling and quality checks.
6. Apply the analytical cohort filters.
7. Calculate healthcare KPIs.
8. Analyze patient demographics.
9. Explore geographic and hospital distribution.
10. Analyze length of stay.
11. Examine reported costs and charges.
12. Compare severity and mortality-risk categories.
13. Analyze patient discharge disposition.
14. Explore hospital-level differences.
15. Perform outlier screening.
16. Calculate Spearman correlation.
17. Generate visualizations.
18. Export analytical outputs.
19. Document key findings and limitations.

**Jupyter Notebook:** `us_healthcare_hip_replacement_data_analysis_final.ipynb`

## Power BI Dashboard

The Power BI report provides an interactive view of the healthcare analysis.

The dashboard contains six report pages.

### 1. Hospitals

Focuses on hospital distribution and utilization.

Visuals include:

- Total hospitals
- Hospitals by health service area

### 2. Discharges

Focuses on patient discharge demographics.

Visuals include:

- Total discharges
- Gender distribution
- Age group and gender distribution

### 3. LOS

Focuses on length-of-stay patterns.

Visuals include:

- Average LOS
- LOS by age group
- LOS by gender

### 4. Hospital Comparison

Focuses on comparing hospital utilization and operational indicators.

Visuals include:

- Discharges by hospital
- Hospital-level LOS
- Distinct operating-provider license identifiers

### 5. Cost

Focuses on hospital-level financial comparisons.

Visuals include:

- Average cost per discharge
- Average cost by health service area
- Average cost by facility
- Percentage variance from average cost
- Average LOS and percentage variance

### 6. Root Cause

This page provides exploratory cost segmentation across different patient and hospital characteristics.

Visuals include:

- Average cost by mortality risk
- Average cost by severity of illness
- Average cost by diagnosis
- Average cost by patient disposition
- Average cost by gender
- Average cost by age group
- Average cost by health service area

The page is used for exploratory analysis. The visualizations identify patterns and differences but do not establish causal root causes.

**Power BI file:** `9hospitals_overview.pbix`

## Key Findings

| Area | Key Finding |
|---|---|
| Patient Demographics | Patients aged 50 and older account for the majority of discharge records. |
| Gender | Female discharge records represent 53.67% of the cohort. |
| Hospital Distribution | The cohort includes 151 hospitals across 49 counties. |
| Geographic Distribution | New York City accounts for 44 facilities. |
| Length of Stay | Overall average LOS is 2.65 days. |
| Patient Disposition | Home with Home Health Services represents 55.01% of discharges. |
| Severity | Major and extreme severity categories have higher average LOS and reported costs. |
| Mortality Risk | Average LOS and reported costs increase across the higher administrative risk categories. |
| Healthcare Costs | Average reported cost per discharge is $20,910.35. |
| Hospital Comparison | Syosset Hospital has the highest average LOS among the 15 highest-volume hospitals. |
| Cost Variation | NYU Lutheran Medical Center has the highest average reported cost per discharge in the selected cohort. |
| LOS and Cost | Spearman correlation indicates a positive association of approximately 0.393. |

## Recommendations

Based on the descriptive findings, the following areas may be considered for further healthcare operational investigation:

1. **Review Length-of-Stay Differences:** Investigate factors associated with higher LOS across hospitals and patient groups.

2. **Evaluate Discharge Planning:** Examine discharge planning processes for patients requiring home health services, skilled nursing facilities, and inpatient rehabilitation.

3. **Investigate Cost Variation:** Conduct further analysis of hospitals with higher reported costs per discharge.

4. **Consider Patient Severity:** Include severity and mortality-risk classifications when comparing hospital utilization and reported costs.

5. **Improve Hospital Benchmarking:** Use appropriate minimum discharge-volume thresholds and case-mix adjustment when comparing hospital performance.

6. **Support Data-Driven Decisions:** Use SQL analysis, Python visualizations, and Power BI dashboards to monitor healthcare utilization and financial indicators.

These recommendations are intended to guide further investigation rather than prescribe clinical or operational changes based solely on this dataset.

## Project Files

The repository contains the following project files:

| File | Description |
|---|---|
| `hospital_inpatient_discharges_totalhipreplacement.csv` | Original hospital inpatient discharge dataset |
| `hip_replacement_healthcare_analytics_study_queries.sql` | MySQL database queries and analytical questions |
| `us_healthcare_hip_replacement_data_analysis_final.ipynb` | Python exploratory data analysis notebook |
| `9hospitals_overview.pbix` | Interactive Power BI dashboard |
| `README.md` | Project documentation |

## How to Run the Project

### 1. Clone the Repository

```bash
git clone <your-github-repository-url>
