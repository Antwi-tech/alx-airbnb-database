--  Perform inner join on bookings and their respective user
SELECT  users.first_name, bookings.guest_id
FROM users
INNER JOIN bookings ON users.user_id = bookings.guest_id

-- Left join properties to reviews
SELECT reviews.reviewer_id, reviews.comment, properties.host_id, properties.name
FROM properties
LEFT JOIN  reviews ON properties.property_id = reviews.property_id
ORDER BY properties.name;


-- Full outer join does not work in mysql so unless you union both left and right join
SELECT users.*, bookings.*
FROM bookings
LEFT JOIN users ON users.user_id = bookings.guest_id

UNION

SELECT users.*, bookings.*
FROM users
RIGHT JOIN bookings ON users.user_id = bookings.guest_id

-- Postgresql for outer join 
SELECT users.*, bookings.*
FROM users
FULL OUTER JOIN bookings ON users.user_id = bookings.guest_id;

