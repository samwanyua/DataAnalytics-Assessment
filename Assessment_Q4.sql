SHOW DATABASES;

use adashi_staging;

show tables;

SELECT 
  u.id AS customer_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
  COUNT(s.id) AS total_transactions,
  ROUND((
    (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 0)) 
    * 12 
    * (0.001 * SUM(s.confirmed_amount) / NULLIF(COUNT(s.id), 0)) / 100
  ), 2) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.transaction_status = 'success'
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
ORDER BY estimated_clv DESC;
