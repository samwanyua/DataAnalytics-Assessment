-- Assessment_Q1.sql

SHOW DATABASES;

use adashi_staging;

show tables;



SELECT
    s.owner_id,
    CONCAT_WS(' ', u.first_name, u.last_name) AS name,
    SUM(CASE WHEN s.is_regular_savings = 1 AND s.amount >= 0 THEN 1 ELSE 0 END) AS savings_count,
    SUM(CASE WHEN s.is_fixed_investment = 1 AND s.amount >= 0 THEN 1 ELSE 0 END) AS investment_count,
    SUM(s.amount) AS total_deposits
FROM plans_plan s
JOIN users_customuser u ON s.owner_id = u.id
WHERE u.first_name IS NOT NULL AND u.last_name IS NOT NULL
GROUP BY s.owner_id
HAVING savings_count > 0 AND investment_count > 0
ORDER BY total_deposits DESC;



