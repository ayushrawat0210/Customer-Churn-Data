# 📊 Customer Churn Analysis in SQL

This project explores a fictional telecom churn dataset and answers 30+ real business questions using pure SQL.

## 📦 Dataset
- Table: `customer_churn_info` (≈7043 rows)
- Fields include: CustomerID, demographics, contract, services, monthly & total charges, churn status.

---

## ✅ Business Questions & SQL Highlights

- Total churn rate and churn rate by:
  - Contract type
  - Payment method
  - Paperless billing status
  - Tenure buckets
- Identify:
  - Top 5 highest-paying churned customers
  - Most common services among non-churned customers
- Revenue insights:
  - Total lost revenue from churned customers
  - Average MonthlyCharges for churned vs non-churned
- Advanced:
  - Window function to rank customers by TotalCharges within each contract

And more!

---

## 🧰 **Tools**
- MySQL
- Schema creation, aggregation, filtering, window functions

---

## 📌 **Sample queries**

```sql
-- Find churn rate for each contract type
SELECT 
    Contract,
    (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*)) AS churn_rate
FROM customer_churn_info
GROUP BY Contract;

-- Which services are most common among non-churned customers
SELECT 'OnlineSecurity' AS Service, COUNT(*) AS non_churned_with_service
FROM customer_churn_info
WHERE churn = 'No' AND OnlineSecurity = 'Yes'
UNION ALL
SELECT 'TechSupport', COUNT(*)
FROM customer_churn_info
WHERE churn = 'No' AND TechSupport = 'Yes'
...
ORDER BY non_churned_with_service DESC;
