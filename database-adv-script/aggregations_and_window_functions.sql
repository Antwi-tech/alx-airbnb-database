--  finding the total number of bookings made by each user, using the COUNT function and GROUP BY clause.
SELECT guest_id, COUNT(*) AS total_bookings
FROM bookings
GROUP BY guest_id


--  Use a window function (ROW_NUMBER, RANK) to rank properties based on the total number of 
--  bookings they have received.

SELECT 
  p.property_id,
  p.name,
  COUNT(b.booking_id) AS total_bookings,
  RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name;

-- use of row number
SELECT 
  property_id,
  name,
  total_bookings,
  ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS booking_rank
FROM (
  SELECT 
    p.property_id,
    p.name,
    COUNT(b.booking_id) AS total_bookings
  FROM properties p
  LEFT JOIN bookings b ON p.property_id = b.property_id
  GROUP BY p.property_id, p.name
) AS booking_summary;
