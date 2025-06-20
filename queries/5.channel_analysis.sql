--Вовлечение новых доноров через социальные сети. Сколько по каким каналам пришло доноров, и среднее количество донаций по каждому каналу.
SELECT channel, 
COUNT(*) AS donor_count,
ROUND(AVG(confirmed_donations),2) AS avg_confirmed_donations
FROM (
SELECT
id,confirmed_donations, 
CASE
	WHEN autho_vk THEN 'VK'
    WHEN autho_ok THEN 'OK'
    WHEN autho_tg THEN 'Telegram'
    WHEN autho_yandex THEN 'Yandex'
    WHEN autho_google THEN 'Google'
    ELSE 'Other'
END AS channel
FROM user_anon_data
WHERE confirmed_donations IS NOT null
) AS info
GROUP BY channel
ORDER BY donor_count DESC
--VK		127254	0.91
--Other		113266	0.71
--Google	14292	1.08
--OK		6410	0.56
--Yandex	4133	1.73
--Telegram	481		1.17