--наиболее активные доноры в системе, учитывая только данные о зарегистрированных и подтвержденных донациях.
SELECT
id,
  confirmed_donations AS donation_count
FROM user_anon_data AS u
WHERE confirmed_donations IS NOT NULL
GROUP BY id
ORDER BY confirmed_donations DESC
LIMIT 10
--donor_id  | donation_count
-----------------------------
--235391			361
--273317			257
--211970			236