-- Problem 9 solution:
WITH CategorySales AS (
  SELECT C.category_id, C.category_name, SUM(OI.unit_price * OI.quantity) AS total_sales
  FROM Categories C
  JOIN Products P ON C.category_id = P.category_id
  JOIN Order_Items OI ON P.product_id = OI.product_id
  GROUP BY C.category_id, C.category_name
)
SELECT category_id, category_name, total_sales
FROM CategorySales
ORDER BY total_sales DESC
LIMIT 3;

-- Problem 10 solution:
WITH ToysAndGamesProducts AS (
  SELECT P.product_id
  FROM Products P
  JOIN Categories C ON P.category_id = C.category_id
  WHERE C.category_name = 'Toys & Games'
),
UserOrders AS (
  SELECT U.user_id, U.username, OI.product_id
  FROM Users U
  JOIN Orders O ON U.user_id = O.user_id
  JOIN Order_Items OI ON O.order_id = OI.order_id
),
ToysAndGamesOrders AS (
  SELECT UO.user_id, UO.username
  FROM UserOrders UO
  WHERE UO.product_id IN (SELECT product_id FROM ToysAndGamesProducts)
  GROUP BY UO.user_id, UO.username
  HAVING COUNT(DISTINCT UO.product_id) = (SELECT COUNT(*) FROM ToysAndGamesProducts)
)
SELECT user_id, username
FROM ToysAndGamesOrders;

--Problem 11 solution:
WITH RankedProducts AS (
  SELECT P.product_id, P.product_name, P.category_id, P.price,
    ROW_NUMBER() OVER (PARTITION BY P.category_id ORDER BY P.price DESC) AS rank
  FROM Products P
)
SELECT product_id, product_name, category_id, price
FROM RankedProducts
WHERE rank = 1;

-- Problem 12 solution:
WITH OrderedDates AS (
  SELECT O.user_id, O.order_date,
    LAG(O.order_date, 1) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS previous_order_date,
    LEAD(O.order_date, 1) OVER (PARTITION BY O.user_id ORDER BY O.order_date) AS next_order_date
  FROM Orders O
),
ConsecutiveOrders AS (
  SELECT OD.user_id
  FROM OrderedDates OD
  WHERE OD.order_date = OD.previous_order_date + INTERVAL '1 day'
    AND OD.order_date = OD.next_order_date - INTERVAL '1 day'
  GROUP BY OD.user_id
  HAVING COUNT(*) >= 2
)
SELECT U.user_id, U.username
FROM Users U
WHERE U.user_id IN (SELECT user_id FROM ConsecutiveOrders);
