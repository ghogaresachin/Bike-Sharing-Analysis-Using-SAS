# 🚴 Bike Sharing Data Analysis (SAS + Word Report)

This project presents a comprehensive analysis of bike-sharing data using SAS for statistical analysis and a detailed Word-based report to present findings. The analysis explores user behavior trends, seasonal and weather impacts, and evaluates marketing assumptions using real-world data.

---

## 📁 Project Structure

- `Bike Sharing Analysis Report_1.pdf` — Final report (originally created in Microsoft Word)
- `SAS Code` — Scripts for data cleaning, analysis, and visualization
- `README.md` — Project overview and documentation
- `/images/` — Folder containing visual screenshots from the report

---

## 📊 Dataset Overview

Two datasets were used:

- **`day.csv`**: Daily rental records including season, holiday, working day, weather, and user counts
- **`hour.csv`**: Hourly records with time-specific usage details

Source: [UCI Machine Learning Repository - Bike Sharing Dataset](https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset)

---

## 🧰 Tools & Technologies

- **SAS 9.4**: Data preprocessing, statistical analysis, hypothesis testing, and plots
- **Microsoft Word**: Final report creation
- **GitHub**: Version control and sharing

---

## 📈 Key Analytical Tasks

### 1. **Data Preparation**
- Combined and enhanced variables (`total_users`, `season_name`, `weekend_flag`, `weather_type`)
- Created time categories for hourly data (e.g., "Morning Rush")

### 2. **User Behavior Trends**
- Analyzed patterns of casual vs. registered users
- Identified extreme values and weekday/weekend behavior

### 3. **Year-over-Year Comparison (2011 vs. 2012)**
- Monthly trends plotted
- T-tests used to assess growth in registered users

### 4. **Marketing Claims Validation**
- One-sample t-tests tested claims like "Spring ≥ 4000 users/day"
- Most claims were **rejected** based on statistical evidence

### 5. **Weather & Season Impact**
- ANOVA tests showed significant usage differences based on season and weather
- Rain/Snow dramatically reduced ridership

### 6. **Hourly Peak Patterns**
- Usage patterns categorized by time of day
- Visualized peak hours for both casual and registered users

---

## 🖼️ Screenshots from Report

Here are a few visuals from the report (replace these with actual images in your GitHub repo):

![Monthly Registered Users](images/monthly_registered_users.png)
*Fig: Year-over-year trend comparison*

![Marketing Claims Validation](images/marketing_claims_validation.png)
*Fig: Summary table for seasonal claims*


---

## 📝 Key Business Insights

- **Registered users** are more predictable and less weather-sensitive.
- **Casual users** spike on weekends and clear weather days.
- **Fall and Summer** are peak seasons for ridership.
- **Weather** has a strong negative impact, especially rain/snow.
- **Targeted promotions** can be designed based on time, season, and weather.

---

## 🚀 Recommendations

- Optimize bike availability during **peak hours and seasons**
- Use **dynamic pricing** based on weather and demand
- **Boost Spring ridership** with discounts
- Launch **membership programs** to retain registered users
- Offer **rain gear bundles** or partnerships for wet weather

---

## 👤 Author

**[Your Name]**  
Master's in Applied Statistics  
Aspiring Data Analyst | Machine Learning Enthusiast  

🔗 [Connect with me on LinkedIn](www.linkedin.com/in/sachin-ghogare-325427208)

---

## 📜 License

This project is intended for educational and demonstration purposes.
