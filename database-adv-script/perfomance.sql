--  query that retrieves all bookings along with the user details, property details, and payment details
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
JOIN users u ON b.guest_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
JOIN payments pay ON b.booking_id = pay.booking_id
JOIN payment_method pm ON pay.method_id = pm.method_id;


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
FROM bookings AS b
INNER JOIN users AS u ON b.guest_id = u.user_id
INNER JOIN properties AS p ON b.property_id = p.property_id
INNER JOIN payments AS pay ON b.booking_id = pay.booking_id
INNER JOIN payment_method AS pm ON pay.method_id = pm.method_id
WHERE b.start_date >= '2024-01-01'; -- optional filtering for performance
