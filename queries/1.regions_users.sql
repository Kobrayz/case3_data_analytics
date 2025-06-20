--регионы с наибольшим количеством зарегистрированных доноров.
SELECT region, COUNT(id )
FROM user_anon_data
GROUP BY region
ORDER BY COUNT(id ) DESC
--NULL							100574
--Россия, Москва				37819
--Россия, Санкт-Петербург		13137
--Россия, Татарстан, Казань		6610
