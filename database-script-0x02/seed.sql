-- USERS
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number)
VALUES 
('11111111-1111-1111-1111-111111111111', 'Alice', 'Johnson', 'alice@example.com', 'hashed_pw_1', '+233501234567'),
('22222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hashed_pw_2', '+233541234567'),
('33333333-3333-3333-3333-333333333333', 'Clara', 'Mensah', 'clara@example.com', 'hashed_pw_3', '+233591234567');

-- ROLES
INSERT INTO roles (role_id, role_name)
VALUES 
(1, 'host'),
(2, 'guest');

-- USER_ROLE
INSERT INTO user_role (user_id, role_id)
VALUES
('11111111-1111-1111-1111-111111111111', 2),  -- Alice is guest
('22222222-2222-2222-2222-222222222222', 2),  -- Bob is guest
('33333333-3333-3333-3333-333333333333', 1);  -- Clara is host

-- PROPERTIES
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '33333333-3333-3333-3333-333333333333', 'Ocean View Apartment', 'A beautiful seaside apartment with 2 bedrooms.', 'Accra, Ghana', 250.00),
('aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '33333333-3333-3333-3333-333333333333', 'Garden Cottage', 'Cozy cottage surrounded by lush gardens.', 'Kumasi, Ghana', 180.00);

-- BOOKING_STATUS
INSERT INTO booking_status (status_id, status_name)
VALUES
(1, 'Pending'),
(2, 'Confirmed'),
(3, 'Cancelled');

-- BOOKINGS
INSERT INTO bookings (booking_id, property_id, guest_id, start_date, end_date, status_id)
VALUES
('bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '11111111-1111-1111-1111-111111111111', '2025-07-01', '2025-07-05', 2),
('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '22222222-2222-2222-2222-222222222222', '2025-07-10', '2025-07-15', 1);

-- MESSAGES
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
('msg1-msg1-msg1-msg1-msg1msg1msg11', '11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', 'Hi Clara, is the Ocean View Apartment available for next weekend?'),
('msg2-msg2-msg2-msg2-msg2msg2msg22', '33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Yes Alice, it is available from July 1 to July 5.');

-- REVIEWS
INSERT INTO reviews (review_id, property_id, reviewer_id, rating, comment)
VALUES
('rev1-rev1-rev1-rev1-rev1rev1rev11', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '11111111-1111-1111-1111-111111111111', 5, 'Amazing view, clean space, and friendly host!'),
('rev2-rev2-rev2-rev2-rev2rev2rev22', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '22222222-2222-2222-2222-222222222222', 4, 'Very cozy and peaceful. Will return!');

-- PAYMENT_METHOD
INSERT INTO payment_method (method_id, method_name)
VALUES
(1, 'Credit Card'),
(2, 'Mobile Money');

-- PAYMENTS
INSERT INTO payments (payment_id, booking_id, amount, method_id)
VALUES
('pay1-pay1-pay1-pay1-pay1pay1pay11', 'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 1000.00, 1),
('pay2-pay2-pay2-pay2-pay2pay2pay22', 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 900.00, 2);
