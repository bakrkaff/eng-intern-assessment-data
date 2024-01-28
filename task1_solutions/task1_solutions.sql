-- Problem 1 solution:
SELECT P.product_id, P.product_name, P.description, P.price
FROM Products P
JOIN Categories C ON P.category_id = C.category_id
WHERE C.category_name = 'Sports';

-- Problem 2 solution:
SELECT U.user_id, U.username, COUNT(O.order_id) AS total_orders
FROM Users U
LEFT JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username;

-- Problem 3 solution:
SELECT P.product_id, P.product_name, AVG(R.rating) AS average_rating
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
GROUP BY P.product_id, P.product_name;

-- Problem 4 solution:
SELECT U.user_id, U.username, SUM(O.total_amount) AS total_spent
FROM Users U
JOIN Orders O ON U.user_id = O.user_id
GROUP BY U.user_id, U.username
ORDER BY total_spent DESC
LIMIT 5;
