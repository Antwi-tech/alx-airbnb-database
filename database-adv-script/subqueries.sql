-- Finding all properties where the average rating is greater than 4.0 using a subquery.

SELECT *
FROM properties
WHERE property_id IN (
    SELECT property_id
    FROM reviews 
    GROUP BY property_id
    HAVING AVG(rating) > 4.0
)

--  A subquery to find users who have made more than 3 bookings.

SELECT * 
FROM users 
WHERE users.user_id IN (
    SELECT guest_id
    FROM bookings 
    GROUP BY guest_id
    HAVING COUNT(*) > 3 
)