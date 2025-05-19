SHOW DATABASES;

use adashi_staging;

show tables;

SELECT
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM (
  SELECT
    customer_id,
    avg_transactions_per_month,
    CASE
      WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
      WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM (
    SELECT
      customer_id,
      AVG(transactions_count) AS avg_transactions_per_month
    FROM (
      SELECT
        s.owner_id AS customer_id,
        COUNT(*) AS transactions_count
      FROM savings_savingsaccount s
      GROUP BY
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m')
    ) AS monthly_transactions
    GROUP BY customer_id
  ) AS average_transactions
) AS categorized
GROUP BY frequency_category
ORDER BY
  CASE frequency_category
    WHEN 'High Frequency' THEN 1
    WHEN 'Medium Frequency' THEN 2
    WHEN 'Low Frequency' THEN 3
    ELSE 4
  END;
