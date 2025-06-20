--Cредняя активность повторных доноров.
WITH donor_activity AS (
  SELECT user_id,
         COUNT(*) AS total_donations,
         (MAX(donation_date) - MIN(donation_date)) AS activity_duration_days,
         (MAX(donation_date) - MIN(donation_date)) / (COUNT(*) - 1) AS avg_days_between_donations,
         EXTRACT(YEAR FROM MIN(donation_date)) AS first_donation_year,
         EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(donation_date))) AS years_since_first_donation
  FROM donorsearch.donation_anon
  GROUP BY user_id
  HAVING COUNT(*) > 1
)
SELECT first_donation_year,
       CASE 
	       WHEN total_donations = 1 THEN 'Однократные доноры'
           WHEN total_donations BETWEEN 2 AND 3 THEN '2-3 донации'
           WHEN total_donations BETWEEN 4 AND 5 THEN '4-5 донаций'
           ELSE '6 и более донаций'
       END AS donation_frequency_group,
       COUNT(user_id) AS donor_count,
       ROUND(AVG(total_donations),2) AS avg_donations_per_donor,
       ROUND(AVG(activity_duration_days),2) AS avg_activity_duration_days,
       ROUND(AVG(avg_days_between_donations),2) AS avg_days_between_donations,
       ROUND(AVG(years_since_first_donation),2) AS avg_years_since_first_donation
FROM donor_activity
GROUP BY first_donation_year, donation_frequency_group
ORDER BY first_donation_year DESC, donation_frequency_group
  
-- -- Таблица:

--2023	2-3 донации			1220	2.24	87.54	72.93	1.76
--2023	4-5 донаций			151		4.33	172.68	52.13	1.85
--2023	6 и более донаций	63		8.41	207.32	28.79	1.94
--2022	2-3 донации			2190	2.32	161.12	125.63	2.43
--2022	4-5 донаций			671		4.41	334.08	98.50	2.48
--2022	6 и более донаций	553		9.26	429.58	60.97	2.55
--2021	2-3 донации			884		2.39	243.08	182.80	3.30
--2021	4-5 донаций			423		4.43	461.35	134.80	3.34
--2021	6 и более донаций	655		11.64	688.85	81.45	3.45
--2020	2-3 донации			379		2.35	305.76	234.82	4.47

-- Выводы:
-- Аномальные данные: В текущем наборе данных были обнаружены серьёзные аномалии, такие как 
-- очень длительные периоды активности доноров (до 1800 лет) и большие промежутки между донациями.
--  Это свидетельствует о наличии ошибок в данных, особенно в части корректности указания дат донаций. 
--  Возможно, такие ошибки связаны с ручным вводом данных или некорректной обработкой при переносе из других источников.

-- Повторные доноры — ключевая аудитория: Исходя из структуры данных, повторные доноры играют ключевую роль 
-- в донорских программах, и работа с их поддержанием крайне важна. Они совершают большее количество донаций,
--  что требует внимательного анализа и создания программ удержания.