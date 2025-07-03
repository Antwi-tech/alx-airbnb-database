# 🧠 SQL Query Optimization Report

## ✅ Objective

To optimize a multi-table join query that retrieves detailed booking information from the following tables:

- `bookings`
- `users`
- `properties`
- `payments`
- `payment_method`

The goal is to reduce query execution time by eliminating inefficiencies and ensuring index usage.

---

## 🗃️ Original Query

```sql
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
```

### ⚠️ Performance Issues Identified

- Full table scans were observed during `EXPLAIN` analysis.
- Lack of specific filtering caused excessive row retrieval.
- Potential for unnecessary columns being retrieved (`SELECT *` in some versions).
- Not all joined columns had supporting indexes.

---

## 🛠️ Optimization Strategy

### 1. Use Indexes on Join Columns

Created or verified the following indexes:

```sql
-- BOOKINGS
CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_start_date ON bookings(start_date);  -- if using WHERE filter

-- PAYMENTS
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payments_method_id ON payments(method_id);
```

### 2. Refactor Query for Clarity and Efficiency

```sql
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
WHERE b.start_date >= '2024-01-01'; -- Optional filter to improve performance
```

---

## 📊 Performance Comparison (EXPLAIN)

| Metric               | Before Optimization | After Optimization |
| -------------------- | ------------------- | ------------------ |
| Join Strategy        | Full Table Scan     | Index Lookup       |
| Estimated Row Count  | High                | Reduced            |
| Query Execution Time | Slower              | Improved           |
| Index Usage          | Partial             | Full               |

> **Note:** Actual performance gain may vary based on data size. Use `EXPLAIN ANALYZE` or DBeaver’s execution plan visualizer to verify improvements.

---

## 💾 Conclusion

The optimized query:

- Uses targeted `SELECT` fields instead of `SELECT *`
- Is supported by proper indexes on join keys
- Uses clear and consistent syntax
- Includes optional filtering to reduce scanned rows

These optimizations ensure better performance, especially on larger datasets.

---

## 🔍 Recommendation

- Regularly monitor slow queries with `EXPLAIN` or `ANALYZE`.
- Avoid unnecessary joins or SELECT wildcards in production queries.
- Continuously update and maintain indexes as data grows.

