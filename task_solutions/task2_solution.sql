-- Problem 5 solution:
WITH AverageRatings AS (
  SELECT product_id, AVG(rating) AS avg_rating
  FROM Reviews
  GROUP BY product_id
),
MaxRating AS (
  SELECT MAX(avg_rating) AS max_avg_rating
  FROM AverageRatings
)
SELECT P.product_id, P.product_name, AR.avg_rating
FROM Products P
JOIN AverageRatings AR ON P.product_id = AR.product_id
JOIN MaxRating MR ON AR.avg_rating = MR.max_avg_rating;

--Problem 6 solution:
WITH UserCategoryOrders AS (
  SELECT U.user_id, C.category_id
  FROM Users U
  JOIN Orders O ON U.user_id = O.user_id
  JOIN Order_Items OI ON O.order_id = OI.order_id
  JOIN Products P ON OI.product_id = P.product_id
  JOIN Categories C ON P.category_id = C.category_id
  GROUP BY U.user_id, C.category_id
),
CategoryCount AS (
  SELECT COUNT(*) AS total_categories
  FROM Categories
)
SELECT UCO.user_id, U.username
FROM UserCategoryOrders UCO
JOIN Users U ON UCO.user_id = U.user_id
GROUP BY UCO.user_id, U.username
HAVING COUNT(DISTINCT UCO.category_id) = (SELECT total_categories FROM CategoryCount);

-- Problem 7 solution:
SELECT P.product_id, P.product_name
FROM Products P
LEFT JOIN Reviews R ON P.product_id = R.product_id
WHERE R.review_id IS NULL;

-- Problem 8 solution:
WITH ConsecutiveOrders AS (
  SELECT O.user_id, O.order_date,
    LAG(O.order_date) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS previous_order_date
  FROM Orders O
)
SELECT U.user_id, U.username
FROM Users U
WHERE U.user_id IN (
  SELECT CO.user_id
  FROM ConsecutiveOrders CO
  WHERE CO.order_date = CO.previous_order_date + INTERVAL '1 day'
);
