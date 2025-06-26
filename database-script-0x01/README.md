# 🏠 Airbnb Database Schema

This project defines a relational database schema for a simplified version of **Airbnb**, enabling the management of users, properties, bookings, payments, messaging, and reviews. The schema supports core functionalities such as hosting, guest bookings, user communication, and payments.

## 📦 Database Setup

To initialize the database:

```sql
CREATE DATABASE Airbnb;
USE Airbnb;
```

## 🧱 Schema Overview
🧑 Users
Stores user information (both guests and hosts).

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

## 🔐 Roles & User Roles (Many-to-Many)
Allows assigning roles like "guest", "host", or "admin".

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

## 🏘️ Properties
Contains listings hosted by users.

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


## 📆 Booking Status
Defines the status of a booking (e.g., pending, confirmed, cancelled).

```sql
CREATE TABLE booking_status (
  status_id INT PRIMARY KEY,
  status_name VARCHAR(50) NOT NULL UNIQUE
);
```

## 📅 Bookings
Tracks when a guest books a property.

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

## 💬 Messages
Enables communication between users (e.g., guest and host).

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

## 🌟 Reviews
Allows guests to leave reviews for properties.

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
## 💳 Payments
Handles payment records for bookings.

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


## Features Supported
1. User registration and roles
2. Hosting and listing of properties
3. Property booking with status tracking
4. Secure password storage via hashing
5. Messaging between guests and hosts
6. Payment processing and review system

## Technologies Used
- SQL (Standard SQL/DDL)
- Compatible with MySQL or PostgreSQL (with small tweaks)
- Uses UUID for global unique identifiers

