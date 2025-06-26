# 🏠 Airbnb Database Schema

This project defines a relational database schema for a simplified version of **Airbnb**, enabling the management of users, properties, bookings, payments, messaging, and reviews. The schema supports core functionalities such as hosting, guest bookings, user communication, and payments.

---

## 📦 Database Setup

To initialize the database:

```sql
CREATE DATABASE Airbnb;
USE Airbnb;
```

Then execute the SQL schema provided in `schema.sql` to create all necessary tables and indexes.

---

## 🧱 Schema Overview

### 👤 USERS

```sql
CREATE TABLE users (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    phone_number VARCHAR(20) UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### 🔐 ROLES & USER_ROLE

```sql
CREATE TABLE roles (
    role_id INT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE user_role (
    user_id UUID,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE
);
```

### 🏘️ PROPERTIES

```sql
CREATE TABLE properties (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255),
    price_per_night DECIMAL(10, 2) NOT NULL CHECK (price_per_night >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (host_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_properties_host_id ON properties(host_id);
```

### 📆 BOOKING STATUS

```sql
CREATE TABLE booking_status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);
```

### 📅 BOOKINGS

```sql
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    guest_id UUID NOT NULL,
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
```

### 💬 MESSAGES

```sql
CREATE TABLE messages (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);
```

### 🌟 REVIEWS

```sql
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    reviewer_id UUID NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_reviews_reviewer_id ON reviews(reviewer_id);
```

### 💳 PAYMENT METHOD & PAYMENTS

```sql
CREATE TABLE payment_method (
    method_id INT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE payments (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
    payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    method_id INT NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (method_id) REFERENCES payment_method(method_id)
);

CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payments_method_id ON payments(method_id);
```

---

## 🧪 Sample Data Insertion

### 👤 Users

```sql
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number)
VALUES 
('11111111-1111-1111-1111-111111111111', 'Alice', 'Johnson', 'alice@example.com', 'hashed_pw_1', '+233501234567'),
('22222222-2222-2222-2222-222222222222', 'Bob', 'Smith', 'bob@example.com', 'hashed_pw_2', '+233541234567'),
('33333333-3333-3333-3333-333333333333', 'Clara', 'Mensah', 'clara@example.com', 'hashed_pw_3', '+233591234567');
```

### 🔐 Roles

```sql
INSERT INTO roles (role_id, role_name)
VALUES 
(1, 'host'),
(2, 'guest');
```

### 🔗 User-Role Assignment

```sql
INSERT INTO user_role (user_id, role_id)
VALUES
('11111111-1111-1111-1111-111111111111', 2),
('22222222-2222-2222-2222-222222222222', 2),
('33333333-3333-3333-3333-333333333333', 1);
```

### 🏘️ Properties

```sql
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '33333333-3333-3333-3333-333333333333', 'Ocean View Apartment', 'A beautiful seaside apartment with 2 bedrooms.', 'Accra, Ghana', 250.00),
('aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '33333333-3333-3333-3333-333333333333', 'Garden Cottage', 'Cozy cottage surrounded by lush gardens.', 'Kumasi, Ghana', 180.00);
```

### 📆 Booking Statuses

```sql
INSERT INTO booking_status (status_id, status_name)
VALUES
(1, 'Pending'),
(2, 'Confirmed'),
(3, 'Cancelled');
```

### 📅 Bookings

```sql
INSERT INTO bookings (booking_id, property_id, guest_id, start_date, end_date, status_id)
VALUES
('bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '11111111-1111-1111-1111-111111111111', '2025-07-01', '2025-07-05', 2),
('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '22222222-2222-2222-2222-222222222222', '2025-07-10', '2025-07-15', 1);
```

### 💬 Messages

```sql
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
('msg1-msg1-msg1-msg1-msg1msg1msg11', '11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', 'Hi Clara, is the Ocean View Apartment available for next weekend?'),
('msg2-msg2-msg2-msg2-msg2msg2msg22', '33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', 'Yes Alice, it is available from July 1 to July 5.');
```

### 🌟 Reviews

```sql
INSERT INTO reviews (review_id, property_id, reviewer_id, rating, comment)
VALUES
('rev1-rev1-rev1-rev1-rev1rev1rev11', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaa1', '11111111-1111-1111-1111-111111111111', 5, 'Amazing view, clean space, and friendly host!'),
('rev2-rev2-rev2-rev2-rev2rev2rev22', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaa2', '22222222-2222-2222-2222-222222222222', 4, 'Very cozy and peaceful. Will return!');
```

### 💳 Payment Methods

```sql
INSERT INTO payment_method (method_id, method_name)
VALUES
(1, 'Credit Card'),
(2, 'Mobile Money');
```

### 💰 Payments

```sql
INSERT INTO payments (payment_id, booking_id, amount, method_id)
VALUES
('pay1-pay1-pay1-pay1-pay1pay1pay11', 'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbb1', 1000.00, 1),
('pay2-pay2-pay2-pay2-pay2pay2pay22', 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbb2', 900.00, 2);
```

---

## 🛠️ Technologies

- SQL (Standard)
- Compatible with MySQL and PostgreSQL
- Uses UUIDs for primary keys
- Uses indexes for performance

---

## 📄 License

This project is licensed under the **MIT License**.

---

## ✍️ Author

Created by **[Your Name]**

GitHub: [@yourusername](https://github.com/yourusername)