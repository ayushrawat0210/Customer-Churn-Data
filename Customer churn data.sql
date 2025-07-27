Create schema Customer_churn;
use Customer_churn;

CREATE TABLE Customer_churn_info (
    CustomerID VARCHAR(20) PRIMARY KEY,
    Gender VARCHAR(10),
    SeniorCitizen TINYINT,
    Partner VARCHAR(4),
    Dependents VARCHAR(4),
    Tenure INT,
    PhoneService VARCHAR(20),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(20),
    PaymentMethod VARCHAR(40),
    MonthlyCharges DECIMAL(8 , 2 ),
    TotalCharges DECIMAL(10 , 2 ),
    Churn VARCHAR(4)
);


-- ==========================================================================================================================


-- Get all records where Churn = 'Yes'.

SELECT 
    *
FROM
    customer_churn_info
WHERE
    churn = 'Yes';

-- Find total number of customers who are SeniorCitizen = 1.

SELECT 
    COUNT(SeniorCitizen) AS Total_Seniorcitizen
FROM
    customer_churn_info
WHERE
    SeniorCitizen = 1;

-- List distinct Contract types.

SELECT DISTINCT
    (contract) AS Contract_type
FROM
    customer_churn_info;

-- Count how many customers have InternetService = 'DSL'.

SELECT 
    COUNT(*) AS Num_of_customer
FROM
    customer_churn_info
WHERE
    InternetService = 'DSL';

-- Show customerID, MonthlyCharges, and TotalCharges where MonthlyCharges > 100.

SELECT 
    CustomerID, MonthlyCharges, TotalCharges
FROM
    customer_churn_info
WHERE
    MonthlyCharges > 100
ORDER BY TotalCharges DESC;

-- Retrieve customers who have OnlineSecurity = 'No' and Churn = 'Yes'.

SELECT 
    *
FROM
    customer_churn_info
WHERE
    OnlineSecurity = 'No' AND churn = 'Yes';

-- Find the average MonthlyCharges.

SELECT 
    AVG(MonthlyCharges) AS Avg_of_monthlyCharges
FROM
    customer_churn_info;

-- Count customers who have both StreamingTV = 'Yes' and StreamingMovies = 'Yes'.

SELECT 
    COUNT(*) AS Num_of_StreamingTv_Movies
FROM
    customer_churn_info
WHERE
    StreamingTV = 'Yes'
        AND StreamingMovies = 'Yes';

-- List customers with Contract = 'Month-to-month' and Churn = 'Yes'.

SELECT 
    *
FROM
    customer_churn_info
WHERE
    Contract = 'Month-to-month'
        AND churn = 'Yes';

-- Retrieve top 10 customers with the highest TotalCharges.

SELECT 
    *
FROM
    customer_churn_info
ORDER BY TotalCharges DESC
LIMIT 10;

-- Find the number of customers by each PaymentMethod.

SELECT 
    Paymentmethod, COUNT(*) AS num_of_customer
FROM
    customer_churn_info
GROUP BY Paymentmethod;

-- Get the churn rate (percentage of customers who churned).

SELECT 
    ROUND(SUM(CASE
                WHEN churn = 'Yes' THEN 1
                ELSE 0
            END) / (SELECT 
                    COUNT(*)
                FROM
                    customer_churn_info),
            2) * 100.0 AS pct_of_churnCustomer
FROM
    customer_churn_info; 

-- Compare average MonthlyCharges between Churn = 'Yes' and Churn = 'No'.

SELECT 
    Churn, ROUND(AVG(MonthlyCharges), 2) AS avg_MonthlyCharges
FROM
    customer_churn_info
GROUP BY Churn;

-- List the top 3 Internet services used by customers who churned.

SELECT 
    InternetService, COUNT(churn) AS Churn_count
FROM
    customer_churn_info
WHERE
    churn = 'Yes'
GROUP BY InternetService
ORDER BY churn_count DESC
LIMIT 3;

-- Find the average tenure for customers grouped by Contract type.

SELECT 
    Contract, ROUND(AVG(tenure), 0) AS avg_tenure_in_Months
FROM
    customer_churn_info
GROUP BY Contract;

-- Count how many customers use PhoneService and also have MultipleLines = 'Yes'.

SELECT 
    COUNT(CASE
        WHEN PhoneService = 'Yes' THEN 1
        ELSE 0
    END) AS count_phoneService
FROM
    customer_churn_info
WHERE
    MultipleLines = 'Yes';

-- Find how many customers have no internet services at all (InternetService = 'No').

SELECT 
    SUM(CASE
        WHEN InternetService = 'No' THEN 1
        ELSE 0
    END) AS count_InternetService
FROM
    customer_churn_info;

-- List all customers whose TotalCharges is less than the average TotalCharges.

SELECT 
    CustomerID, SUM(TotalCharges) AS Total_Charge
FROM
    customer_churn_info
GROUP BY customerId
HAVING SUM(TotalCharges) > (SELECT 
        AVG(TotalCharges) AS avg_charge
    FROM
        customer_churn_info)
ORDER BY Total_charge;

-- Find the churn rate for each Contract type.

SELECT 
    Contract,
    (SUM(CASE
        WHEN churn = 'Yes' THEN 1
        ELSE 0
    END) * 100 / COUNT(*)) AS Churn_rate
FROM
    customer_churn_info
GROUP BY Contract; 

-- Calculate total revenue (TotalCharges) for churned customers.

SELECT 
    SUM(TotalCharges) AS Total_revenue
FROM
    customer_churn_info
WHERE
    churn = 'Yes';

-- Which PaymentMethod has the highest churn rate?

SELECT 
    PaymentMethod,
    (SUM(CASE
        WHEN churn = 'Yes' THEN 1
        ELSE 0
    END) * 100 / COUNT(*)) AS churn_rate
FROM
    customer_churn_info
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- Among customers with tenure > 24 months, what’s the churn rate?

SELECT 
    (SUM(CASE
        WHEN churn = 'Yes' THEN 1
        ELSE 0
    END) * 100 / COUNT(*)) AS churn_rate
FROM
    customer_churn_info
WHERE
    tenure > 24;

--  Create churn buckets:
-- CASE 
--   WHEN tenure <= 12 THEN '0-1 year'
--   WHEN tenure <= 24 THEN '1-2 years'
--   ...
-- Then count churned customers in each bucket.

SELECT 
    COUNT(*) AS churned_count,
    CASE
        WHEN tenure <= 12 THEN '0-1 year'
        WHEN tenure <= 24 THEN '1-2 year'
        WHEN tenure <= 36 THEN '2-3 year'
        WHEN tenure <= 48 THEN '3-4 year'
        WHEN tenure <= 60 THEN '4-5 year'
        WHEN tenure <= 72 THEN '5-6 year'
    END AS Churn_buckets
FROM
    customer_churn_info
WHERE
    churn = 'Yes'
GROUP BY Churn_buckets
ORDER BY Churn_buckets;

-- Which InternetService type has the highest average MonthlyCharges?

SELECT 
    InternetService,
    ROUND(AVG(MonthlyCharges), 2) AS Highest_avg_monthly_charges
FROM
    customer_churn_info
GROUP BY InternetService
ORDER BY AVG(MonthlyCharges) DESC
LIMIT 1;

-- Is there a relationship between PaperlessBilling = 'Yes' and Churn?

SELECT 
    PaperlessBilling,
    ROUND(SUM(CASE
                WHEN churn = 'Yes' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS churn_rate
FROM
    customer_churn_info
GROUP BY paperlessbilling;

-- Identify the top 5 highest-paying churned customers.

SELECT 
    CustomerID, Totalcharges AS Total_charge
FROM
    customer_churn_info
WHERE
    churn = 'Yes'
ORDER BY Totalcharges DESC
LIMIT 5;

-- For each Contract type, calculate average TotalCharges of churned vs non-churned.

SELECT 
    contract, churn, AVG(Totalcharges) AS avg_charges
FROM
    customer_churn_info
GROUP BY contract , churn
ORDER BY AVG(Totalcharges) DESC;

-- Which services (OnlineSecurity, TechSupport, etc.) are most common among non-churned customers?

SELECT 
    'OnlineSecurity', COUNT(*) AS Non_churned_service_customers
FROM
    customer_churn_info
WHERE
    churn = 'No' AND OnlineSecurity = 'Yes' 
UNION ALL SELECT 
    'TechSupport', COUNT(*)
FROM
    customer_churn_info
WHERE
    churn = 'No' AND TechSupport = 'Yes' 
UNION ALL SELECT 
    'Onlinebackup', COUNT(*)
FROM
    customer_churn_info
WHERE
    churn = 'No' AND Onlinebackup = 'Yes' 
UNION ALL SELECT 
    'Deviceprotection', COUNT(*)
FROM
    customer_churn_info
WHERE
    churn = 'No'
        AND Deviceprotection = 'Yes' 
UNION ALL SELECT 
    'StreamingTV', COUNT(*)
FROM
    customer_churn_info
WHERE
    churn = 'No' AND StreamingTV = 'Yes' 
UNION ALL SELECT 
    'Streamingmovies', COUNT(*)
FROM
    customer_churn_info
WHERE
    churn = 'No' AND Streamingmovies = 'Yes'
ORDER BY Non_churned_service_customers;

 -- What is the total lost revenue from churned customers?
 
SELECT 
    SUM(Totalcharges) AS Total_lost_revenue
FROM
    customer_churn_info
WHERE
    churn = 'Yes';
 
--  Use a window function to rank customers by TotalCharges within each Contract.

Select customerID, contract, Totalcharges,
rank() over (partition by contract Order by Totalcharges desc) as Ranking_customers_by_totalcharges
from customer_churn_info;


-- ====================================Done==============================================================









