-- Nomor 1
-- Q: Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi
-- (after_discount) paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail

SELECT*FROM order_detail


SELECT
	TO_CHAR(order_date, 'Month') AS month,
	SUM(after_discount) AS total_sales
FROM
	order_detail
WHERE
	is_valid=1 AND
	EXTRACT(YEAR FROM order_date)=2021
GROUP BY 1
ORDER BY 2 DESC


-- Nomor 2
-- Q: Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling
-- besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail, sku_detail

SELECT*FROM order_detail
SELECT*FROM sku_detail


WITH order_sku_detail AS
(
SELECT*FROM 
  order_detail AS o
FULL JOIN 
  sku_detail AS s
ON 
  o.sku_id=s.id
)

SELECT
	category,
	SUM(after_discount) AS total_sales
FROM
	order_sku_detail
WHERE
	is_valid=1 AND
	EXTRACT(YEAR FROM order_date)=2022
GROUP BY 1
ORDER BY 2 DESC



-- Nomor 3
-- Q: Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022.
-- Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami
-- penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter data
-- transaksi.
-- Source table: order_detail, sku_detail

SELECT*FROM order_detail
SELECT*FROM sku_detail


WITH order_sku_detail AS(
	SELECT*FROM 
  		order_detail AS o
	FULL JOIN 
  		sku_detail AS s
	ON 
  		o.sku_id=s.id ),

category_transaction_2022 AS(
	SELECT
		category,
		SUM(after_discount) AS transaction_2022
	FROM
		order_sku_detail
	WHERE
		is_valid=1 AND
		EXTRACT(YEAR FROM order_date)=2022
	GROUP BY 1
	),

category_transaction_2021 AS(	
	SELECT
		category,
		SUM(after_discount) AS transaction_2021
	FROM
		order_sku_detail
	WHERE
		is_valid=1 AND
		EXTRACT(YEAR FROM order_date)=2021
	GROUP BY 1
	)
	
SELECT
	ct2022.category,
	ct2022.transaction_2022,
	ct2021.transaction_2021,
	ct2022.transaction_2022-ct2021.transaction_2021 AS growth
FROM 
	category_transaction_2022 AS ct2022
FULL JOIN 
  category_transaction_2021 AS ct2021
ON 
  ct2022.category=ct2021.category
ORDER BY 4 DESC




-- Nomor 4
-- Q: Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022
-- (berdasarkan total unique order). Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail, payment_detail

SELECT*FROM order_detail
SELECT*FROM payment_detail


SELECT 
	pd.payment_method,
	COUNT(DISTINCT od.id)
FROM 	
	order_detail AS od
FULL JOIN
	payment_detail AS pd
ON
	od.payment_id=pd.id
WHERE od.is_valid=1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Nomor 5
-- Q: Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.
-- 1. Samsung
-- 2. Apple
-- 3. Sony
-- 4. Huawei
-- 5. Lenovo
-- Gunakan is_valid = 1 untuk memfilter data transaksi.
-- Source table: order_detail, sku_detail


SELECT*FROM order_detail
SELECT*FROM sku_detail


WITH order_sku_detail AS(
	SELECT *
	FROM
		order_detail AS od
	FULL JOIN
		sku_detail AS sd
	ON
		od.sku_id=sd.id)

SELECT 
	'Samsung' AS brand, 
	SUM(after_discount) AS total_sales
FROM 
	order_sku_detail
WHERE 
	LOWER(sku_name) LIKE '%samsung%' AND 
	is_valid=1
UNION
SELECT 
	'Apple' AS brand, 
	SUM(after_discount) AS total_sales
FROM 
	order_sku_detail
WHERE 
	LOWER(sku_name) LIKE '%apple%' OR 
	LOWER(sku_name) LIKE '%iphone%' OR
	LOWER(sku_name) LIKE '%mac%' AND
	is_valid=1
UNION
SELECT 
	'Sony' AS brand, 
	SUM(after_discount) AS total_sales
FROM order_sku_detail
WHERE 
	LOWER(sku_name) LIKE '%sony%' AND 
	is_valid=1
UNION
SELECT 
	'Huawei' AS brand, 
	SUM(after_discount) AS total_sales
FROM 
	order_sku_detail
WHERE 
	LOWER(sku_name) LIKE '%huawei%' AND 
	is_valid=1
UNION
SELECT 
	'Lenovo' AS brand, 
	SUM(after_discount) AS total_sales
FROM 
	order_sku_detail
WHERE 
	LOWER(sku_name) LIKE '%lenovo%' AND 
	is_valid=1

ORDER BY total_sales DESC


SELECT*FROM order_detail
SELECT*FROM sku_detail
SELECT*FROM customer_detail
SELECT*FROM payment_detail

SELECT 
	od.id,
	od.customer_id,
	od.order_date,
	od.sku_id,
	od.price,
	od.qty_ordered,
	od.before_discount,
	od.discount_amount,
	od.after_discount,
	od.is_gross,
	od.is_valid,
	od.is_net,
	od.payment_id,
	sd.sku_name,
	sd.base_price,
	sd.cogs,
	sd.category,
	cd.registered_date,
	pd.payment_method
FROM
	order_detail AS od
FULL JOIN
	sku_detail AS sd
ON
	od.sku_id=sd.id
FULL JOIN
	customer_detail AS cd
ON
	od.customer_id=cd.id
FULL JOIN
	payment_detail AS pd
ON
	od.payment_id=pd.id



