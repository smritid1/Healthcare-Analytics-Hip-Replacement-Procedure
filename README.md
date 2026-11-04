# Healthcare Analytics: Hip Replacement Procedures

## Project Overview

This project is a healthcare analytics case study. The objective was to analyze hospital efficiency across New York State for patients undergoing **elective hip replacement surgery**.

The project was developed around a fictional healthcare consulting company called **HealthStat**, which wanted to identify opportunities to improve hospital operational efficiency while maintaining high-quality patient care.

The analysis focuses primarily on two key efficiency metrics:

- **Average Length of Stay (LOS)**
- **Average Cost per Discharge**

The project combines data modeling, data cleaning, exploratory data analysis, DAX calculations, hospital benchmarking, root-cause analysis, data visualization, and interactive dashboard design.

---

## Business Problem

Healthcare organizations continuously aim to improve operational efficiency without compromising the quality of patient care.
HealthStat wanted to understand:

1. Which hospitals have higher or lower Length of Stay compared with the statewide benchmark?
2. Which hospitals have higher or lower average cost per discharge?
3. Which hospitals are potential efficiency outliers?
4. How can these findings be communicated effectively to healthcare stakeholders?

---

# Healthcare Quality Framework

Healthcare quality can be evaluated across six major domains:

1. **Safety**
2. **Effectiveness**
3. **Timeliness**
4. **Patient-Centered Care**
5. **Equity**
6. **Efficiency**

This case study focuses specifically on the **Efficiency** domain.

### Efficiency

Efficiency is concerned with avoiding unnecessary waste, including the waste of:

- Equipment
- Supplies
- Ideas
- Energy
- Time
- Other healthcare resources

The project therefore evaluates hospital efficiency primarily through **Length of Stay** and **Cost per Discharge**.

---

# Clinical Focus: Elective Hip Replacement

The patient population analyzed in this case study consists of patients who received **elective hip replacement surgery**.

Hip replacement is commonly performed for patients experiencing significant hip pain or joint damage, often associated with conditions such as arthritis.

The procedure involves removing damaged bone and cartilage and replacing them with prosthetic components.

Because hip replacement is an elective procedure, hospital efficiency can be evaluated by examining:

- Patient Length of Stay
- Hospital cost
- Patient characteristics
- Hospital characteristics
- Procedure characteristics
- Patient discharge disposition

---

# Dataset Overview

The dataset contains statewide hospital discharge information for **New York State** for one year.

### Dataset characteristics

| Metric | Value |
|---|---:|
| Hospitals | **151** |
| Discharges | **26K+** |
| Columns | **30** |
| Dataset structure | Single table |
| Unit of analysis | One inpatient hospital stay |
| Geographic coverage | New York State |
| Main procedure | Elective hip replacement |

Each row represents a single inpatient stay from admission through discharge.

The dataset is de-identified and does not contain individually identifiable personal health information.

---

# Key Procedure Descriptions

The two most frequently reported procedure descriptions were:

1. **HIP REPLACEMENT, TOT/PRT**
2. **OT OR THER PRC ON JOINT**

The primary analytical focus of the case study is elective hip replacement surgery.

---

# Important Healthcare Terminology

### Inpatient

A patient who has been admitted to a hospital bed for treatment or care.

### Discharge

The release of a patient from hospital care by a medical professional.

### Disposition

The patient's destination or status after being discharged from the hospital.

Examples include:

- Home
- Skilled Nursing Home
- Another healthcare facility
- Other destinations

### Elective Surgery

A procedure that is planned in advance rather than performed because of an emergency.

### Length of Stay (LOS)

The total duration, measured in days, that a patient remains in the hospital during an inpatient stay.

---

# Key Performance Indicators

## 1. Average Length of Stay

The statewide average Length of Stay was:

### **2.65 days**

This became an important benchmark for comparing hospitals and patient groups.

A shorter LOS is generally desirable from an operational efficiency perspective because it can:

- Reduce hospital costs
- Release hospital bed capacity
- Improve patient throughput
- Allow hospitals to serve more patients

However, a shorter LOS should not come at the expense of patient safety or quality of care.

---

## 2. Average Cost per Discharge

The project also introduced average cost per discharge as a second major efficiency metric.

The metric was calculated as:

**Average Cost per Discharge = Total Costs / Total Discharges**

The statewide average cost per discharge was approximately:

### **$21K**

This value was used as a benchmark when comparing hospitals and geographic regions.

---

# Hospital Analysis

The analysis identified **151 hospitals** performing the procedure across New York State.

## Hospitals by Health Service Area

New York City had the highest number of hospitals in the dataset:

- **44 hospitals**
- **29.14% of all hospitals**

This made New York City the largest health service area by hospital count.

---

# Patient Population Analysis

## Total Discharges

The dataset contained approximately:

### **26K total discharges**

---

## Discharges by Gender

The distribution of discharges was approximately:

| Gender | Share of Discharges |
|---|---:|
| Female | **53.67%** |
| Male | **46.33%** |

Females represented a slightly larger share of total discharges.

However, gender was later found to be **not a significant influencer of average LOS or cost per discharge**.

---

## Discharges by Age Group and Gender

The analysis examined:

- Age 50–69
- Age 70 or older

and compared them by gender.

The smallest group among patients aged 50 or older was:

### **Male, Age 70 or older**

This group represented:

### **13.39% of total discharges**

The next smallest group was:

### **Female, Age 70 or older — 22.31%**

---

# Length of Stay Analysis

The statewide average LOS was:

### **2.65 days**

LOS was analyzed across multiple patient and hospital characteristics.

---

## Average LOS for Males Aged 50+

The average Length of Stay for males aged 50 or older was:

### **2.53 days**

This provides an example of how LOS can be analyzed across demographic groups.

---

# Hospital Benchmarking

The project compared hospitals based on:

- Total discharge volume
- Average LOS
- Average cost per discharge
- Percentage variation from statewide averages
- Surgical program size
- Number of surgeons

This allowed hospitals to be benchmarked against the statewide average.

---

# Top 15 Hospitals by Discharge Volume

Among the top 15 hospitals by discharge volume, the hospital with the longest average LOS was:

### **Syosset Hospital**

Key metrics:

- **Average LOS:** 3.22 days
- **Number of surgeons:** 11

This result motivated further investigation into the factors contributing to longer hospital stays.

---

# Cost Analysis

The Cost page of the Power BI report compares hospitals against the statewide average cost benchmark.

### Statewide average cost per discharge

**Approximately $21K**

The report compares each hospital's:

- Average Cost per Discharge
- Percentage variation from the state average
- Average LOS
- Percentage variation from the state average

This enables stakeholders to identify hospitals that are performing significantly above or below statewide benchmarks.

---

# Cost by Health Service Area

The health service area with the highest average cost per discharge was:

### **New York City**

Average cost per discharge:

### **$25,502**

This indicates that New York City hospitals had a higher average cost per discharge than the statewide benchmark.

---

# Hospital with Highest Average Cost

The hospital with the highest overall average cost per discharge was:

### **NYU Lutheran Medical Center**

Average cost per discharge:

### **$84,601**

This represents a significant difference from the statewide average of approximately $21K and makes the hospital an important candidate for further investigation.

A high cost does not automatically indicate poor performance. Differences in patient complexity, severity, mortality risk, procedures, and resource requirements should be considered before concluding that a hospital is inefficient.

---

# Hospital Comparison Analysis

The Hospital Comparison page combines:

- **Total Discharges**
- **Average LOS Days**

This allows hospitals to be evaluated based on both volume and efficiency.

The report also displays:

### **627 Total Surgeons**

This provides additional context about the size of the surgical workforce across the analyzed hospitals.

---

# Root Cause Analysis

A major objective of the case study was to identify factors associated with differences in:

- Average LOS
- Average Cost per Discharge

The analysis examined multiple explanatory variables.

These included:

- Age
- Gender
- Severity of illness
- Risk of mortality
- Diagnosis
- Patient disposition
- Health service area
- Surgical program size
- Hospital characteristics

---

# Key Root Cause Findings

## 1. Age

Age was not identified as a significant influencer of:

- Average LOS
- Average Cost per Discharge

Although LOS and cost may vary slightly between age groups, age was not identified as a major driver of efficiency differences in this analysis.

---

## 2. Gender

Gender was also not identified as a significant influencer of:

- Average LOS
- Average Cost per Discharge

The discharge distribution showed slightly more female patients, but this did not translate into a meaningful difference in hospital efficiency.

---

## 3. Severity of Illness

### Extreme illness severity was a major influencer.

Patients with extreme illness severity were associated with:

- Higher Average LOS
- Higher Average Cost per Discharge

This is an important finding because patients with more severe conditions may require:

- Additional monitoring
- More complex treatment
- Greater resource utilization
- Longer recovery periods

Therefore, patient complexity needs to be considered when benchmarking hospital efficiency.

---

## 4. Risk of Mortality

Extreme and major mortality risk were also identified as important factors associated with reduced efficiency.

Higher mortality risk was associated with:

- Higher LOS
- Higher costs

This suggests that patient case mix is an important consideration when evaluating hospital performance.

---

## 5. Patient Disposition

Patient disposition was another factor associated with LOS.

Patients discharged to a:

### **Skilled Nursing Home**

had a higher average LOS than the statewide average of **2.65 days**.

This may reflect differences in patient recovery requirements and post-hospital care needs.

However, this is an association and should not automatically be interpreted as proof that disposition causes a longer stay.

---

## 6. Health Service Area

Hospitals located in:

### **New York City**

tended to have:

- Higher average cost
- Higher average LOS

than many other areas of the state.

This geographic variation was therefore considered relevant when investigating hospital efficiency.

---

## 7. Surgical Program Size

Surgical program size was also analyzed.

Hospitals with a surgical program size of:

### **400–599**

were associated with approximately:

### **$5.42K lower average cost per discharge**

This may indicate potential economies of scale, where hospitals with larger surgical programs can potentially utilize:

- Staff
- Equipment
- Operating rooms
- Facilities
- Administrative resources

more efficiently.

This finding represents an association rather than proof of causation.

---

These visuals allow stakeholders to identify patterns and potential drivers of cost variation.

---

# Dashboard Structure

The final Power BI report contains several analytical pages.

### **151 Total Hospitals**

- New York City had the largest number of hospitals.
- NYC accounted for **44 hospitals / 29.14%** of all hospitals.

---

### **26K Total Discharges**

- Female: **53.67%**
- Male: **46.33%**
- Male age 70+: **13.39% of total discharges**

---

### **2.65 Average LOS Days**

- Males aged 50+ had an average LOS of **2.53 days**.

---

### **627 Total Surgeons**

---

### **$21K Average Cost per Discharge**

- NYC average cost per discharge: **$25,502**
- Highest hospital average cost: **NYU Lutheran Medical Center — $84,601**

---

# Major Business Insights

The most important findings from the analysis are summarized below.

| Area | Key Finding |
|---|---|
| Total Hospitals | **151** |
| Total Discharges | **26K+** |
| Total Surgeons | **627** |
| State Average LOS | **2.65 days** |
| State Average Cost | **~$21K** |
| Largest Hospital Region | **New York City** |
| NYC Hospitals | **44 / 29.14%** |
| Smallest 50+ Patient Group | **Male 70+ — 13.39%** |
| Female 70+ | **22.31%** |
| Male 50+ Average LOS | **2.53 days** |
| Highest LOS among Top 15 by Volume | **Syosset Hospital — 3.22 days** |
| Surgeons at Syosset Hospital | **11** |
| Highest-Cost Health Service Area | **New York City — $25,502** |
| Highest-Cost Hospital | **NYU Lutheran Medical Center — $84,601** |
| Surgical Program Size 400–599 | **~$5.42K lower average cost/discharge** |
| Important LOS/Cost Influencer | **Extreme illness severity** |
| Important LOS/Cost Influencer | **Extreme/Major mortality risk** |
| LOS Influencer | **Skilled Nursing Home disposition** |
| Weak Influencers | **Age and Gender** |

---

# Key Analytical Takeaways

### 1. Hospital efficiency varies significantly

There was substantial variation in both:

- Average LOS
- Average cost per discharge

between hospitals.

This indicates that benchmarking can help identify potential opportunities for improvement.

---

### 2. Patient complexity matters

Extreme illness severity and higher mortality risk were strongly associated with higher:

- LOS
- Cost

Therefore, hospitals should be compared while considering the complexity of the patients they treat.

---

### 3. Geography matters

New York City hospitals tended to have higher:

- Average cost
- Average LOS

than many other health service areas.

---

### 4. Disposition is associated with LOS

Patients discharged to skilled nursing homes had a higher average LOS than the statewide average.

This highlights the importance of considering post-hospital care requirements when analyzing patient stays.

---

### 5. Age and gender are not major efficiency drivers

Although patient volumes differ across age and gender groups, these attributes were not identified as significant influencers of:

- Average LOS
- Average Cost per Discharge

---

### 6. Surgical program size may be associated with lower costs

The 400–599 surgical program size group showed approximately **$5.42K lower average cost per discharge**, suggesting that program scale may contribute to cost efficiency.

---

# Business Recommendations

Based on the analysis, healthcare stakeholders could consider the following areas for further investigation:

### 1. Investigate high-LOS hospitals

Hospitals with LOS significantly above the statewide average of **2.65 days** should be investigated to understand the operational and patient-related factors contributing to longer stays.

### 2. Benchmark high-cost hospitals

Facilities with substantially higher average costs should be examined for differences in:

- Patient severity
- Mortality risk
- Diagnosis
- Resource utilization
- LOS
- Surgical program characteristics

### 3. Adjust benchmarking for patient complexity

Hospitals treating more severe or higher-risk patients may naturally experience higher LOS and costs.

Therefore, hospital benchmarking should consider patient case mix rather than evaluating cost alone.

### 4. Investigate discharge planning

The association between skilled nursing home disposition and higher LOS suggests that discharge planning and post-acute care pathways could be investigated further.

### 5. Explore economies of scale

The lower average cost associated with surgical program sizes of 400–599 suggests that hospital program scale may warrant further investigation.

### 6. Focus improvement initiatives on meaningful drivers

Since age and gender were not significant influencers, improvement initiatives should focus more heavily on factors such as:

- Illness severity
- Mortality risk
- Patient disposition
- Hospital characteristics
- Geographic variation
- Surgical program size

---

# Important Analytical Consideration

The findings in this project describe **associations and patterns in the dataset**.

They should not automatically be interpreted as causal relationships.

For example:

> A higher illness severity is associated with higher cost.

This does not necessarily mean that illness severity alone causes higher cost.

Similarly:

> Patients discharged to skilled nursing homes have higher LOS.

This does not prove that the discharge destination itself causes longer hospital stays.

Healthcare stakeholders should consider clinical context, patient case mix, and additional operational factors before making causal conclusions.
