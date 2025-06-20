--Проанализировать планирования доноров и их реальной активности
WITH planned_donations AS (
  SELECT DISTINCT user_id, donation_date, donation_type
  FROM donorsearch.donation_plan
),
actual_donations AS (
  SELECT DISTINCT user_id, donation_date
  FROM donorsearch.donation_anon
),
planned_vs_actual AS (
  SELECT
    pd.user_id,
    pd.donation_date AS planned_date,
    pd.donation_type,
    CASE WHEN ad.user_id IS NOT NULL THEN 1 ELSE 0 END AS completed
  FROM planned_donations pd
  LEFT JOIN actual_donations ad ON pd.user_id = ad.user_id AND pd.donation_date = ad.donation_date
)
SELECT
  donation_type,
  COUNT(*) AS total_planned_donations,
  SUM(completed) AS completed_donations,
  ROUND(SUM(completed) * 100.0 / COUNT(*), 2) AS completion_rate
FROM planned_vs_actual
GROUP BY donation_type;

    
-- |donation_type|total_planned_donations|completed_donations|completion_rate|
-- |-------------|-----------------------|-------------------|---------------|
-- |Безвозмездно |          22903        |        4950       |      21.61    |
-- |Платно       |          3299         |        429        |      13.00    |

-- Из представленных данных видно, что процент выполнения планов донаций 
-- низок для обоих типов доноров: 21.61% для безвозмездных и 13.00% для платных.
-- Это указывает на необходимость повышения вовлечённости доноров, особенно платных.
-- Рекомендуется провести мероприятия по мотивации доноров, такие как программы поощрения
-- и улучшение коммуникации о важности донорства.