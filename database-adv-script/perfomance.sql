--  query that retrieves all bookings along with the user details, property details, and payment details
EXPLAIN
SELECT 
  b.booking_id,
  b.start_date,
  b.end_date,
  u.first_name,
  u.last_name,
  u.email,
  p.name AS property_name,
  p.location,
  pay.amount,
  pay.payment_date,
  pm.method_name
FROM bookings b
JOIN users u 
  ON b.guest_id = u.user_id
JOIN properties p 
  ON b.property_id = p.property_id
    AND p.price_per_night > 0 -- 🟢 This is where we add an AND condition
JOIN payments pay 
  ON b.booking_id = pay.booking_id
JOIN payment_method pm 
  ON pay.method_id = pm.method_id
WHERE b.start_date >= '2024-01-01';



--  Refactored 
SELECT 
  b.booking_id,
  b.start_date,
  b.end_date,
  u.first_name,
  u.last_name,
  u.email,
  p.name AS property_name,
  p.location,
  pay.amount,
  pay.payment_date,
  pm.method_name
FROM bookings b
INNER JOIN users u 
  ON b.guest_id = u.user_id
INNER JOIN properties p 
  ON b.property_id = p.property_id
INNER JOIN payments pay 
  ON b.booking_id = pay.booking_id
INNER JOIN payment_method pm 
  ON pay.method_id = pm.method_id
WHERE 
  b.start_date >= '2024-01-01'
  AND p.price_per_night > 0;  -- ✅ Moved to WHERE clause
