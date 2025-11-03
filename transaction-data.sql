WITH gross_laba AS (
  SELECT
    product_id, 
    CASE 
      WHEN price <= 50000 THEN 0.1
      WHEN price BETWEEN 50001 AND 100000 THEN 0.15
      WHEN price BETWEEN 100001 AND 300000 THEN 0.2
      WHEN price BETWEEN 300001 AND 500000 THEN 0.25
      WHEN price > 500000 THEN 0.3
    END AS persentase_gross_laba
  FROM main.kf_product 
)

SELECT
  ft.transaction_id,
  ft.date,
  ft.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  ft.customer_name,
  ft.product_id,
  p.product_name,
  p.price AS actual_price,
  ft.discount_percentage,
  gl.persentase_gross_laba,
  p.price * (1-ft.discount_percentage) AS nett_sales,
  p.price * (1-ft.discount_percentage) * gl.persentase_gross_laba AS nett_profit,
  ft.rating AS rating_transaksi
FROM main.kf_final_transaction ft
LEFT JOIN main.kf_kantor_cabang kc ON ft.branch_id = kc.branch_id
LEFT JOIN main.kf_product p ON ft.product_id = p.product_id
LEFT JOIN gross_laba gl ON ft.product_id = gl.product_id