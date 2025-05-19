SHOW DATABASES;

use adashi_staging;

show tables;

SELECT 
  p.id AS plan_id,
  p.owner_id,
  CASE 
    WHEN p.plan_type_id = 1 THEN 'Savings'
    WHEN p.plan_type_id = 2 THEN 'Investment'
    ELSE 'Other'
  END AS type,
  MAX(s.transaction_date) AS last_transaction_date,
  DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s
  ON p.id = s.plan_id 
  AND s.amount > 0
  AND s.transaction_status = 'success'
WHERE p.is_archived = 0
  AND p.is_deleted = 0
GROUP BY p.id, p.owner_id, p.plan_type_id
HAVING 
  MAX(s.transaction_date) IS NULL 
  OR DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) > 365
ORDER BY inactivity_days DESC;
