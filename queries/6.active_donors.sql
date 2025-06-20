WITH donor_activity AS (
  SELECT user_id,
         COUNT(*) AS total_donations,
         (MAX(donation_date) - MIN(donation_date)) AS activity_duration_days,
         CASE 
           WHEN COUNT(*) > 1 THEN (MAX(donation_date) - MIN(donation_date)) / (COUNT(*) - 1)
           ELSE NULL
         END AS avg_days_between_donations,
         EXTRACT(YEAR FROM MIN(donation_date)) AS first_donation_year,
         EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(donation_date))) AS years_since_first_donation
  FROM donorsearch.donation_anon
  GROUP BY user_id
)
SELECT CASE 
           WHEN first_donation_year = 208 THEN 2008
           WHEN first_donation_year = 214 THEN 2014
           WHEN first_donation_year = 207 THEN 2007
           WHEN first_donation_year = 201 THEN 2001
           ELSE first_donation_year
       END AS first_donation_year,
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
ORDER BY first_donation_year DESC, donation_frequency_group;
