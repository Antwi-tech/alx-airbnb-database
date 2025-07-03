# 📊 SQL Query Performance Monitoring & Optimization Report
## ✅ Step 1: Monitor Performance


```sql
SET PROFILING = 1;

-- Run the query
SELECT *
FROM bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';

-- View profiling results
SHOW PROFILES;
SHOW PROFILE FOR QUERY 1;
For MySQL 8.0+:


EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';
```

## 🔍 Step 2: Identify Bottlenecks
Finding:
- Full table scan on bookings
- rows examined: ~1,000,000
- No indexes or partitioning used
- Slow query time (~320ms)

📌 Issue: No optimization for start_date filtering

## 🔧 Step 3: Optimization
✅ Option 1: Add Index
```sql
CREATE INDEX idx_bookings_start_date ON bookings(start_date);

Use RANGE partitioning based on the year of start_date.

Example:

sql
Copy
Edit
CREATE TABLE bookings (
    booking_id CHAR(36) NOT NULL,
    property_id CHAR(36) NOT NULL,
    guest_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date),
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE,
    FOREIGN KEY (guest_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES booking_status(status_id)
)
PARTITION BY RANGE (YEAR(start_date)) (
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p2025 VALUES LESS THAN (2026),
    PARTITION pmax  VALUES LESS THAN MAXVALUE
);
```

## 🔁 Step 4: Re-Test
After applying indexing or partitioning, re-run:

```sql

EXPLAIN ANALYZE
SELECT *
FROM bookings
WHERE start_date BETWEEN '2024-01-01' AND '2024-01-31';
Expected Improvements:
type: range scan
```

Partition pruning (if partitioned)

## 📬 Notes
- Use EXPLAIN ANALYZE regularly to assess query plans.
- Indexes and partitions drastically improve performance for large, date-based datasets.
- For even better results, consider composite indexes if filtering by multiple fields (e.g., (guest_id, start_date)).