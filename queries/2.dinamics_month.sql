--динамика общего количества донаций в месяц за 2022 и 2023 годы
SELECT date_trunc('month', donation_date::timestamp) AS donation_month, COUNT(*) AS total_donations
FROM donation_anon 
WHERE extract(YEAR FROM donation_date) IN (2022,2023)
GROUP BY donation_month
ORDER BY donation_month
