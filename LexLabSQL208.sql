USE sakila;

-- Q1 Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, ci.city, co.country
FROM sakila.store s
LEFT JOIN address 
USING (address_id)
JOIN sakila.city ci
USING (city_id)
JOIN sakila.country co
USING (country_id);

-- Q2 Write a query to display how much business, in dollars, each store brought in.
SELECT sto.store_id, SUM(p.amount) AS total_amount
FROM sakila.payment p
LEFT JOIN rental r
USING (rental_id)
JOIN sakila.staff sta
ON r.staff_id = sta.staff_id
JOIN sakila.store sto
ON sta.store_id = sto.store_id
GROUP BY sto.store_id;

-- Q3 Which film categories are longest?
SELECT c.name, ROUND(AVG(f.length)) AS average_length_mins
FROM sakila.film f
JOIN sakila.film_category fc
USING (film_id)
JOIN sakila.category c 
USING (category_id)
GROUP BY c.name;

-- Q4 Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(f.title) AS count_movies
FROM sakila.payment p
JOIN sakila.rental r
USING (rental_id)
JOIN sakila.inventory i 
USING (inventory_id)
JOIN sakila.film f
USING (film_id)
GROUP BY f.title
ORDER BY count_movies DESC;

-- Q5 List the top five genres in gross revenue in descending order.
SELECT c.name, SUM(p.amount) AS total_revenue
FROM sakila.film f
JOIN sakila.film_category fc
USING (film_id)
JOIN sakila.category c 
USING (category_id)
JOIN sakila.payment p
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 5;

-- Q6 Is "Academy Dinosaur" available for rent from Store 1?

SELECT*
FROM(
SELECT f.title, i.inventory_id, COUNT(f.title)
FROM sakila.film f
JOIN sakila.inventory i
ON f.film_id = i.film_id
WHERE i.store_id = '1'
GROUP BY (i.inventory_id)
HAVING f.title = 'Academy Dinosaur')inventory
JOIN
(SELECT i.inventory_id, COUNT(i.film_id)
FROM sakila.inventory i
JOIN sakila.rental r
ON i.inventory_id = r.inventory_id
WHERE (r.return_date IS NULL)
GROUP BY (i.inventory_id))rented_out
USING (inventory_id);

-- 'Academy Dinosaur' isn't available for rent from store 1

-- Below were separate counts of the inventory and the rentals, later found way to combine as above
-- SELECT f.title, COUNT(f.title)
-- FROM sakila.film f
-- JOIN sakila.inventory i
-- ON f.film_id = i.film_id
-- WHERE i.store_id = '1'
-- GROUP BY (f.title)
-- HAVING f.title = 'Academy Dinosaur';

-- SELECT i.inventory_id, COUNT(i.film_id)
-- FROM sakila.inventory i
-- JOIN sakila.rental r
-- ON i.inventory_id = r.inventory_id
-- WHERE r.return_date IS NULL AND i.film_id = "1"
-- GROUP BY (i.inventory_id);

-- Q7 Get all pairs of actors that worked together.
-- Technically I got all pairs BUT I haven't yet managed to get the names instead of the id
SELECT fa1.film_id, fa1.actor_id AS actor1, fa2.actor_id AS actor2
FROM sakila.film_actor fa1
JOIN sakila.film_actor fa2
ON (fa1.film_id = fa2.film_id) AND (fa1.actor_id <> fa2.actor_id)
WHERE fa1.actor_id > fa2.actor_id
ORDER BY fa1.film_id ASC;

-- Q8 Get all pairs of customers that have rented the same film more than 3 times.
-- Haven't yet figured out how to count the pairs :( 

SELECT r1.inventory_id, r1.customer_id AS cust1, r2.customer_id AS cust2
FROM sakila.rental r1
JOIN sakila.rental r2
ON (r1.inventory_id = r2.inventory_id) AND (r1.customer_id <> r2.customer_id)
WHERE r1.customer_id > r2.customer_id
ORDER BY r1.inventory_id ASC;

-- Q9 For each film, list actor that has acted in most films.