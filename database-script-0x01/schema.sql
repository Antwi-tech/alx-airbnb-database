CREATE DATABASE Airbnb;
USE Airbnb;

-- USERS TABLE
CREATE TABLE users (
    user_id CHAR(36) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ROLES TABLE
CREATE TABLE roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- USER_ROLE TABLE (Many-to-Many)
CREATE TABLE user_role (
    user_id CHAR(36),
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);

-- PROPERTIES TABLE
CREATE TABLE properties (
    property_id CHAR(36) PRIMARY KEY,
    host_id CHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    price_per_night DECIMAL(10, 2) NOT NULL CHECK (price_per_night >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_properties_host_id ON properties(host_id);

-- BOOKING_STATUS TABLE
CREATE TABLE booking_status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

-- BOOKINGS TABLE
CREATE TABLE bookings (
    booking_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    guest_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (guest_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES booking_status(status_id)
);

CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_status_id ON bookings(status_id);

-- MESSAGES TABLE
CREATE TABLE messages (
    message_id CHAR(36) PRIMARY KEY,
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);

-- REVIEWS TABLE
CREATE TABLE reviews (
    review_id CHAR(36) PRIMARY KEY,
    property_id CHAR(36) NOT NULL,
    reviewer_id CHAR(36) NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_reviews_reviewer_id ON reviews(reviewer_id);

-- PAYMENT_METHOD TABLE
CREATE TABLE payment_method (
    method_id INT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);

-- PAYMENTS TABLE
CREATE TABLE payments (
    payment_id CHAR(36) PRIMARY KEY,
    booking_id CHAR(36) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    method_id INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (method_id) REFERENCES payment_method(method_id)
);

CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payments_method_id ON payments(method_id);

-- DUMMY DATA
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number)
VALUES
  ('uuid-551', 'Alice', 'Smith', 'alice@gmail.com', '##4jw', '0554389234'),
  ('uuid-552', 'Steve', 'Johnson', 'stejohn@gmail.com', '33na', '0237965420'),
  ('uuid-553', 'Kathy', 'Agyeman', 'kagyeman@gmail.com', 'jsk', '0279722793');

INSERT INTO roles (role_id, role_name)
VALUES
  (1, 'Admin'),
  (2, 'Host'),
  (3, 'Guest');

INSERT INTO user_role (user_id, role_id)
VALUES
  ('uuid-551', 1),
  ('uuid-552', 2),
  ('uuid-553', 3);

INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
  ('uuid-441', 'uuid-551', 'Seaside Villa', 'A cozy beachfront villa.', 'Cape Coast', 150.00),
  ('uuid-442', 'uuid-552', 'City Apartment', 'Modern apartment in downtown.', 'Accra', 95.00);

INSERT INTO booking_status (status_id, status_name)
VALUES
  (1, 'Pending'),
  (2, 'Confirmed'),
  (3, 'Cancelled');

INSERT INTO bookings (booking_id, property_id, guest_id, start_date, end_date, status_id)
VALUES
  ('uuid-331', 'uuid-441', 'uuid-553', '2025-07-10', '2025-07-15', 2),
  ('uuid-332', 'uuid-442', 'uuid-553', '2025-08-01', '2025-08-05', 1);

INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
  ('uuid-message-1', 'uuid-553', 'uuid-552', 'Hi, is the villa available in July?'),
  ('uuid-message-2', 'uuid-552', 'uuid-553', 'Yes, it is available from July 10th.');

INSERT INTO reviews (review_id, property_id, reviewer_id, rating, comment)
VALUES
  ('uuid-review-1', 'uuid-441', 'uuid-553', 5, 'A`mazing stay! Very clean and peaceful.'),
  ('uuid-review-2', 'uuid-442', 'uuid-553', 4, 'Great location, a bit noisy though.');

INSERT INTO payment_method (method_id, method_name)
VALUES
  (1, 'Credit Card'),
  (2, 'Mobile Money'),
  (3, 'PayPal');

INSERT INTO payments (payment_id, booking_id, amount, method_id)
VALUES
  ('uuid-payment-1', 'uuid-331', 750.00, 1),
  ('uuid-payment-2', 'uuid-332', 380.00, 2);
