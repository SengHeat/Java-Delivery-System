-- ============================================
-- DELIVERY SYSTEM DATABASE SCHEMA (PostgreSQL)
-- ============================================

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS audit_logs CASCADE;
DROP TABLE IF EXISTS support_tickets CASCADE;
DROP TABLE IF EXISTS promocode_usage CASCADE;
DROP TABLE IF EXISTS promocodes CASCADE;
DROP TABLE IF EXISTS webhook_deliveries CASCADE;
DROP TABLE IF EXISTS webhooks CASCADE;
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS token_usage_logs CASCADE;
DROP TABLE IF EXISTS token_permissions CASCADE;
DROP TABLE IF EXISTS personal_access_tokens CASCADE;
DROP TABLE IF EXISTS notification_preferences CASCADE;
DROP TABLE IF EXISTS notifications CASCADE;
DROP TABLE IF EXISTS payment_methods CASCADE;
DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS delivery_tracking CASCADE;
DROP TABLE IF EXISTS delivery_routes CASCADE;
DROP TABLE IF EXISTS deliveries CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS drivers CASCADE;
DROP TABLE IF EXISTS addresses CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(20) NOT NULL CHECK (role IN ('CUSTOMER', 'DRIVER', 'ADMIN', 'SUPPORT')),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_password_token VARCHAR(255),
    reset_password_expires_at TIMESTAMP,
    last_login_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_phone ON users(phone_number);

-- Insert 5 sample users
INSERT INTO users (email, password_hash, phone_number, role, is_active, is_verified, last_login_at, created_at, updated_at) VALUES
('john.doe@email.com', '$2a$10$rQ3K5Z9h8Y7k6X4w2s1p3eO8Y7k6X4w2s1p3eO8Y7k6X4w2s1p3e', '+1234567890', 'CUSTOMER', TRUE, TRUE, '2024-10-30 10:30:00', '2024-01-15 08:00:00', '2024-10-30 10:30:00'),
('jane.smith@email.com', '$2a$10$sR4L6A0i9Z8m7Y5x3t2q4fP9Z8m7Y5x3t2q4fP9Z8m7Y5x3t2q4f', '+1234567891', 'CUSTOMER', TRUE, TRUE, '2024-10-29 15:45:00', '2024-02-20 09:30:00', '2024-10-29 15:45:00'),
('mike.driver@email.com', '$2a$10$tS5M7B1j0A9n8Z6y4u3r5gQ0A9n8Z6y4u3r5gQ0A9n8Z6y4u3r5g', '+1234567892', 'DRIVER', TRUE, TRUE, '2024-10-31 07:00:00', '2024-03-10 11:00:00', '2024-10-31 07:00:00'),
('sarah.driver@email.com', '$2a$10$uT6N8C2k1B0o9A7z5v4s6hR1B0o9A7z5v4s6hR1B0o9A7z5v4s6h', '+1234567893', 'DRIVER', TRUE, TRUE, '2024-10-31 06:30:00', '2024-03-15 10:00:00', '2024-10-31 06:30:00'),
('admin@delivery.com', '$2a$10$vU7O9D3l2C1p0B8a6w5t7iS2C1p0B8a6w5t7iS2C1p0B8a6w5t7i', '+1234567894', 'ADMIN', TRUE, TRUE, '2024-10-31 08:00:00', '2024-01-01 00:00:00', '2024-10-31 08:00:00');

-- ============================================
-- 2. CUSTOMERS TABLE
-- ============================================
CREATE TABLE customers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    profile_image_url VARCHAR(500),
    preferred_language VARCHAR(10) DEFAULT 'en',
    loyalty_points INT DEFAULT 0,
    total_orders INT DEFAULT 0,
    total_spent DECIMAL(12, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_customers_user_id ON customers(user_id);

-- Insert 5 sample customers
INSERT INTO customers (user_id, first_name, last_name, date_of_birth, profile_image_url, preferred_language, loyalty_points, total_orders, total_spent, created_at, updated_at) VALUES
(1, 'John', 'Doe', '1990-05-15', 'https://cdn.example.com/profiles/john_doe.jpg', 'en', 150, 12, 1250.50, '2024-01-15 08:00:00', '2024-10-30 10:30:00'),
(2, 'Jane', 'Smith', '1988-08-22', 'https://cdn.example.com/profiles/jane_smith.jpg', 'en', 320, 25, 2875.75, '2024-02-20 09:30:00', '2024-10-29 15:45:00');

-- ============================================
-- 3. ADDRESSES TABLE
-- ============================================
CREATE TABLE addresses (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    address_type VARCHAR(20) NOT NULL CHECK (address_type IN ('HOME', 'WORK', 'OTHER')),
    street_address VARCHAR(255) NOT NULL,
    apartment_number VARCHAR(50),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_default BOOLEAN DEFAULT FALSE,
    delivery_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE INDEX idx_addresses_customer_id ON addresses(customer_id);
CREATE INDEX idx_addresses_location ON addresses(latitude, longitude);

-- Insert 5 sample addresses
INSERT INTO addresses (customer_id, address_type, street_address, apartment_number, city, state, postal_code, country, latitude, longitude, is_default, delivery_instructions, created_at, updated_at) VALUES
(1, 'HOME', '123 Main Street', 'Apt 4B', 'New York', 'NY', '10001', 'USA', 40.7589, -73.9851, TRUE, 'Ring doorbell twice', '2024-01-15 08:30:00', '2024-01-15 08:30:00'),
(1, 'WORK', '456 Corporate Blvd', 'Suite 1200', 'New York', 'NY', '10022', 'USA', 40.7614, -73.9776, FALSE, 'Leave at reception', '2024-02-10 10:00:00', '2024-02-10 10:00:00'),
(2, 'HOME', '789 Oak Avenue', NULL, 'Brooklyn', 'NY', '11201', 'USA', 40.6974, -73.9796, TRUE, 'Call on arrival', '2024-02-20 09:45:00', '2024-02-20 09:45:00'),
(2, 'WORK', '321 Business Park', 'Floor 3', 'Manhattan', 'NY', '10018', 'USA', 40.7549, -73.9840, FALSE, 'Security check required', '2024-03-05 14:20:00', '2024-03-05 14:20:00'),
(1, 'OTHER', '555 Friend Street', 'Apt 7', 'Queens', 'NY', '11354', 'USA', 40.7699, -73.8299, FALSE, 'Gift delivery - be discreet', '2024-05-12 16:30:00', '2024-05-12 16:30:00');

-- ============================================
-- 4. DRIVERS TABLE
-- ============================================
CREATE TABLE drivers (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    driver_license_number VARCHAR(50) UNIQUE NOT NULL,
    license_expiry_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'OFFLINE' CHECK (status IN ('AVAILABLE', 'BUSY', 'OFFLINE', 'ON_BREAK')),
    current_latitude DECIMAL(10, 8),
    current_longitude DECIMAL(11, 8),
    average_rating DECIMAL(3, 2) DEFAULT 0.00,
    total_deliveries INT DEFAULT 0,
    total_ratings INT DEFAULT 0,
    background_check_status VARCHAR(20) DEFAULT 'PENDING' CHECK (background_check_status IN ('PENDING', 'APPROVED', 'REJECTED')),
    background_check_date DATE,
    date_of_birth DATE NOT NULL,
    profile_image_url VARCHAR(500),
    emergency_contact_name VARCHAR(200),
    emergency_contact_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_drivers_user_id ON drivers(user_id);
CREATE INDEX idx_drivers_status ON drivers(status);
CREATE INDEX idx_drivers_location ON drivers(current_latitude, current_longitude);
CREATE INDEX idx_drivers_rating ON drivers(average_rating);

-- Insert 5 sample drivers
INSERT INTO drivers (user_id, first_name, last_name, driver_license_number, license_expiry_date, status, current_latitude, current_longitude, average_rating, total_deliveries, total_ratings, background_check_status, background_check_date, date_of_birth, profile_image_url, emergency_contact_name, emergency_contact_phone, created_at, updated_at) VALUES
(3, 'Mike', 'Johnson', 'DL123456789', '2026-12-31', 'AVAILABLE', 40.7580, -73.9855, 4.85, 342, 298, 'APPROVED', '2024-03-08', '1985-07-12', 'https://cdn.example.com/drivers/mike_johnson.jpg', 'Sarah Johnson', '+1234567800', '2024-03-10 11:00:00', '2024-10-31 07:00:00'),
(4, 'Sarah', 'Williams', 'DL987654321', '2027-06-30', 'BUSY', 40.7489, -73.9680, 4.92, 456, 421, 'APPROVED', '2024-03-12', '1990-03-25', 'https://cdn.example.com/drivers/sarah_williams.jpg', 'Tom Williams', '+1234567801', '2024-03-15 10:00:00', '2024-10-31 06:30:00');

-- ============================================
-- 5. VEHICLES TABLE
-- ============================================
CREATE TABLE vehicles (
    id BIGSERIAL PRIMARY KEY,
    driver_id BIGINT NOT NULL,
    vehicle_type VARCHAR(20) NOT NULL CHECK (vehicle_type IN ('BIKE', 'SCOOTER', 'CAR', 'VAN', 'TRUCK')),
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    color VARCHAR(30),
    license_plate VARCHAR(20) UNIQUE NOT NULL,
    vin VARCHAR(50),
    insurance_policy_number VARCHAR(100),
    insurance_expiry_date DATE NOT NULL,
    registration_expiry_date DATE NOT NULL,
    max_capacity_kg DECIMAL(8, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

CREATE INDEX idx_vehicles_driver_id ON vehicles(driver_id);
CREATE INDEX idx_vehicles_license_plate ON vehicles(license_plate);
CREATE INDEX idx_vehicles_vehicle_type ON vehicles(vehicle_type);

-- Insert 5 sample vehicles
INSERT INTO vehicles (driver_id, vehicle_type, make, model, year, color, license_plate, vin, insurance_policy_number, insurance_expiry_date, registration_expiry_date, max_capacity_kg, is_active, created_at, updated_at) VALUES
(1, 'SCOOTER', 'Honda', 'PCX160', 2023, 'Red', 'NYC-SC-1234', '1HGBH41JXMN109186', 'INS-2024-001234', '2025-03-31', '2025-03-31', 50.00, TRUE, '2024-03-10 12:00:00', '2024-03-10 12:00:00'),
(2, 'CAR', 'Toyota', 'Camry', 2022, 'Silver', 'NYC-CR-5678', '4T1BF1FK5CU123456', 'INS-2024-005678', '2025-06-30', '2025-06-30', 200.00, TRUE, '2024-03-15 11:00:00', '2024-03-15 11:00:00'),
(1, 'BIKE', 'Yamaha', 'MT-07', 2021, 'Blue', 'NYC-BK-9012', 'JYARN23E0LA012345', 'INS-2023-009012', '2025-01-15', '2025-01-15', 30.00, FALSE, '2024-03-10 12:30:00', '2024-08-20 09:00:00'),
(2, 'VAN', 'Ford', 'Transit', 2023, 'White', 'NYC-VN-3456', '1FTBW2CM5HKA12345', 'INS-2024-003456', '2025-12-31', '2025-12-31', 500.00, TRUE, '2024-04-01 10:00:00', '2024-04-01 10:00:00'),
(1, 'SCOOTER', 'Vespa', 'Primavera', 2024, 'Green', 'NYC-SC-7890', 'ZAPM68300P1234567', 'INS-2024-007890', '2026-01-31', '2026-01-31', 45.00, TRUE, '2024-09-15 14:00:00', '2024-09-15 14:00:00');

-- ============================================
-- 6. ORDERS TABLE
-- ============================================
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id BIGINT NOT NULL,
    status VARCHAR(30) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'CONFIRMED', 'PREPARING', 'READY_FOR_PICKUP', 'ASSIGNED', 'IN_TRANSIT', 'DELIVERED', 'CANCELLED', 'FAILED')),
    subtotal DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(12, 2) DEFAULT 0.00,
    delivery_fee DECIMAL(12, 2) DEFAULT 0.00,
    discount_amount DECIMAL(12, 2) DEFAULT 0.00,
    tip_amount DECIMAL(12, 2) DEFAULT 0.00,
    total_amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'WALLET', 'UPI')),
    special_instructions TEXT,
    estimated_delivery_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    cancellation_reason TEXT,
    cancelled_by VARCHAR(20) CHECK (cancelled_by IN ('CUSTOMER', 'DRIVER', 'ADMIN', 'SYSTEM')),
    cancelled_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Insert 5 sample orders
INSERT INTO orders (order_number, customer_id, status, subtotal, tax_amount, delivery_fee, discount_amount, tip_amount, total_amount, currency, payment_method, special_instructions, estimated_delivery_time, actual_delivery_time, created_at, updated_at) VALUES
('ORD-2024-001', 1, 'DELIVERED', 45.99, 4.14, 5.00, 0.00, 5.00, 60.13, 'USD', 'CREDIT_CARD', 'Please ring doorbell', '2024-10-25 19:30:00', '2024-10-25 19:25:00', '2024-10-25 18:00:00', '2024-10-25 19:25:00'),
('ORD-2024-002', 2, 'DELIVERED', 78.50, 7.07, 5.00, 10.00, 8.00, 88.57, 'USD', 'CREDIT_CARD', 'Leave at door', '2024-10-26 20:00:00', '2024-10-26 19:55:00', '2024-10-26 18:30:00', '2024-10-26 19:55:00'),
('ORD-2024-003', 1, 'IN_TRANSIT', 34.25, 3.08, 5.00, 5.00, 3.00, 40.33, 'USD', 'WALLET', 'Call before delivery', '2024-10-31 12:30:00', NULL, '2024-10-31 11:00:00', '2024-10-31 11:45:00'),
('ORD-2024-004', 2, 'CONFIRMED', 125.00, 11.25, 7.50, 15.00, 0.00, 128.75, 'USD', 'CREDIT_CARD', 'Fragile items', '2024-10-31 15:00:00', NULL, '2024-10-31 13:00:00', '2024-10-31 13:05:00'),
('ORD-2024-005', 1, 'CANCELLED', 25.99, 2.34, 5.00, 0.00, 0.00, 33.33, 'USD', 'CASH', NULL, '2024-10-30 14:00:00', NULL, '2024-10-30 12:30:00', '2024-10-30 12:45:00');

-- ============================================
-- 7. MERCHANTS TABLE
-- ============================================
CREATE TABLE merchants (
    id BIGSERIAL PRIMARY KEY,
    merchant_name VARCHAR(255) NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    merchant_type VARCHAR(50) NOT NULL CHECK (merchant_type IN ('RESTAURANT', 'GROCERY', 'PHARMACY', 'RETAIL', 'BAKERY', 'CAFE', 'OTHER')),
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED', 'PENDING_APPROVAL')),
    tax_id VARCHAR(50),
    business_license VARCHAR(100),
    logo_url VARCHAR(500),
    banner_url VARCHAR(500),
    description TEXT,
    opening_time TIME,
    closing_time TIME,
    average_prep_time_minutes INT DEFAULT 30,
    minimum_order_amount DECIMAL(12, 2) DEFAULT 0.00,
    delivery_radius_km DECIMAL(8, 2) DEFAULT 5.00,
    commission_rate DECIMAL(5, 2) DEFAULT 15.00,
    rating_average DECIMAL(3, 2) DEFAULT 0.00,
    total_reviews INT DEFAULT 0,
    total_orders INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_merchants_status ON merchants(status);
CREATE INDEX idx_merchants_merchant_type ON merchants(merchant_type);
CREATE INDEX idx_merchants_rating ON merchants(rating_average);
CREATE INDEX idx_merchants_is_featured ON merchants(is_featured);

-- Insert 5 sample merchants
INSERT INTO merchants (merchant_name, business_name, email, phone_number, merchant_type, status, tax_id, business_license, logo_url, banner_url, description, opening_time, closing_time, average_prep_time_minutes, minimum_order_amount, delivery_radius_km, commission_rate, rating_average, total_reviews, total_orders, is_featured, created_at, updated_at) VALUES
('Pizza Palace', 'Pizza Palace Inc.', 'contact@pizzapalace.com', '+1234567700', 'RESTAURANT', 'ACTIVE', 'TAX-123456', 'BL-2024-001', 'https://cdn.example.com/merchants/pizza-palace-logo.jpg', 'https://cdn.example.com/merchants/pizza-palace-banner.jpg', 'Best Italian pizza in town! Fresh ingredients, authentic recipes.', '10:00:00', '23:00:00', 25, 15.00, 8.00, 15.00, 4.7, 342, 1250, TRUE, '2024-01-05 09:00:00', '2024-10-31 08:00:00'),
('Sushi Haven', 'Sushi Haven LLC', 'hello@sushihaven.com', '+1234567701', 'RESTAURANT', 'ACTIVE', 'TAX-789012', 'BL-2024-002', 'https://cdn.example.com/merchants/sushi-haven-logo.jpg', 'https://cdn.example.com/merchants/sushi-haven-banner.jpg', 'Premium Japanese cuisine with the freshest fish daily.', '11:00:00', '22:00:00', 30, 20.00, 10.00, 18.00, 4.9, 521, 2150, TRUE, '2024-01-10 10:00:00', '2024-10-31 08:00:00'),
('Fresh Mart Grocery', 'Fresh Mart Corporation', 'info@freshmart.com', '+1234567702', 'GROCERY', 'ACTIVE', 'TAX-345678', 'BL-2024-003', 'https://cdn.example.com/merchants/fresh-mart-logo.jpg', 'https://cdn.example.com/merchants/fresh-mart-banner.jpg', 'Your neighborhood grocery store with delivery service.', '07:00:00', '22:00:00', 20, 25.00, 15.00, 12.00, 4.5, 218, 890, FALSE, '2024-02-01 08:00:00', '2024-10-31 08:00:00'),
('HealthPlus Pharmacy', 'HealthPlus Pharmacy Inc.', 'support@healthplus.com', '+1234567703', 'PHARMACY', 'ACTIVE', 'TAX-901234', 'BL-2024-004', 'https://cdn.example.com/merchants/healthplus-logo.jpg', 'https://cdn.example.com/merchants/healthplus-banner.jpg', 'Your trusted pharmacy for prescriptions and health products.', '08:00:00', '20:00:00', 15, 10.00, 12.00, 10.00, 4.8, 456, 1820, TRUE, '2024-01-15 09:00:00', '2024-10-31 08:00:00'),
('Sweet Treats Bakery', 'Sweet Treats LLC', 'orders@sweettreats.com', '+1234567704', 'BAKERY', 'ACTIVE', 'TAX-567890', 'BL-2024-005', 'https://cdn.example.com/merchants/sweet-treats-logo.jpg', 'https://cdn.example.com/merchants/sweet-treats-banner.jpg', 'Artisan baked goods and custom cakes made fresh daily.', '06:00:00', '18:00:00', 35, 12.00, 7.00, 15.00, 4.6, 189, 750, FALSE, '2024-02-15 07:00:00', '2024-10-31 08:00:00');

-- ============================================
-- 8. MERCHANT_ADDRESSES TABLE
-- ============================================
CREATE TABLE merchant_addresses (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT NOT NULL,
    address_type VARCHAR(20) NOT NULL CHECK (address_type IN ('BUSINESS', 'WAREHOUSE', 'KITCHEN', 'PICKUP')),
    street_address VARCHAR(255) NOT NULL,
    apartment_number VARCHAR(50),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_primary BOOLEAN DEFAULT FALSE,
    pickup_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE
);

CREATE INDEX idx_merchant_addresses_merchant_id ON merchant_addresses(merchant_id);
CREATE INDEX idx_merchant_addresses_location ON merchant_addresses(latitude, longitude);

-- Insert 5 sample merchant addresses
INSERT INTO merchant_addresses (merchant_id, address_type, street_address, apartment_number, city, state, postal_code, country, latitude, longitude, is_primary, pickup_instructions, created_at, updated_at) VALUES
(1, 'BUSINESS', '456 Corporate Blvd', 'Suite 100', 'New York', 'NY', '10022', 'USA', 40.7614, -73.9776, TRUE, 'Use main entrance, pickup counter on the right', '2024-01-05 09:00:00', '2024-01-05 09:00:00'),
(2, 'BUSINESS', '321 Business Park', 'Floor 1', 'Manhattan', 'NY', '10018', 'USA', 40.7549, -73.9840, TRUE, 'Enter through front door, pickup area at the counter', '2024-01-10 10:00:00', '2024-01-10 10:00:00'),
(3, 'BUSINESS', '789 Market Street', NULL, 'Brooklyn', 'NY', '11201', 'USA', 40.6974, -73.9796, TRUE, 'Side entrance for pickup orders', '2024-02-01 08:00:00', '2024-02-01 08:00:00'),
(4, 'BUSINESS', '123 Health Avenue', NULL, 'Queens', 'NY', '11354', 'USA', 40.7699, -73.8299, TRUE, 'Pickup window available at the pharmacy counter', '2024-01-15 09:00:00', '2024-01-15 09:00:00'),
(5, 'BUSINESS', '555 Baker Street', 'Shop 5', 'Manhattan', 'NY', '10019', 'USA', 40.7635, -73.9845, TRUE, 'Ring bell for pickup orders', '2024-02-15 07:00:00', '2024-02-15 07:00:00');

-- ============================================
-- 9. CATEGORIES TABLE
-- ============================================
CREATE TABLE categories (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    icon_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE
);

CREATE INDEX idx_categories_merchant_id ON categories(merchant_id);
CREATE INDEX idx_categories_is_active ON categories(is_active);

-- Insert 5 sample categories
INSERT INTO categories (merchant_id, category_name, description, display_order, is_active, icon_url, created_at, updated_at) VALUES
(1, 'Pizzas', 'Hand-tossed pizzas with fresh toppings', 1, TRUE, 'https://cdn.example.com/icons/pizza.png', '2024-01-05 09:30:00', '2024-01-05 09:30:00'),
(1, 'Salads', 'Fresh garden salads', 2, TRUE, 'https://cdn.example.com/icons/salad.png', '2024-01-05 09:30:00', '2024-01-05 09:30:00'),
(1, 'Beverages', 'Soft drinks and juices', 3, TRUE, 'https://cdn.example.com/icons/drinks.png', '2024-01-05 09:30:00', '2024-01-05 09:30:00'),
(2, 'Sushi Rolls', 'Traditional and specialty rolls', 1, TRUE, 'https://cdn.example.com/icons/sushi.png', '2024-01-10 10:30:00', '2024-01-10 10:30:00'),
(2, 'Soups', 'Hot Japanese soups', 2, TRUE, 'https://cdn.example.com/icons/soup.png', '2024-01-10 10:30:00', '2024-01-10 10:30:00');

-- ============================================
-- 10. PRODUCTS TABLE
-- ============================================
CREATE TABLE products (
    id BIGSERIAL PRIMARY KEY,
    merchant_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    sku VARCHAR(100) UNIQUE NOT NULL,
    barcode VARCHAR(100),
    price DECIMAL(12, 2) NOT NULL,
    compare_at_price DECIMAL(12, 2),
    cost_price DECIMAL(12, 2),
    currency VARCHAR(3) DEFAULT 'USD',
    stock_quantity INT DEFAULT 0,
    low_stock_threshold INT DEFAULT 10,
    is_available BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    weight_kg DECIMAL(8, 2),
    dimensions_cm VARCHAR(50),
    image_url VARCHAR(500),
    additional_images JSONB,
    tags JSONB,
    nutritional_info JSONB,
    allergen_info JSONB,
    preparation_time_minutes INT DEFAULT 15,
    serving_size VARCHAR(50),
    calories INT,
    is_vegetarian BOOLEAN DEFAULT FALSE,
    is_vegan BOOLEAN DEFAULT FALSE,
    is_gluten_free BOOLEAN DEFAULT FALSE,
    spice_level VARCHAR(20) CHECK (spice_level IN ('NONE', 'MILD', 'MEDIUM', 'HOT', 'EXTRA_HOT')),
    total_sold INT DEFAULT 0,
    view_count INT DEFAULT 0,
    rating_average DECIMAL(3, 2) DEFAULT 0.00,
    review_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE INDEX idx_products_merchant_id ON products(merchant_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_is_available ON products(is_available);
CREATE INDEX idx_products_is_featured ON products(is_featured);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_rating ON products(rating_average);

-- Insert 5 sample products
INSERT INTO products (merchant_id, category_id, product_name, description, sku, barcode, price, compare_at_price, cost_price, stock_quantity, low_stock_threshold, is_available, is_featured, weight_kg, dimensions_cm, image_url, additional_images, tags, nutritional_info, allergen_info, preparation_time_minutes, serving_size, calories, is_vegetarian, is_vegan, is_gluten_free, spice_level, total_sold, view_count, rating_average, review_count, created_at, updated_at) VALUES
(1, 1, 'Margherita Pizza Large', 'Classic Italian pizza with fresh mozzarella, tomato sauce, and basil', 'PIZZA-MAR-L', '1234567890123', 15.99, 18.99, 7.50, 50, 10, TRUE, TRUE, 1.20, '35x35x5', 'https://cdn.example.com/products/margherita-pizza.jpg', '["https://cdn.example.com/products/margherita-pizza-2.jpg", "https://cdn.example.com/products/margherita-pizza-3.jpg"]', '["pizza", "italian", "vegetarian"]', '{"protein": "15g", "carbs": "45g", "fat": "12g", "fiber": "3g"}', '["gluten", "dairy"]', 25, '1 large pizza (12 inches)', 850, TRUE, FALSE, FALSE, 'NONE', 1250, 5420, 4.7, 342, '2024-01-05 10:00:00', '2024-10-31 08:00:00'),
(1, 2, 'Caesar Salad', 'Fresh romaine lettuce with Caesar dressing, parmesan, and croutons', 'SALAD-CSR', '1234567890124', 12.00, NULL, 5.00, 100, 20, TRUE, FALSE, 0.50, '20x20x10', 'https://cdn.example.com/products/caesar-salad.jpg', '["https://cdn.example.com/products/caesar-salad-2.jpg"]', '["salad", "healthy"]', '{"protein": "8g", "carbs": "12g", "fat": "18g", "fiber": "4g"}', '["gluten", "dairy", "eggs"]', 10, '1 bowl', 320, TRUE, FALSE, FALSE, 'NONE', 890, 2340, 4.5, 178, '2024-01-05 10:00:00', '2024-10-31 08:00:00'),
(1, 3, 'Coca Cola 1L', 'Classic Coca Cola soft drink', 'DRINK-COKE-1L', '1234567890125', 3.00, NULL, 1.50, 200, 30, TRUE, FALSE, 1.00, '10x10x25', 'https://cdn.example.com/products/coca-cola.jpg', NULL, '["beverage", "soft drink"]', '{"sugar": "108g", "caffeine": "34mg"}', NULL, 0, '1 liter', 420, TRUE, TRUE, TRUE, 'NONE', 3200, 8900, 4.8, 456, '2024-01-05 10:00:00', '2024-10-31 08:00:00'),
(2, 4, 'Sushi Combo Deluxe', 'Premium sushi platter with 16 pieces including salmon, tuna, and eel', 'SUSHI-COMBO-DLX', '1234567890126', 35.00, 42.00, 18.00, 30, 5, TRUE, TRUE, 0.80, '30x15x8', 'https://cdn.example.com/products/sushi-deluxe.jpg', '["https://cdn.example.com/products/sushi-deluxe-2.jpg", "https://cdn.example.com/products/sushi-deluxe-3.jpg"]', '["sushi", "japanese", "seafood", "premium"]', '{"protein": "35g", "carbs": "65g", "fat": "8g", "omega3": "2.5g"}', '["fish", "shellfish", "soy"]', 30, '16 pieces', 680, FALSE, FALSE, TRUE, 'NONE', 2150, 9870, 4.9, 521, '2024-01-10 10:30:00', '2024-10-31 08:00:00'),
(2, 5, 'Miso Soup', 'Traditional Japanese soup with tofu, seaweed, and green onions', 'SOUP-MISO', '1234567890127', 4.25, NULL, 1.80, 150, 25, TRUE, FALSE, 0.40, '12x12x15', 'https://cdn.example.com/products/miso-soup.jpg', NULL, '["soup", "japanese", "vegetarian"]', '{"protein": "5g", "carbs": "8g", "fat": "2g", "sodium": "920mg"}', '["soy"]', 10, '1 bowl', 85, TRUE, TRUE, TRUE, 'NONE', 1890, 4560, 4.7, 298, '2024-01-10 10:30:00', '2024-10-31 08:00:00');

-- ============================================
-- 11. PRODUCT_VARIANTS TABLE
-- ============================================
CREATE TABLE product_variants (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    variant_name VARCHAR(100) NOT NULL,
    sku VARCHAR(100) UNIQUE NOT NULL,
    price_adjustment DECIMAL(12, 2) DEFAULT 0.00,
    stock_quantity INT DEFAULT 0,
    is_available BOOLEAN DEFAULT TRUE,
    attributes JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

CREATE INDEX idx_product_variants_product_id ON product_variants(product_id);
CREATE INDEX idx_product_variants_sku ON product_variants(sku);

-- Insert 5 sample product variants
INSERT INTO product_variants (product_id, variant_name, sku, price_adjustment, stock_quantity, is_available, attributes, created_at, updated_at) VALUES
(1, 'Medium Size', 'PIZZA-MAR-M', -3.00, 60, TRUE, '{"size": "medium", "diameter": "10 inches"}', '2024-01-05 10:30:00', '2024-10-31 08:00:00'),
(1, 'Extra Large Size', 'PIZZA-MAR-XL', 4.00, 40, TRUE, '{"size": "extra large", "diameter": "16 inches"}', '2024-01-05 10:30:00', '2024-10-31 08:00:00'),
(1, 'Large with Extra Cheese', 'PIZZA-MAR-L-EC', 2.50, 35, TRUE, '{"size": "large", "extra": "cheese"}', '2024-01-05 10:30:00', '2024-10-31 08:00:00'),
(3, 'Coca Cola 2L', 'DRINK-COKE-2L', 1.50, 150, TRUE, '{"volume": "2 liters"}', '2024-01-05 10:30:00', '2024-10-31 08:00:00'),
(3, 'Coca Cola 500ml', 'DRINK-COKE-500ML', -1.00, 250, TRUE, '{"volume": "500ml"}', '2024-01-05 10:30:00', '2024-10-31 08:00:00');

-- ============================================
-- 12. PRODUCT_REVIEWS TABLE
-- ============================================
CREATE TABLE product_reviews (
    id BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    rating DECIMAL(2, 1) NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
    review_title VARCHAR(255),
    review_text TEXT,
    images JSONB,
    is_verified_purchase BOOLEAN DEFAULT TRUE,
    helpful_count INT DEFAULT 0,
    is_flagged BOOLEAN DEFAULT FALSE,
    merchant_response TEXT,
    responded_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
);

CREATE INDEX idx_product_reviews_product_id ON product_reviews(product_id);
CREATE INDEX idx_product_reviews_customer_id ON product_reviews(customer_id);
CREATE INDEX idx_product_reviews_rating ON product_reviews(rating);

-- Insert 5 sample product reviews
INSERT INTO product_reviews (product_id, customer_id, order_id, rating, review_title, review_text, images, is_verified_purchase, helpful_count, merchant_response, responded_at, created_at, updated_at) VALUES
(1, 1, 1, 5.0, 'Best pizza ever!', 'The Margherita pizza was absolutely delicious! Fresh ingredients and perfect crust. Will order again!', '["https://cdn.example.com/reviews/pizza-review-1.jpg"]', TRUE, 8, 'Thank you so much for your kind words! We are glad you enjoyed our pizza!', '2024-10-26 09:00:00', '2024-10-25 20:30:00', '2024-10-26 09:00:00'),
(2, 1, 1, 4.5, 'Fresh and tasty', 'Really enjoyed the Caesar salad. Dressing was perfect and lettuce was crispy.', NULL, TRUE, 3, NULL, NULL, '2024-10-25 20:35:00', '2024-10-25 20:35:00'),
(3, 2, 2, 5.0, 'Always refreshing', 'Good packaging, delivered cold as expected.', NULL, TRUE, 1, NULL, NULL, '2024-10-26 21:00:00', '2024-10-26 21:00:00'),
(4, 2, 2, 5.0, 'Absolutely amazing!', 'The fish was incredibly fresh! Best sushi I have had in NYC. The presentation was beautiful too.', '["https://cdn.example.com/reviews/sushi-review-1.jpg", "https://cdn.example.com/reviews/sushi-review-2.jpg"]', TRUE, 12, 'We appreciate your wonderful review! Our chefs take great pride in using only the freshest ingredients.', '2024-10-27 10:00:00', '2024-10-26 21:15:00', '2024-10-27 10:00:00'),
(5, 2, 2, 4.5, 'Authentic taste', 'Loved the authentic miso flavor. Could use a bit more tofu though.', NULL, TRUE, 4, 'Thank you for the feedback! We will consider adding more tofu to our miso soup.', '2024-10-27 10:30:00', '2024-10-26 21:20:00', '2024-10-27 10:30:00');

-- ============================================
-- UPDATE ORDER_ITEMS TABLE TO REFERENCE PRODUCTS
-- ============================================
DROP TABLE IF EXISTS order_items CASCADE;

CREATE TABLE order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    product_variant_id BIGINT,
    product_name VARCHAR(255) NOT NULL,
    product_sku VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    weight_kg DECIMAL(8, 2),
    dimensions_cm VARCHAR(50),
    special_instructions TEXT,
    customizations JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    FOREIGN KEY (product_variant_id) REFERENCES product_variants(id) ON DELETE SET NULL
);

CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Insert 5 sample order items with product references
INSERT INTO order_items (order_id, product_id, product_variant_id, product_name, product_sku, quantity, unit_price, total_price, weight_kg, dimensions_cm, special_instructions, customizations, created_at) VALUES
(1, 1, NULL, 'Margherita Pizza Large', 'PIZZA-MAR-L', 1, 15.99, 15.99, 1.20, '35x35x5', 'Extra crispy', '{"crust": "thin", "extra": "crispy"}', '2024-10-25 18:00:00'),
(1, 2, NULL, 'Caesar Salad', 'SALAD-CSR', 1, 12.00, 12.00, 0.50, '20x20x10', 'Dressing on the side', '{"dressing": "on_side"}', '2024-10-25 18:00:00'),
(1, 3, NULL, 'Coca Cola 1L', 'DRINK-COKE-1L', 2, 3.00, 6.00, 1.00, '10x10x25', NULL, NULL, '2024-10-25 18:00:00'),
(2, 4, NULL, 'Sushi Combo Deluxe', 'SUSHI-COMBO-DLX', 2, 35.00, 70.00, 0.80, '30x15x8', 'No wasabi please', '{"wasabi": "none"}', '2024-10-26 18:30:00'),
(2, 5, NULL, 'Miso Soup', 'SOUP-MISO', 2, 4.25, 8.50, 0.40, '12x12x15', 'Extra hot', '{"temperature": "extra_hot"}', '2024-10-26 18:30:00');

-- ============================================
-- 8. DELIVERIES TABLE
-- ============================================
CREATE TABLE deliveries (
    id BIGSERIAL PRIMARY KEY,
    delivery_number VARCHAR(50) UNIQUE NOT NULL,
    order_id BIGINT UNIQUE NOT NULL,
    driver_id BIGINT,
    status VARCHAR(30) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'ASSIGNED', 'ACCEPTED', 'PICKED_UP', 'IN_TRANSIT', 'ARRIVED', 'DELIVERED', 'FAILED', 'CANCELLED')),
    pickup_address_id BIGINT NOT NULL,
    delivery_address_id BIGINT NOT NULL,
    pickup_latitude DECIMAL(10, 8),
    pickup_longitude DECIMAL(11, 8),
    delivery_latitude DECIMAL(10, 8),
    delivery_longitude DECIMAL(11, 8),
    estimated_distance_km DECIMAL(8, 2),
    actual_distance_km DECIMAL(8, 2),
    estimated_duration_minutes INT,
    actual_duration_minutes INT,
    scheduled_pickup_time TIMESTAMP,
    actual_pickup_time TIMESTAMP,
    scheduled_delivery_time TIMESTAMP,
    actual_delivery_time TIMESTAMP,
    priority VARCHAR(20) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    delivery_fee DECIMAL(12, 2),
    driver_earnings DECIMAL(12, 2),
    proof_of_delivery_type VARCHAR(20) CHECK (proof_of_delivery_type IN ('SIGNATURE', 'PHOTO', 'OTP', 'CONTACTLESS')),
    proof_of_delivery_url VARCHAR(500),
    signature_data TEXT,
    otp_code VARCHAR(10),
    recipient_name VARCHAR(200),
    failure_reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE SET NULL,
    FOREIGN KEY (pickup_address_id) REFERENCES addresses(id),
    FOREIGN KEY (delivery_address_id) REFERENCES addresses(id)
);

CREATE INDEX idx_deliveries_order_id ON deliveries(order_id);
CREATE INDEX idx_deliveries_driver_id ON deliveries(driver_id);
CREATE INDEX idx_deliveries_status ON deliveries(status);
CREATE INDEX idx_deliveries_delivery_number ON deliveries(delivery_number);

-- Insert 5 sample deliveries
INSERT INTO deliveries (delivery_number, order_id, driver_id, status, pickup_address_id, delivery_address_id, pickup_latitude, pickup_longitude, delivery_latitude, delivery_longitude, estimated_distance_km, actual_distance_km, estimated_duration_minutes, actual_duration_minutes, scheduled_pickup_time, actual_pickup_time, scheduled_delivery_time, actual_delivery_time, priority, delivery_fee, driver_earnings, proof_of_delivery_type, proof_of_delivery_url, recipient_name, created_at, updated_at) VALUES
('DEL-2024-001', 1, 1, 'DELIVERED', 2, 1, 40.7614, -73.9776, 40.7589, -73.9851, 2.30, 2.45, 15, 13, '2024-10-25 19:00:00', '2024-10-25 18:58:00', '2024-10-25 19:30:00', '2024-10-25 19:25:00', 'NORMAL', 5.00, 3.75, 'OTP', 'https://cdn.example.com/pod/del-001.jpg', 'John Doe', '2024-10-25 18:00:00', '2024-10-25 19:25:00'),
('DEL-2024-002', 2, 2, 'DELIVERED', 4, 3, 40.7549, -73.9840, 40.6974, -73.9796, 7.80, 8.10, 25, 27, '2024-10-26 19:15:00', '2024-10-26 19:12:00', '2024-10-26 20:00:00', '2024-10-26 19:55:00', 'NORMAL', 5.00, 3.75, 'PHOTO', 'https://cdn.example.com/pod/del-002.jpg', 'Jane Smith', '2024-10-26 18:30:00', '2024-10-26 19:55:00'),
('DEL-2024-003', 3, 1, 'IN_TRANSIT', 2, 1, 40.7614, -73.9776, 40.7589, -73.9851, 2.30, NULL, 15, NULL, '2024-10-31 11:45:00', '2024-10-31 11:42:00', '2024-10-31 12:30:00', NULL, 'NORMAL', 5.00, 3.75, NULL, NULL, NULL, '2024-10-31 11:00:00', '2024-10-31 11:45:00'),
('DEL-2024-004', 4, NULL, 'PENDING', 4, 3, 40.7549, -73.9840, 40.6974, -73.9796, 7.80, NULL, 30, NULL, '2024-10-31 14:00:00', NULL, '2024-10-31 15:00:00', NULL, 'HIGH', 7.50, 5.63, NULL, NULL, NULL, '2024-10-31 13:00:00', '2024-10-31 13:05:00'),
('DEL-2024-005', 5, 1, 'CANCELLED', 2, 5, 40.7614, -73.9776, 40.7699, -73.8299, 12.50, NULL, 35, NULL, '2024-10-30 13:00:00', NULL, '2024-10-30 14:00:00', NULL, 'NORMAL', 5.00, 3.75, NULL, NULL, NULL, '2024-10-30 12:30:00', '2024-10-30 12:45:00');

-- ============================================
-- 9. DELIVERY_ROUTES TABLE
-- ============================================
CREATE TABLE delivery_routes (
    id BIGSERIAL PRIMARY KEY,
    delivery_id BIGINT UNIQUE NOT NULL,
    route_data JSONB,
    waypoints JSONB,
    optimized_route JSONB,
    total_distance_km DECIMAL(8, 2),
    estimated_time_minutes INT,
    traffic_factor DECIMAL(3, 2) DEFAULT 1.00,
    weather_conditions VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE CASCADE
);

CREATE INDEX idx_delivery_routes_delivery_id ON delivery_routes(delivery_id);

-- Insert 5 sample delivery routes
INSERT INTO delivery_routes (delivery_id, route_data, waypoints, optimized_route, total_distance_km, estimated_time_minutes, traffic_factor, weather_conditions, created_at, updated_at) VALUES
(1, '{"path": [{"lat": 40.7614, "lng": -73.9776}, {"lat": 40.7589, "lng": -73.9851}]}', '[{"order": 1, "lat": 40.7614, "lng": -73.9776, "type": "pickup"}, {"order": 2, "lat": 40.7589, "lng": -73.9851, "type": "dropoff"}]', '{"optimized_path": [{"lat": 40.7614, "lng": -73.9776}, {"lat": 40.7589, "lng": -73.9851}], "savings_km": 0.15}', 2.30, 15, 1.10, 'Clear', '2024-10-25 18:00:00', '2024-10-25 18:00:00'),
(2, '{"path": [{"lat": 40.7549, "lng": -73.9840}, {"lat": 40.6974, "lng": -73.9796}]}', '[{"order": 1, "lat": 40.7549, "lng": -73.9840, "type": "pickup"}, {"order": 2, "lat": 40.6974, "lng": -73.9796, "type": "dropoff"}]', '{"optimized_path": [{"lat": 40.7549, "lng": -73.9840}, {"lat": 40.6974, "lng": -73.9796}], "savings_km": 0.30}', 7.80, 25, 1.25, 'Light Rain', '2024-10-26 18:30:00', '2024-10-26 18:30:00'),
(3, '{"path": [{"lat": 40.7614, "lng": -73.9776}, {"lat": 40.7589, "lng": -73.9851}]}', '[{"order": 1, "lat": 40.7614, "lng": -73.9776, "type": "pickup"}, {"order": 2, "lat": 40.7589, "lng": -73.9851, "type": "dropoff"}]', '{"optimized_path": [{"lat": 40.7614, "lng": -73.9776}, {"lat": 40.7589, "lng": -73.9851}], "savings_km": 0.10}', 2.30, 15, 1.05, 'Clear', '2024-10-31 11:00:00', '2024-10-31 11:00:00'),
(4, '{"path": [{"lat": 40.7549, "lng": -73.9840}, {"lat": 40.6974, "lng": -73.9796}]}', '[{"order": 1, "lat": 40.7549, "lng": -73.9840, "type": "pickup"}, {"order": 2, "lat": 40.6974, "lng": -73.9796, "type": "dropoff"}]', '{"optimized_path": [{"lat": 40.7549, "lng": -73.9840}, {"lat": 40.6974, "lng": -73.9796}], "savings_km": 0.25}', 7.80, 30, 1.15, 'Cloudy', '2024-10-31 13:00:00', '2024-10-31 13:05:00'),
(5, '{"path": [{"lat": 40.7614, "lng": -73.9776}, {"lat": 40.7699, "lng": -73.8299}]}', '[{"order": 1, "lat": 40.7614, "lng": -73.9776, "type": "pickup"}, {"order": 2, "lat": 40.7699, "lng": -73.8299, "type": "dropoff"}]', '{"optimized_path": [{"lat": 40.7614, "lng": -73.9776}, {"lat": 40.7699, "lng": -73.8299}], "savings_km": 0.50}', 12.50, 35, 1.20, 'Clear', '2024-10-30 12:30:00', '2024-10-30 12:30:00');

-- ============================================
-- 10. DELIVERY_TRACKING TABLE
-- ============================================
CREATE TABLE delivery_tracking (
    id BIGSERIAL PRIMARY KEY,
    delivery_id BIGINT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    accuracy_meters DECIMAL(8, 2),
    speed_kmh DECIMAL(8, 2),
    bearing_degrees DECIMAL(5, 2),
    battery_level INT,
    status VARCHAR(50),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE CASCADE
);

CREATE INDEX idx_delivery_tracking_delivery_id ON delivery_tracking(delivery_id);
CREATE INDEX idx_delivery_tracking_recorded_at ON delivery_tracking(recorded_at);

-- Insert 5 sample delivery tracking records
INSERT INTO delivery_tracking (delivery_id, latitude, longitude, accuracy_meters, speed_kmh, bearing_degrees, battery_level, status, recorded_at) VALUES
(1, 40.7614, -73.9776, 5.00, 0.00, 0.00, 95, 'PICKUP', '2024-10-25 18:58:00'),
(1, 40.7602, -73.9810, 4.50, 25.00, 135.50, 94, 'IN_TRANSIT', '2024-10-25 19:05:00'),
(1, 40.7589, -73.9851, 5.20, 0.00, 0.00, 93, 'DELIVERED', '2024-10-25 19:25:00'),
(2, 40.7549, -73.9840, 4.80, 0.00, 0.00, 88, 'PICKUP', '2024-10-26 19:12:00'),
(2, 40.7250, -73.9820, 5.10, 30.00, 180.25, 85, 'IN_TRANSIT', '2024-10-26 19:35:00');

-- ============================================
-- 11. PAYMENTS TABLE
-- ============================================
CREATE TABLE payments (
    id BIGSERIAL PRIMARY KEY,
    payment_number VARCHAR(50) UNIQUE NOT NULL,
    order_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'WALLET', 'UPI', 'NET_BANKING')),
    payment_gateway VARCHAR(50),
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED')),
    gateway_transaction_id VARCHAR(255),
    gateway_response JSONB,
    failure_reason TEXT,
    refund_amount DECIMAL(12, 2),
    refund_reason TEXT,
    refunded_at TIMESTAMP,
    paid_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_customer_id ON payments(customer_id);
CREATE INDEX idx_payments_payment_number ON payments(payment_number);
CREATE INDEX idx_payments_status ON payments(status);

-- Insert 5 sample payments
INSERT INTO payments (payment_number, order_id, customer_id, payment_method, payment_gateway, amount, currency, status, gateway_transaction_id, gateway_response, paid_at, created_at, updated_at) VALUES
('PAY-2024-001', 1, 1, 'CREDIT_CARD', 'Stripe', 60.13, 'USD', 'COMPLETED', 'ch_3QKj5xD2fGy8h9kL0z1m2n3o', '{"card_brand": "Visa", "last4": "4242", "status": "succeeded"}', '2024-10-25 18:02:00', '2024-10-25 18:00:00', '2024-10-25 18:02:00'),
('PAY-2024-002', 2, 2, 'CREDIT_CARD', 'Stripe', 88.57, 'USD', 'COMPLETED', 'ch_3QKj6yE3gHz9i0mM1a2b3c4d', '{"card_brand": "Mastercard", "last4": "5555", "status": "succeeded"}', '2024-10-26 18:32:00', '2024-10-26 18:30:00', '2024-10-26 18:32:00'),
('PAY-2024-003', 3, 1, 'WALLET', 'PayPal', 40.33, 'USD', 'COMPLETED', 'PAYID-MXYZ123ABC456DEF789', '{"wallet_type": "PayPal", "email": "john.doe@email.com", "status": "COMPLETED"}', '2024-10-31 11:01:00', '2024-10-31 11:00:00', '2024-10-31 11:01:00'),
('PAY-2024-004', 4, 2, 'CREDIT_CARD', 'Stripe', 128.75, 'USD', 'COMPLETED', 'ch_3QKj7zF4hIa0j1nN2b3c4d5e', '{"card_brand": "Visa", "last4": "1234", "status": "succeeded"}', '2024-10-31 13:02:00', '2024-10-31 13:00:00', '2024-10-31 13:02:00'),
('PAY-2024-005', 5, 1, 'CASH', NULL, 33.33, 'USD', 'CANCELLED', NULL, NULL, NULL, '2024-10-30 12:30:00', '2024-10-30 12:45:00');

-- ============================================
-- 12. PAYMENT_TRANSACTIONS TABLE
-- ============================================
CREATE TABLE payment_transactions (
    id BIGSERIAL PRIMARY KEY,
    payment_id BIGINT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('CHARGE', 'REFUND', 'CHARGEBACK', 'REVERSAL')),
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    gateway_reference VARCHAR(255),
    status VARCHAR(20) NOT NULL CHECK (status IN ('SUCCESS', 'FAILED', 'PENDING')),
    error_code VARCHAR(50),
    error_message TEXT,
    metadata JSONB,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE
);

CREATE INDEX idx_payment_transactions_payment_id ON payment_transactions(payment_id);
CREATE INDEX idx_payment_transactions_type ON payment_transactions(transaction_type);

-- Insert 5 sample payment transactions
INSERT INTO payment_transactions (payment_id, transaction_type, amount, currency, gateway_reference, status, metadata, processed_at) VALUES
(1, 'CHARGE', 60.13, 'USD', 'txn_3QKj5xD2fGy8h9kL0z1m2n3o', 'SUCCESS', '{"fee": 1.80, "net": 58.33}', '2024-10-25 18:02:00'),
(2, 'CHARGE', 88.57, 'USD', 'txn_3QKj6yE3gHz9i0mM1a2b3c4d', 'SUCCESS', '{"fee": 2.66, "net": 85.91}', '2024-10-26 18:32:00'),
(3, 'CHARGE', 40.33, 'USD', 'txn_PAYID-MXYZ123ABC456DEF789', 'SUCCESS', '{"fee": 1.21, "net": 39.12}', '2024-10-31 11:01:00'),
(4, 'CHARGE', 128.75, 'USD', 'txn_3QKj7zF4hIa0j1nN2b3c4d5e', 'SUCCESS', '{"fee": 3.86, "net": 124.89}', '2024-10-31 13:02:00'),
(5, 'CHARGE', 33.33, 'USD', NULL, 'FAILED', '{"error": "Payment cancelled by customer"}', '2024-10-30 12:45:00');

-- ============================================
-- 13. PAYMENT_METHODS TABLE
-- ============================================
CREATE TABLE payment_methods (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    method_type VARCHAR(20) NOT NULL CHECK (method_type IN ('CREDIT_CARD', 'DEBIT_CARD', 'WALLET', 'UPI', 'BANK_ACCOUNT')),
    card_last_four VARCHAR(4),
    card_brand VARCHAR(20),
    card_expiry_month INT,
    card_expiry_year INT,
    cardholder_name VARCHAR(200),
    billing_address JSONB,
    gateway_token VARCHAR(255),
    is_default BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE INDEX idx_payment_methods_customer_id ON payment_methods(customer_id);

-- Insert 5 sample payment methods
INSERT INTO payment_methods (customer_id, method_type, card_last_four, card_brand, card_expiry_month, card_expiry_year, cardholder_name, billing_address, gateway_token, is_default, is_active, created_at, updated_at) VALUES
(1, 'CREDIT_CARD', '4242', 'Visa', 12, 2026, 'John Doe', '{"street": "123 Main Street", "city": "New York", "state": "NY", "zip": "10001"}', 'pm_1QKj5xD2fGy8h9kL0z1m2n3o', TRUE, TRUE, '2024-01-15 08:30:00', '2024-01-15 08:30:00'),
(1, 'DEBIT_CARD', '1234', 'Mastercard', 6, 2025, 'John Doe', '{"street": "123 Main Street", "city": "New York", "state": "NY", "zip": "10001"}', 'pm_2ABC123DEF456GHI789JKL012', FALSE, TRUE, '2024-03-20 10:00:00', '2024-03-20 10:00:00'),
(2, 'CREDIT_CARD', '5555', 'Mastercard', 9, 2027, 'Jane Smith', '{"street": "789 Oak Avenue", "city": "Brooklyn", "state": "NY", "zip": "11201"}', 'pm_3QKj6yE3gHz9i0mM1a2b3c4d', TRUE, TRUE, '2024-02-20 09:50:00', '2024-02-20 09:50:00'),
(2, 'WALLET', NULL, 'PayPal', NULL, NULL, 'Jane Smith', NULL, 'ba_1MNO345PQR678STU901VWX234', FALSE, TRUE, '2024-04-10 14:30:00', '2024-04-10 14:30:00'),
(1, 'CREDIT_CARD', '7890', 'Amex', 3, 2028, 'John Doe', '{"street": "123 Main Street", "city": "New York", "state": "NY", "zip": "10001"}', 'pm_4XYZ789ABC012DEF345GHI678', FALSE, FALSE, '2024-02-01 11:00:00', '2024-08-15 16:00:00');

-- ============================================
-- 14. NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    notification_type VARCHAR(30) NOT NULL CHECK (notification_type IN ('ORDER_CONFIRMED', 'DELIVERY_ASSIGNED', 'DRIVER_ARRIVED', 'DELIVERY_COMPLETED', 'PAYMENT_SUCCESS', 'PAYMENT_FAILED', 'PROMOTIONAL', 'SYSTEM_ALERT')),
    channel VARCHAR(20) NOT NULL CHECK (channel IN ('EMAIL', 'SMS', 'PUSH', 'IN_APP')),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SENT', 'DELIVERED', 'FAILED', 'READ')),
    priority VARCHAR(20) DEFAULT 'NORMAL' CHECK (priority IN ('LOW', 'NORMAL', 'HIGH', 'URGENT')),
    reference_type VARCHAR(50),
    reference_id BIGINT,
    metadata JSONB,
    scheduled_at TIMESTAMP,
    sent_at TIMESTAMP,
    delivered_at TIMESTAMP,
    read_at TIMESTAMP,
    failure_reason TEXT,
    retry_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_status ON notifications(status);
CREATE INDEX idx_notifications_type ON notifications(notification_type);

-- Insert 5 sample notifications
INSERT INTO notifications (user_id, notification_type, channel, title, message, status, priority, reference_type, reference_id, metadata, scheduled_at, sent_at, delivered_at, read_at, created_at) VALUES
(1, 'ORDER_CONFIRMED', 'PUSH', 'Order Confirmed!', 'Your order #ORD-2024-001 has been confirmed and will be delivered soon.', 'READ', 'HIGH', 'ORDER', 1, '{"order_number": "ORD-2024-001", "total": 60.13}', '2024-10-25 18:00:00', '2024-10-25 18:00:01', '2024-10-25 18:00:02', '2024-10-25 18:05:00', '2024-10-25 18:00:00'),
(1, 'DELIVERY_ASSIGNED', 'SMS', 'Driver Assigned', 'Mike is on the way to pick up your order. Track your delivery in real-time.', 'DELIVERED', 'NORMAL', 'DELIVERY', 1, '{"driver_name": "Mike", "driver_rating": 4.85}', '2024-10-25 18:55:00', '2024-10-25 18:55:01', '2024-10-25 18:55:05', NULL, '2024-10-25 18:55:00'),
(1, 'DELIVERY_COMPLETED', 'EMAIL', 'Order Delivered!', 'Your order #ORD-2024-001 has been successfully delivered. Enjoy your meal!', 'READ', 'HIGH', 'DELIVERY', 1, '{"delivery_time": "2024-10-25 19:25:00", "rating_prompt": true}', '2024-10-25 19:25:00', '2024-10-25 19:25:02', '2024-10-25 19:25:10', '2024-10-25 20:00:00', '2024-10-25 19:25:00'),
(2, 'PAYMENT_SUCCESS', 'IN_APP', 'Payment Successful', 'Your payment of $88.57 has been processed successfully.', 'READ', 'NORMAL', 'PAYMENT', 2, '{"amount": 88.57, "payment_method": "Credit Card ending in 5555"}', '2024-10-26 18:32:00', '2024-10-26 18:32:01', '2024-10-26 18:32:02', '2024-10-26 18:35:00', '2024-10-26 18:32:00'),
(1, 'PROMOTIONAL', 'EMAIL', 'Special Offer: 20% Off!', 'Use code SAVE20 on your next order and get 20% off. Valid until Nov 15.', 'SENT', 'LOW', NULL, NULL, '{"promo_code": "SAVE20", "discount": 20, "valid_until": "2024-11-15"}', '2024-10-28 10:00:00', '2024-10-28 10:00:05', '2024-10-28 10:00:15', NULL, '2024-10-27 15:00:00');

-- ============================================
-- 15. NOTIFICATION_PREFERENCES TABLE
-- ============================================
CREATE TABLE notification_preferences (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT UNIQUE NOT NULL,
    email_enabled BOOLEAN DEFAULT TRUE,
    sms_enabled BOOLEAN DEFAULT TRUE,
    push_enabled BOOLEAN DEFAULT TRUE,
    in_app_enabled BOOLEAN DEFAULT TRUE,
    order_updates BOOLEAN DEFAULT TRUE,
    promotional_emails BOOLEAN DEFAULT FALSE,
    delivery_tracking BOOLEAN DEFAULT TRUE,
    payment_alerts BOOLEAN DEFAULT TRUE,
    weekly_summary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_notification_preferences_user_id ON notification_preferences(user_id);

-- Insert 5 sample notification preferences
INSERT INTO notification_preferences (user_id, email_enabled, sms_enabled, push_enabled, in_app_enabled, order_updates, promotional_emails, delivery_tracking, payment_alerts, weekly_summary, created_at, updated_at) VALUES
(1, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, '2024-01-15 08:00:00', '2024-01-15 08:00:00'),
(2, TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-02-20 09:30:00', '2024-02-20 09:30:00'),
(3, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, '2024-03-10 11:00:00', '2024-03-10 11:00:00'),
(4, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, '2024-03-15 10:00:00', '2024-03-15 10:00:00'),
(5, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, '2024-01-01 00:00:00', '2024-01-01 00:00:00');

-- ============================================
-- 16. PERSONAL_ACCESS_TOKENS TABLE
-- ============================================
CREATE TABLE personal_access_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    token_name VARCHAR(100) NOT NULL,
    token_hash VARCHAR(255) UNIQUE NOT NULL,
    token_prefix VARCHAR(20) NOT NULL,
    scopes JSONB,
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'REVOKED', 'EXPIRED')),
    last_used_at TIMESTAMP,
    last_used_ip VARCHAR(45),
    expires_at TIMESTAMP,
    revoked_at TIMESTAMP,
    revoked_by BIGINT,
    revocation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (revoked_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_personal_access_tokens_user_id ON personal_access_tokens(user_id);
CREATE INDEX idx_personal_access_tokens_hash ON personal_access_tokens(token_hash);
CREATE INDEX idx_personal_access_tokens_prefix ON personal_access_tokens(token_prefix);
CREATE INDEX idx_personal_access_tokens_status ON personal_access_tokens(status);

-- Insert 5 sample personal access tokens
INSERT INTO personal_access_tokens (user_id, token_name, token_hash, token_prefix, scopes, status, last_used_at, last_used_ip, expires_at, created_at, updated_at) VALUES
(1, 'Mobile App - iPhone', '$2a$10$wV8P0E4m3D2q1C9b7x6u8s7tR3D2q1C9b7x6u8s7tR3D2q1C9b7x', 'pat_mob_abc123', '["orders:read", "orders:write", "profile:read"]', 'ACTIVE', '2024-10-31 10:30:00', '192.168.1.100', '2025-10-01 00:00:00', '2024-01-20 12:00:00', '2024-10-31 10:30:00'),
(1, 'Web Dashboard', '$2a$10$xW9Q1F5n4E3r2D0c8y7v9t8uS4E3r2D0c8y7v9t8uS4E3r2D0c8y', 'pat_web_xyz789', '["orders:read", "orders:write", "profile:read", "profile:write", "deliveries:read"]', 'ACTIVE', '2024-10-30 15:45:00', '203.0.113.50', '2025-01-20 00:00:00', '2024-02-15 09:00:00', '2024-10-30 15:45:00'),
(5, 'Admin API Access', '$2a$10$yX0R2G6o5F4s3E1d9z8w0u9vT5F4s3E1d9z8w0u9vT5F4s3E1d9z', 'pat_adm_def456', '["*"]', 'ACTIVE', '2024-10-31 08:15:00', '198.51.100.25', NULL, '2024-01-01 00:30:00', '2024-10-31 08:15:00'),
(2, 'Mobile App - Android', '$2a$10$zY1S3H7p6G5t4F2e0a9x1v0wU6G5t4F2e0a9x1v0wU6G5t4F2e0a', 'pat_mob_ghi012', '["orders:read", "orders:write", "profile:read"]', 'REVOKED', '2024-09-15 11:20:00', '192.168.1.105', '2025-02-20 00:00:00', '2024-02-25 14:00:00', '2024-09-20 10:00:00'),
(3, 'Driver Mobile App', '$2a$10$aZ2T4I8q7H6u5G3f1b0y2w1xV7H6u5G3f1b0y2w1xV7H6u5G3f1b', 'pat_drv_jkl345', '["deliveries:read", "deliveries:write", "profile:read", "location:write"]', 'ACTIVE', '2024-10-31 07:05:00', '192.168.1.110', '2025-03-10 00:00:00', '2024-03-11 08:00:00', '2024-10-31 07:05:00');

-- ============================================
-- 17. TOKEN_PERMISSIONS TABLE
-- ============================================
CREATE TABLE token_permissions (
    id BIGSERIAL PRIMARY KEY,
    token_id BIGINT NOT NULL,
    permission VARCHAR(100) NOT NULL,
    resource VARCHAR(100),
    action VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (token_id) REFERENCES personal_access_tokens(id) ON DELETE CASCADE,
    UNIQUE (token_id, permission, resource, action)
);

CREATE INDEX idx_token_permissions_token_id ON token_permissions(token_id);

-- Insert 5 sample token permissions
INSERT INTO token_permissions (token_id, permission, resource, action, created_at) VALUES
(1, 'orders:read', 'orders', 'read', '2024-01-20 12:00:00'),
(1, 'orders:write', 'orders', 'write', '2024-01-20 12:00:00'),
(1, 'profile:read', 'profile', 'read', '2024-01-20 12:00:00'),
(2, 'orders:read', 'orders', 'read', '2024-02-15 09:00:00'),
(2, 'deliveries:read', 'deliveries', 'read', '2024-02-15 09:00:00');

-- ============================================
-- 18. TOKEN_USAGE_LOGS TABLE
-- ============================================
CREATE TABLE token_usage_logs (
    id BIGSERIAL PRIMARY KEY,
    token_id BIGINT NOT NULL,
    endpoint VARCHAR(255) NOT NULL,
    http_method VARCHAR(10) NOT NULL,
    status_code INT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    request_payload JSONB,
    response_time_ms INT,
    error_message TEXT,
    accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (token_id) REFERENCES personal_access_tokens(id) ON DELETE CASCADE
);

CREATE INDEX idx_token_usage_logs_token_id ON token_usage_logs(token_id);
CREATE INDEX idx_token_usage_logs_accessed_at ON token_usage_logs(accessed_at);

-- Insert 5 sample token usage logs
INSERT INTO token_usage_logs (token_id, endpoint, http_method, status_code, ip_address, user_agent, request_payload, response_time_ms, accessed_at) VALUES
(1, '/api/v1/orders', 'GET', 200, '192.168.1.100', 'DeliveryApp/iOS 2.5.0', '{"page": 1, "limit": 20}', 145, '2024-10-31 10:25:00'),
(1, '/api/v1/orders/ORD-2024-003', 'GET', 200, '192.168.1.100', 'DeliveryApp/iOS 2.5.0', NULL, 89, '2024-10-31 10:30:00'),
(2, '/api/v1/profile', 'GET', 200, '203.0.113.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', NULL, 67, '2024-10-30 15:40:00'),
(2, '/api/v1/orders', 'POST', 201, '203.0.113.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', '{"items": [], "total": 45.99}', 234, '2024-10-30 15:45:00'),
(5, '/api/v1/admin/users', 'GET', 200, '198.51.100.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '{"page": 1, "limit": 50}', 178, '2024-10-31 08:15:00');

-- ============================================
-- 19. RATINGS TABLE
-- ============================================
CREATE TABLE ratings (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    delivery_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    driver_id BIGINT NOT NULL,
    rating_type VARCHAR(30) NOT NULL CHECK (rating_type IN ('DRIVER', 'DELIVERY_EXPERIENCE', 'APP_EXPERIENCE')),
    rating_value DECIMAL(2, 1) NOT NULL CHECK (rating_value >= 1.0 AND rating_value <= 5.0),
    review_text TEXT,
    tags JSONB,
    is_anonymous BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT TRUE,
    helpful_count INT DEFAULT 0,
    flagged BOOLEAN DEFAULT FALSE,
    flag_reason TEXT,
    response_text TEXT,
    responded_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES drivers(id) ON DELETE CASCADE
);

CREATE INDEX idx_ratings_order_id ON ratings(order_id);
CREATE INDEX idx_ratings_driver_id ON ratings(driver_id);
CREATE INDEX idx_ratings_rating_value ON ratings(rating_value);
CREATE INDEX idx_ratings_created_at ON ratings(created_at);

-- Insert 5 sample ratings
INSERT INTO ratings (order_id, delivery_id, customer_id, driver_id, rating_type, rating_value, review_text, tags, is_anonymous, is_verified, helpful_count, created_at, updated_at) VALUES
(1, 1, 1, 1, 'DRIVER', 5.0, 'Mike was excellent! Very professional and delivered right on time. Food was still hot!', '["professional", "on-time", "friendly"]', FALSE, TRUE, 3, '2024-10-25 20:00:00', '2024-10-25 20:00:00'),
(1, 1, 1, 1, 'DELIVERY_EXPERIENCE', 4.5, 'Great experience overall. Delivery was quick and packaging was perfect.', '["quick", "well-packaged"]', FALSE, TRUE, 1, '2024-10-25 20:05:00', '2024-10-25 20:05:00'),
(2, 2, 2, 2, 'DRIVER', 5.0, 'Sarah is amazing! Best delivery driver ever. Very careful with the food and super friendly.', '["friendly", "careful", "excellent"]', FALSE, TRUE, 5, '2024-10-26 20:30:00', '2024-10-26 20:30:00'),
(2, 2, 2, 2, 'DELIVERY_EXPERIENCE', 5.0, 'Perfect delivery experience. Real-time tracking was very accurate.', '["accurate-tracking", "smooth"]', FALSE, TRUE, 2, '2024-10-26 20:35:00', '2024-10-26 20:35:00'),
(1, 1, 1, 1, 'APP_EXPERIENCE', 4.0, 'App works well. Would love to see more payment options though.', '["easy-to-use", "needs-more-features"]', FALSE, TRUE, 0, '2024-10-25 20:10:00', '2024-10-25 20:10:00');

-- ============================================
-- 20. WEBHOOKS TABLE
-- ============================================
CREATE TABLE webhooks (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    webhook_url VARCHAR(500) NOT NULL,
    secret_key VARCHAR(255) NOT NULL,
    events JSONB NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    description TEXT,
    retry_policy JSONB,
    last_triggered_at TIMESTAMP,
    success_count INT DEFAULT 0,
    failure_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_webhooks_user_id ON webhooks(user_id);
CREATE INDEX idx_webhooks_is_active ON webhooks(is_active);

-- Insert 5 sample webhooks
INSERT INTO webhooks (user_id, webhook_url, secret_key, events, is_active, description, retry_policy, last_triggered_at, success_count, failure_count, created_at, updated_at) VALUES
(5, 'https://api.partner.com/webhooks/orders', 'whsec_abc123def456ghi789jkl012mno345', '["order.created", "order.confirmed", "order.delivered"]', TRUE, 'Order status notifications to partner system', '{"max_attempts": 3, "backoff_multiplier": 2}', '2024-10-31 10:30:00', 1247, 23, '2024-01-10 10:00:00', '2024-10-31 10:30:00'),
(5, 'https://analytics.company.com/delivery-events', 'whsec_pqr456stu789vwx012yza345bcd678', '["delivery.assigned", "delivery.started", "delivery.completed"]', TRUE, 'Delivery tracking for analytics', '{"max_attempts": 5, "backoff_multiplier": 1.5}', '2024-10-31 09:15:00', 2156, 12, '2024-01-15 11:30:00', '2024-10-31 09:15:00'),
(5, 'https://payments.processor.com/hooks/status', 'whsec_efg789hij012klm345nop678qrs901', '["payment.processed", "payment.failed", "payment.refunded"]', TRUE, 'Payment status updates', '{"max_attempts": 3, "backoff_multiplier": 2}', '2024-10-31 08:45:00', 987, 8, '2024-02-01 09:00:00', '2024-10-31 08:45:00'),
(1, 'https://myapp.example.com/api/notifications', 'whsec_tuv234wxy567zab890cde123fgh456', '["order.confirmed", "delivery.completed"]', TRUE, 'Personal order notifications', '{"max_attempts": 2, "backoff_multiplier": 1}', '2024-10-30 15:50:00', 45, 2, '2024-03-15 14:00:00', '2024-10-30 15:50:00'),
(5, 'https://backup.monitoring.com/events', 'whsec_ijk567lmn890opq123rst456uvw789', '["*"]', FALSE, 'Backup webhook for monitoring (currently disabled)', '{"max_attempts": 3, "backoff_multiplier": 2}', '2024-09-30 12:00:00', 5234, 156, '2024-01-05 08:00:00', '2024-10-15 10:00:00');

-- ============================================
-- 21. WEBHOOK_DELIVERIES TABLE
-- ============================================
CREATE TABLE webhook_deliveries (
    id BIGSERIAL PRIMARY KEY,
    webhook_id BIGINT NOT NULL,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'RETRYING')),
    http_status_code INT,
    response_body TEXT,
    error_message TEXT,
    attempt_count INT DEFAULT 0,
    next_retry_at TIMESTAMP,
    delivered_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (webhook_id) REFERENCES webhooks(id) ON DELETE CASCADE
);

CREATE INDEX idx_webhook_deliveries_webhook_id ON webhook_deliveries(webhook_id);
CREATE INDEX idx_webhook_deliveries_status ON webhook_deliveries(status);
CREATE INDEX idx_webhook_deliveries_event_type ON webhook_deliveries(event_type);
CREATE INDEX idx_webhook_deliveries_created_at ON webhook_deliveries(created_at);

-- Insert 5 sample webhook deliveries
INSERT INTO webhook_deliveries (webhook_id, event_type, payload, status, http_status_code, response_body, attempt_count, delivered_at, created_at) VALUES
(1, 'order.created', '{"order_id": 1, "order_number": "ORD-2024-001", "customer_id": 1, "total": 60.13, "status": "PENDING"}', 'SUCCESS', 200, '{"received": true, "id": "evt_001"}', 1, '2024-10-25 18:00:02', '2024-10-25 18:00:00'),
(1, 'order.confirmed', '{"order_id": 1, "order_number": "ORD-2024-001", "status": "CONFIRMED"}', 'SUCCESS', 200, '{"received": true, "id": "evt_002"}', 1, '2024-10-25 18:05:01', '2024-10-25 18:05:00'),
(2, 'delivery.assigned', '{"delivery_id": 1, "order_id": 1, "driver_id": 1, "driver_name": "Mike Johnson"}', 'SUCCESS', 200, '{"received": true, "tracked": true}', 1, '2024-10-25 18:55:02', '2024-10-25 18:55:00'),
(2, 'delivery.completed', '{"delivery_id": 1, "order_id": 1, "completed_at": "2024-10-25 19:25:00"}', 'SUCCESS', 200, '{"received": true, "tracked": true}', 1, '2024-10-25 19:25:03', '2024-10-25 19:25:00'),
(3, 'payment.processed', '{"payment_id": 1, "order_id": 1, "amount": 60.13, "status": "COMPLETED"}', 'SUCCESS', 200, '{"processed": true, "transaction_id": "txn_abc123"}', 1, '2024-10-25 18:02:01', '2024-10-25 18:02:00');

-- ============================================
-- 22. PROMOCODES TABLE
-- ============================================
CREATE TABLE promocodes (
    id BIGSERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL CHECK (discount_type IN ('PERCENTAGE', 'FIXED_AMOUNT', 'FREE_DELIVERY')),
    discount_value DECIMAL(12, 2) NOT NULL,
    max_discount_amount DECIMAL(12, 2),
    min_order_amount DECIMAL(12, 2),
    usage_limit INT,
    usage_per_user INT DEFAULT 1,
    current_usage_count INT DEFAULT 0,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    applicable_to VARCHAR(20) DEFAULT 'ALL' CHECK (applicable_to IN ('ALL', 'FIRST_ORDER', 'SPECIFIC_USERS')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_promocodes_code ON promocodes(code);
CREATE INDEX idx_promocodes_is_active ON promocodes(is_active);
CREATE INDEX idx_promocodes_valid_dates ON promocodes(valid_from, valid_until);

-- Insert 5 sample promocodes
INSERT INTO promocodes (code, description, discount_type, discount_value, max_discount_amount, min_order_amount, usage_limit, usage_per_user, current_usage_count, valid_from, valid_until, applicable_to, is_active, created_at, updated_at) VALUES
('WELCOME10', 'Welcome offer - 10% off first order', 'PERCENTAGE', 10.00, 15.00, 20.00, 1000, 1, 234, '2024-01-01 00:00:00', '2024-12-31 23:59:59', 'FIRST_ORDER', TRUE, '2024-01-01 00:00:00', '2024-10-31 10:00:00'),
('SAVE20', 'Save $20 on orders over $100', 'FIXED_AMOUNT', 20.00, 20.00, 100.00, 500, 2, 87, '2024-10-01 00:00:00', '2024-11-15 23:59:59', 'ALL', TRUE, '2024-09-25 10:00:00', '2024-10-31 10:00:00'),
('FREEDEL', 'Free delivery for all orders', 'FREE_DELIVERY', 0.00, NULL, 30.00, NULL, 1, 456, '2024-10-15 00:00:00', '2024-11-30 23:59:59', 'ALL', TRUE, '2024-10-10 12:00:00', '2024-10-31 10:00:00'),
('BIGDEAL50', 'Mega discount - 50% off!', 'PERCENTAGE', 50.00, 50.00, 75.00, 100, 1, 89, '2024-10-28 00:00:00', '2024-11-03 23:59:59', 'ALL', TRUE, '2024-10-20 15:00:00', '2024-10-31 10:00:00'),
('EXPIRED15', 'Expired promo code', 'PERCENTAGE', 15.00, 10.00, 25.00, 200, 1, 152, '2024-08-01 00:00:00', '2024-09-30 23:59:59', 'ALL', FALSE, '2024-07-25 09:00:00', '2024-10-01 00:00:00');

-- ============================================
-- 23. PROMOCODE_USAGE TABLE
-- ============================================
CREATE TABLE promocode_usage (
    id BIGSERIAL PRIMARY KEY,
    promocode_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    discount_amount DECIMAL(12, 2) NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (promocode_id) REFERENCES promocodes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    UNIQUE (user_id, order_id, promocode_id)
);

CREATE INDEX idx_promocode_usage_promocode_id ON promocode_usage(promocode_id);
CREATE INDEX idx_promocode_usage_user_id ON promocode_usage(user_id);

-- Insert 5 sample promocode usage records
INSERT INTO promocode_usage (promocode_id, user_id, order_id, discount_amount, used_at) VALUES
(2, 2, 2, 10.00, '2024-10-26 18:30:00'),
(4, 1, 3, 5.00, '2024-10-31 11:00:00'),
(4, 2, 4, 15.00, '2024-10-31 13:00:00');

-- ============================================
-- 24. AUDIT_LOGS TABLE
-- ============================================
CREATE TABLE audit_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100) NOT NULL,
    entity_id BIGINT NOT NULL,
    old_values JSONB,
    new_values JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

-- Insert 5 sample audit logs
INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) VALUES
(1, 'CREATE', 'ORDER', 1, NULL, '{"order_number": "ORD-2024-001", "total": 60.13, "status": "PENDING"}', '192.168.1.100', 'DeliveryApp/iOS 2.5.0', '2024-10-25 18:00:00'),
(1, 'UPDATE', 'ORDER', 1, '{"status": "PENDING"}', '{"status": "CONFIRMED"}', '192.168.1.100', 'DeliveryApp/iOS 2.5.0', '2024-10-25 18:05:00'),
(3, 'UPDATE', 'DELIVERY', 1, '{"status": "ASSIGNED"}', '{"status": "PICKED_UP"}', '192.168.1.110', 'DeliveryApp/iOS 2.4.8', '2024-10-25 18:58:00'),
(3, 'UPDATE', 'DELIVERY', 1, '{"status": "IN_TRANSIT"}', '{"status": "DELIVERED"}', '192.168.1.110', 'DeliveryApp/iOS 2.4.8', '2024-10-25 19:25:00'),
(5, 'CREATE', 'PROMOCODE', 4, NULL, '{"code": "BIGDEAL50", "discount_type": "PERCENTAGE", "discount_value": 50}', '198.51.100.25', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)', '2024-10-20 15:00:00');

-- ============================================
-- 25. SUPPORT_TICKETS TABLE
-- ============================================
CREATE TABLE support_tickets (
    id BIGSERIAL PRIMARY KEY,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    user_id BIGINT NOT NULL,
    order_id BIGINT,
    delivery_id BIGINT,
    category VARCHAR(30) NOT NULL CHECK (category IN ('ORDER_ISSUE', 'DELIVERY_ISSUE', 'PAYMENT_ISSUE', 'ACCOUNT', 'TECHNICAL', 'OTHER')),
    priority VARCHAR(20) DEFAULT 'MEDIUM' CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')),
    status VARCHAR(30) DEFAULT 'OPEN' CHECK (status IN ('OPEN', 'IN_PROGRESS', 'WAITING_ON_CUSTOMER', 'RESOLVED', 'CLOSED')),
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    assigned_to BIGINT,
    resolved_at TIMESTAMP,
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
    FOREIGN KEY (delivery_id) REFERENCES deliveries(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_support_tickets_user_id ON support_tickets(user_id);
CREATE INDEX idx_support_tickets_ticket_number ON support_tickets(ticket_number);
CREATE INDEX idx_support_tickets_status ON support_tickets(status);
CREATE INDEX idx_support_tickets_created_at ON support_tickets(created_at);

-- Insert 5 sample support tickets
INSERT INTO support_tickets (ticket_number, user_id, order_id, delivery_id, category, priority, status, subject, description, assigned_to, resolved_at, resolution_notes, created_at, updated_at) VALUES
('TKT-2024-001', 1, 1, 1, 'DELIVERY_ISSUE', 'LOW', 'RESOLVED', 'Missing utensils in delivery', 'I ordered a meal but did not receive any utensils. Can you please help?', 5, '2024-10-25 21:00:00', 'Apologized to customer and issued $5 credit for next order. Will remind restaurant partners to include utensils.', '2024-10-25 20:30:00', '2024-10-25 21:00:00'),
('TKT-2024-002', 2, 2, 2, 'ORDER_ISSUE', 'MEDIUM', 'RESOLVED', 'Wrong item delivered', 'I ordered California roll but received spicy tuna roll instead.', 5, '2024-10-26 21:30:00', 'Full refund processed. Restaurant confirmed the mix-up. Customer satisfied with resolution.', '2024-10-26 20:45:00', '2024-10-26 21:30:00'),
('TKT-2024-003', 1, NULL, NULL, 'PAYMENT_ISSUE', 'HIGH', 'IN_PROGRESS', 'Double charge on credit card', 'I was charged twice for order ORD-2024-001. Please investigate and refund.', 5, NULL, NULL, '2024-10-27 14:20:00', '2024-10-28 10:00:00'),
('TKT-2024-004', 2, NULL, NULL, 'ACCOUNT', 'LOW', 'OPEN', 'Cannot update payment method', 'Getting an error when trying to add a new credit card to my account.', NULL, NULL, NULL, '2024-10-30 16:45:00', '2024-10-30 16:45:00'),
('TKT-2024-005', 3, NULL, NULL, 'TECHNICAL', 'URGENT', 'IN_PROGRESS', 'Driver app crashing on Android', 'The driver app keeps crashing when I try to accept delivery requests. Using Samsung Galaxy S21.', 5, NULL, NULL, '2024-10-31 08:30:00', '2024-10-31 09:00:00');

-- ============================================
-- SUMMARY: RECORD COUNTS
-- ============================================
-- Users: 5 records
-- Customers: 2 records
-- Addresses: 5 records
-- Drivers: 2 records
-- Vehicles: 5 records
-- Orders: 5 records
-- Order Items: 5 records
-- Deliveries: 5 records
-- Delivery Routes: 5 records
-- Delivery Tracking: 5 records
-- Payments: 5 records
-- Payment Transactions: 5 records
-- Payment Methods: 5 records
-- Notifications: 5 records
-- Notification Preferences: 5 records
-- Personal Access Tokens: 5 records
-- Token Permissions: 5 records
-- Token Usage Logs: 5 records
-- Ratings: 5 records
-- Webhooks: 5 records
-- Webhook Deliveries: 5 records
-- Promocodes: 5 records
-- Promocode Usage: 3 records
-- Audit Logs: 5 records
-- Support Tickets: 5 records

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Run these to verify data was inserted correctly:

-- SELECT COUNT(*) as total_users FROM users;
-- SELECT COUNT(*) as total_orders FROM orders;
-- SELECT COUNT(*) as total_deliveries FROM deliveries;
-- SELECT COUNT(*) as total_drivers FROM drivers;
-- SELECT COUNT(*) as total_payments FROM payments;

-- View recent orders with customer info:
-- SELECT o.order_number, c.first_name, c.last_name, o.total_amount, o.status
-- FROM orders o
-- JOIN customers c ON o.customer_id = c.id
-- ORDER BY o.created_at DESC;

-- View active deliveries with driver info:
-- SELECT d.delivery_number, o.order_number, dr.first_name as driver_name, d.status
-- FROM deliveries d
-- JOIN orders o ON d.order_id = o.id
-- LEFT JOIN drivers dr ON d.driver_id = dr.id
-- WHERE d.status NOT IN ('DELIVERED', 'CANCELLED', 'FAILED')
-- ORDER BY d.created_at DESC;