CREATE DATABASE vpn_database
GO

USE vpn_database
GO

-- CREATE ALL TABLES
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NULL,
    gender VARCHAR(10) CHECK (gender IN ('male','female','other')),
    phone VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(200) NOT NULL,
    city VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL,
    account_status VARCHAR(20) NULL,
    country VARCHAR(50) NULL,
    postal_code VARCHAR(12) NULL,
    last_login DATE NULL,
    two_factor_enabled BIT NULL
)

CREATE TABLE User_Profile (
    profile_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    profile_status VARCHAR(20) CHECK (profile_status IN ('active','inactive')),
    preferred_protocol VARCHAR(20) CHECK (preferred_protocol IN ('OpenVPN','WireGuard','IKEv2')),
    created_date DATE NULL,
    last_password_change DATE NULL,
    failed_login_attempts INT NULL,
    two_factor_enabled BIT NULL,
    profile_note VARCHAR(100) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
)

CREATE TABLE Admin (
    admin_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    role VARCHAR(30) NOT NULL,
    admin_status VARCHAR(20) CHECK (admin_status IN ('active','inactive')),
    joining_date DATE NOT NULL,
    department VARCHAR(50) NULL,
    access_level INT NULL,
    last_login DATE NULL,
    two_factor_enabled BIT NULL,
    admin_note VARCHAR(100) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL
)

CREATE TABLE Server_Location (
    location_id INT PRIMARY KEY,
    location_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    data_center VARCHAR(100) NOT NULL,
    latitude DECIMAL(9,6) NULL,
    longitude DECIMAL(9,6) NULL,
    timezone VARCHAR(40) NULL,
    capacity_users INT NULL,
    location_status VARCHAR(20) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL
)

CREATE TABLE Server_Type (
    server_type_id INT PRIMARY KEY,
    server_type_name VARCHAR(50) NOT NULL,
    protocol VARCHAR(30) NOT NULL,
    encryption VARCHAR(50) NOT NULL,
    server_speed INT NOT NULL,
    description VARCHAR(150) NOT NULL,
    port_number INT NULL,
    supported_devices INT NULL,
    logging_enabled BIT NULL,
    kill_switch_supported BIT NULL,
    type_status VARCHAR(20) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL
)

CREATE TABLE VPN_Server (
    server_id INT PRIMARY KEY,
    admin_id INT NOT NULL,
    location_id INT NOT NULL,
    server_type_id INT NOT NULL,
    server_name VARCHAR(50) NOT NULL,
    server_ip VARCHAR(45) NOT NULL UNIQUE,
    server_status VARCHAR(20) CHECK (server_status IN ('online','offline','maintenance')),
    max_users INT NOT NULL,
    current_users INT NOT NULL,
    server_speed INT NOT NULL,
    operating_system VARCHAR(40) NULL,
    cpu_cores INT NULL,
    memory_gb INT NULL,
    last_health_check DATE NULL,
    maintenance_window VARCHAR(40) NULL,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
    FOREIGN KEY (location_id) REFERENCES Server_Location(location_id),
    FOREIGN KEY (server_type_id) REFERENCES Server_Type(server_type_id)
)

CREATE TABLE VPN_Plan (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50) NOT NULL,
    plan_type VARCHAR(30) NOT NULL,
    duration_months INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    max_devices INT NOT NULL,
    data_limit VARCHAR(30) NOT NULL,
    plan_status VARCHAR(20) CHECK (plan_status IN ('active','inactive')),
    support_level VARCHAR(30) NULL,
    trial_days INT NULL,
    discount_percent DECIMAL(5,2) NULL,
    renewal_type VARCHAR(20) NULL,
    plan_description VARCHAR(120) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL
)

CREATE TABLE Subscription (
    subscription_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_id INT NOT NULL,
    server_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    subscription_status VARCHAR(20) CHECK (subscription_status IN ('active','expired','cancelled')),
    auto_renewal VARCHAR(10) CHECK (auto_renewal IN ('yes','no')),
    billing_cycle VARCHAR(20) NULL,
    discount_amount DECIMAL(8,2) NULL,
    renewal_date DATE NULL,
    created_date DATE NULL,
    cancellation_reason VARCHAR(100) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (plan_id) REFERENCES VPN_Plan(plan_id),
    FOREIGN KEY (server_id) REFERENCES VPN_Server(server_id)
)

CREATE TABLE Payment_Method (
    payment_method_id INT PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    provider_name VARCHAR(50) NOT NULL,
    account_type VARCHAR(30) NOT NULL,
    method_status VARCHAR(20) CHECK (method_status IN ('active','inactive')),
    processing_fee_percent DECIMAL(5,2) NULL,
    currency VARCHAR(10) NULL,
    daily_limit DECIMAL(10,2) NULL,
    requires_verification BIT NULL,
    method_description VARCHAR(100) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL,
    additional_detail_5 VARCHAR(80) NULL
)

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    subscription_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    transaction_id VARCHAR(50) NOT NULL UNIQUE,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) CHECK (payment_status IN ('successful','pending','failed','refunded')),
    currency VARCHAR(10) NULL,
    tax_amount DECIMAL(8,2) NULL,
    discount_amount DECIMAL(8,2) NULL,
    payment_gateway VARCHAR(40) NULL,
    refund_status VARCHAR(20) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id),
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Method(payment_method_id)
)

CREATE TABLE Device (
    device_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    device_name VARCHAR(50) NOT NULL,
    device_type VARCHAR(30) NOT NULL,
    operating_system VARCHAR(50) NOT NULL,
    device_status VARCHAR(20) NOT NULL CHECK (device_status IN ('active','inactive')),
    registered_date DATE NOT NULL,
    device_model VARCHAR(50) NULL,
    device_identifier VARCHAR(60) NULL,
    app_version VARCHAR(20) NULL,
    last_seen_date DATE NULL,
    trusted_device BIT NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
)

CREATE TABLE User_Device (
    user_device_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    device_id INT NOT NULL,
    assigned_date DATE NOT NULL,
    assignment_status VARCHAR(20) NOT NULL CHECK (assignment_status IN ('active','inactive')),
    device_nickname VARCHAR(50) NULL,
    is_primary_device BIT NULL,
    last_used_date DATE NULL,
    device_permission VARCHAR(30) NULL,
    notes VARCHAR(100) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL,
    additional_detail_5 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (device_id) REFERENCES Device(device_id)
)

CREATE TABLE VPN_Session (
    session_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    server_id INT NOT NULL,
    device_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NULL,
    session_status VARCHAR(20) NOT NULL CHECK (session_status IN ('connected','disconnected','failed')),
    ip_address VARCHAR(45) NOT NULL,
    session_duration_minutes INT NULL,
    bytes_sent BIGINT NULL,
    bytes_received BIGINT NULL,
    country_code CHAR(2) NULL,
    termination_reason VARCHAR(40) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (server_id) REFERENCES VPN_Server(server_id),
    FOREIGN KEY (device_id) REFERENCES Device(device_id)
)

CREATE TABLE Connection_Log (
    log_id INT PRIMARY KEY,
    session_id INT NOT NULL,
    log_time DATETIME NOT NULL,
    event_type VARCHAR(30) NOT NULL,
    event_details VARCHAR(200) NOT NULL,
    source_ip VARCHAR(45) NULL,
    destination_port INT NULL,
    protocol_version VARCHAR(20) NULL,
    result_code INT NULL,
    logged_by VARCHAR(40) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL,
    additional_detail_5 VARCHAR(80) NULL,
    FOREIGN KEY (session_id) REFERENCES VPN_Session(session_id)
)

CREATE TABLE Usage_Record (
    usage_id INT PRIMARY KEY,
    session_id INT NOT NULL,
    upload_mb DECIMAL(10,2) NOT NULL,
    download_mb DECIMAL(10,2) NOT NULL,
    total_usage_mb DECIMAL(10,2) NOT NULL,
    recorded_date DATE NOT NULL,
    billing_period VARCHAR(20) NULL,
    peak_usage_mb INT NULL,
    throttle_applied BIT NULL,
    overage_mb INT NULL,
    usage_cost DECIMAL(8,2) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL,
    FOREIGN KEY (session_id) REFERENCES VPN_Session(session_id)
)

CREATE TABLE Security_Log (
    security_log_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    server_id INT NOT NULL,
    event_time DATETIME NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL CHECK (severity IN ('low','medium','high')),
    event_status VARCHAR(20) NOT NULL CHECK (event_status IN ('open','resolved')),
    source_ip VARCHAR(45) NULL,
    device_id INT NULL,
    risk_score INT NULL,
    action_taken VARCHAR(50) NULL,
    reviewed_by VARCHAR(50) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (server_id) REFERENCES VPN_Server(server_id)
)

CREATE TABLE Server_Maintenance (
    maintenance_id INT PRIMARY KEY,
    server_id INT NOT NULL,
    admin_id INT NOT NULL,
    maintenance_date DATE NOT NULL,
    maintenance_type VARCHAR(50) NOT NULL,
    maintenance_status VARCHAR(20) NOT NULL CHECK (maintenance_status IN ('scheduled','completed','pending')),
    notes VARCHAR(200) NOT NULL,
    duration_hours DECIMAL(5,2) NULL,
    downtime_minutes INT NULL,
    maintenance_cost DECIMAL(10,2) NULL,
    next_maintenance_date DATE NULL,
    approved_by VARCHAR(50) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    FOREIGN KEY (server_id) REFERENCES VPN_Server(server_id),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
)

CREATE TABLE Support_Ticket (
    ticket_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    ticket_subject VARCHAR(100) NOT NULL,
    ticket_description VARCHAR(250) NOT NULL,
    created_date DATE NOT NULL,
    ticket_status VARCHAR(20) NOT NULL CHECK (ticket_status IN ('open','in_progress','closed')),
    priority VARCHAR(20) NOT NULL CHECK (priority IN ('low','medium','high')),
    ticket_channel VARCHAR(30) NULL,
    assigned_team VARCHAR(40) NULL,
    resolution_date DATE NULL,
    satisfaction_score INT NULL,
    attachment_count INT NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
)

CREATE TABLE Ticket_Response (
    response_id INT PRIMARY KEY,
    ticket_id INT NOT NULL,
    admin_id INT NOT NULL,
    response_text VARCHAR(250) NOT NULL,
    response_date DATE NOT NULL,
    response_type VARCHAR(30) NULL,
    response_channel VARCHAR(30) NULL,
    response_time_minutes INT NULL,
    is_internal_note BIT NULL,
    response_status VARCHAR(20) NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL,
    additional_detail_5 VARCHAR(80) NULL,
    FOREIGN KEY (ticket_id) REFERENCES Support_Ticket(ticket_id),
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id)
)

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    subscription_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    feedback_text VARCHAR(250) NOT NULL,
    feedback_date DATE NOT NULL,
    feedback_category VARCHAR(40) NULL,
    app_version VARCHAR(20) NULL,
    device_type VARCHAR(30) NULL,
    resolved BIT NULL,
    follow_up_required BIT NULL,
    additional_detail_1 VARCHAR(80) NULL,
    additional_detail_2 VARCHAR(80) NULL,
    additional_detail_3 VARCHAR(80) NULL,
    additional_detail_4 VARCHAR(80) NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (subscription_id) REFERENCES Subscription(subscription_id)
)

-- INSERT SAMPLE VALUES
INSERT INTO Users VALUES (1, 'Ravi', 'Kumar', '1985-03-12', 'male', '9000000001', 'ravi.kumar1@example.com', '12 MG Road', 'Hyderabad', '2026-01-01', 'active', 'USA', '500001', '2026-01-01', 1)
INSERT INTO Users VALUES (2, 'Sita', 'Reddy', '1990-07-25', 'female', '9000000002', 'sita.reddy2@example.com', '45 Lake View', 'Chennai', '2026-01-02', 'inactive', 'United Kingdom', '500002', '2026-01-02', 0)
INSERT INTO Users VALUES (3, 'Arjun', 'Mehta', '1988-11-10', 'male', '9000000003', 'arjun.mehta3@example.com', '78 Green Park', 'Delhi', '2026-01-03', 'active', 'Singapore', '500003', '2026-01-03', 1)
INSERT INTO Users VALUES (4, 'Priya', 'Sharma', '1992-02-18', 'female', '9000000004', 'priya.sharma4@example.com', '23 Hill Street', 'Mumbai', '2026-01-04', 'inactive', 'Germany', '500004', '2026-01-04', 0)
INSERT INTO Users VALUES (5, 'Vikram', 'Singh', '1983-09-05', 'male', '9000000005', 'vikram.singh5@example.com', '56 River Road', 'Bangalore', '2026-01-05', 'active', 'India', '500005', '2026-01-05', 1)
INSERT INTO Users VALUES (6, 'Anita', 'Patel', '1995-12-30', 'female', '9000000006', 'anita.patel6@example.com', '89 Rose Colony', 'Ahmedabad', '2026-01-06', 'inactive', 'USA', '500006', '2026-01-06', 0)
INSERT INTO Users VALUES (7, 'Rahul', 'Joshi', '1987-04-14', 'male', '9000000007', 'rahul.joshi7@example.com', '34 Lotus Lane', 'Pune', '2026-01-07', 'active', 'United Kingdom', '500007', '2026-01-07', 1)
INSERT INTO Users VALUES (8, 'Neha', 'Gupta', '1993-08-22', 'female', '9000000008', 'neha.gupta8@example.com', '67 Pearl Street', 'Kolkata', '2026-01-08', 'inactive', 'Singapore', '500008', '2026-01-08', 0)
INSERT INTO Users VALUES (9, 'Karan', 'Nair', '1989-01-09', 'male', '9000000009', 'karan.nair9@example.com', '11 Palm Avenue', 'Trivandrum', '2026-01-09', 'active', 'Germany', '500009', '2026-01-09', 1)
INSERT INTO Users VALUES (10, 'Meena', 'Das', '1991-06-15', 'female', '9000000010', 'meena.das10@example.com', '90 Sunflower Road', 'Bhubaneswar', '2026-01-10', 'inactive', 'India', '500010', '2026-01-10', 0)
INSERT INTO Users VALUES (11, 'Rohan', 'Iyer', '1986-04-20', 'male', '9000000011', 'rohan.iyer11@example.com', '12 Ocean Drive', 'Mumbai', '2026-01-11', 'active', 'USA', '500011', '2026-01-11', 1)
INSERT INTO Users VALUES (12, 'Sneha', 'Kapoor', '1994-09-12', 'female', '9000000012', 'sneha.kapoor12@example.com', '45 Hill View', 'Delhi', '2026-01-12', 'inactive', 'United Kingdom', '500012', '2026-01-12', 0)
INSERT INTO Users VALUES (13, 'Manoj', 'Rao', '1988-02-05', 'male', '9000000013', 'manoj.rao13@example.com', '78 Lotus Street', 'Hyderabad', '2026-01-13', 'active', 'Singapore', '500013', '2026-01-13', 1)
INSERT INTO Users VALUES (14, 'Divya', 'Nair', '1992-07-19', 'female', '9000000014', 'divya.nair14@example.com', '23 Palm Road', 'Chennai', '2026-01-14', 'inactive', 'Germany', '500014', '2026-01-14', 0)
INSERT INTO Users VALUES (15, 'Suresh', 'Patel', '1983-11-01', 'male', '9000000015', 'suresh.patel15@example.com', '56 Rose Lane', 'Ahmedabad', '2026-01-15', 'active', 'India', '500015', '2026-01-15', 1)
INSERT INTO Users VALUES (16, 'Anjali', 'Shah', '1995-03-22', 'female', '9000000016', 'anjali.shah16@example.com', '89 Pearl Colony', 'Pune', '2026-01-16', 'inactive', 'USA', '500016', '2026-01-16', 0)
INSERT INTO Users VALUES (17, 'Kiran', 'Gupta', '1987-08-09', 'male', '9000000017', 'kiran.gupta17@example.com', '34 Sunflower Road', 'Kolkata', '2026-01-17', 'active', 'United Kingdom', '500017', '2026-01-17', 1)
INSERT INTO Users VALUES (18, 'Pooja', 'Das', '1993-12-14', 'female', '9000000018', 'pooja.das18@example.com', '67 Green Park', 'Bhubaneswar', '2026-01-18', 'inactive', 'Singapore', '500018', '2026-01-18', 0)
INSERT INTO Users VALUES (19, 'Vivek', 'Singh', '1989-05-25', 'male', '9000000019', 'vivek.singh19@example.com', '11 River Road', 'Lucknow', '2026-01-19', 'active', 'Germany', '500019', '2026-01-19', 1)
INSERT INTO Users VALUES (20, 'Kavita', 'Joshi', '1991-10-30', 'female', '9000000020', 'kavita.joshi20@example.com', '90 Lotus Avenue', 'Jaipur', '2026-01-20', 'inactive', 'India', '500020', '2026-01-20', 0)
INSERT INTO Users VALUES (21, 'Rajesh', 'Kumar', '1985-01-12', 'male', '9000000021', 'rajesh.kumar21@example.com', '12 Market Road', 'Hyderabad', '2026-01-21', 'active', 'USA', '500021', '2026-01-21', 1)
INSERT INTO Users VALUES (22, 'Sunita', 'Reddy', '1990-03-25', 'female', '9000000022', 'sunita.reddy22@example.com', '45 Lake View', 'Chennai', '2026-01-22', 'inactive', 'United Kingdom', '500022', '2026-01-22', 0)
INSERT INTO Users VALUES (23, 'Amit', 'Mehta', '1988-07-10', 'male', '9000000023', 'amit.mehta23@example.com', '78 Green Park', 'Delhi', '2026-01-23', 'active', 'Singapore', '500023', '2026-01-23', 1)
INSERT INTO Users VALUES (24, 'Lata', 'Sharma', '1992-11-18', 'female', '9000000024', 'lata.sharma24@example.com', '23 Hill Street', 'Mumbai', '2026-01-24', 'inactive', 'Germany', '500024', '2026-01-24', 0)
INSERT INTO Users VALUES (25, 'Deepak', 'Singh', '1983-05-05', 'male', '9000000025', 'deepak.singh25@example.com', '56 River Road', 'Bangalore', '2026-01-25', 'active', 'India', '500025', '2026-01-25', 1)
INSERT INTO Users VALUES (26, 'Rekha', 'Patel', '1995-09-30', 'female', '9000000026', 'rekha.patel26@example.com', '89 Rose Colony', 'Ahmedabad', '2026-01-26', 'inactive', 'USA', '500026', '2026-01-26', 0)
INSERT INTO Users VALUES (27, 'Sanjay', 'Joshi', '1987-12-14', 'male', '9000000027', 'sanjay.joshi27@example.com', '34 Lotus Lane', 'Pune', '2026-01-27', 'active', 'United Kingdom', '500027', '2026-01-27', 1)
INSERT INTO Users VALUES (28, 'Nisha', 'Gupta', '1993-04-22', 'female', '9000000028', 'nisha.gupta28@example.com', '67 Pearl Street', 'Kolkata', '2026-01-28', 'inactive', 'Singapore', '500028', '2026-01-28', 0)
INSERT INTO Users VALUES (29, 'Harish', 'Nair', '1989-08-09', 'male', '9000000029', 'harish.nair29@example.com', '11 Palm Avenue', 'Trivandrum', '2026-01-29', 'active', 'Germany', '500029', '2026-02-01', 1)
INSERT INTO Users VALUES (30, 'Shalini', 'Das', '1991-02-15', 'female', '9000000030', 'shalini.das30@example.com', '90 Sunflower Road', 'Bhubaneswar', '2026-01-30', 'inactive', 'India', '500030', '2026-02-02', 0)
INSERT INTO Users VALUES (31, 'Ajay', 'Kumar', '1986-03-12', 'male', '9000000031', 'ajay.kumar31@example.com', '12 MG Road', 'Hyderabad', '2026-01-31', 'active', 'USA', '500031', '2026-02-03', 1)
INSERT INTO Users VALUES (32, 'Radha', 'Reddy', '1990-07-25', 'female', '9000000032', 'radha.reddy32@example.com', '45 Lake View', 'Chennai', '2026-02-01', 'inactive', 'United Kingdom', '500032', '2026-02-04', 0)
INSERT INTO Users VALUES (33, 'Sandeep', 'Mehta', '1988-11-10', 'male', '9000000033', 'sandeep.mehta33@example.com', '78 Green Park', 'Delhi', '2026-02-02', 'active', 'Singapore', '500033', '2026-02-05', 1)
INSERT INTO Users VALUES (34, 'Geeta', 'Sharma', '1992-02-18', 'female', '9000000034', 'geeta.sharma34@example.com', '23 Hill Street', 'Mumbai', '2026-02-03', 'inactive', 'Germany', '500034', '2026-02-06', 0)
INSERT INTO Users VALUES (35, 'Mahesh', 'Singh', '1983-09-05', 'male', '9000000035', 'mahesh.singh35@example.com', '56 River Road', 'Bangalore', '2026-02-04', 'active', 'India', '500035', '2026-02-07', 1)
INSERT INTO Users VALUES (36, 'Kiran', 'Patel', '1995-12-30', 'female', '9000000036', 'kiran.patel36@example.com', '89 Rose Colony', 'Ahmedabad', '2026-02-05', 'inactive', 'USA', '500036', '2026-02-08', 0)
INSERT INTO Users VALUES (37, 'Ramesh', 'Joshi', '1987-04-14', 'male', '9000000037', 'ramesh.joshi37@example.com', '34 Lotus Lane', 'Pune', '2026-02-06', 'active', 'United Kingdom', '500037', '2026-02-09', 1)
INSERT INTO Users VALUES (38, 'Seema', 'Gupta', '1993-08-22', 'female', '9000000038', 'seema.gupta38@example.com', '67 Pearl Street', 'Kolkata', '2026-02-07', 'inactive', 'Singapore', '500038', '2026-02-10', 0)
INSERT INTO Users VALUES (39, 'Naveen', 'Nair', '1989-01-09', 'male', '9000000039', 'naveen.nair39@example.com', '11 Palm Avenue', 'Trivandrum', '2026-02-08', 'active', 'Germany', '500039', '2026-02-11', 1)
INSERT INTO Users VALUES (40, 'Pallavi', 'Das', '1991-06-15', 'female', '9000000040', 'pallavi.das40@example.com', '90 Sunflower Road', 'Bhubaneswar', '2026-02-09', 'inactive', 'India', '500040', '2026-02-12', 0)
INSERT INTO Users VALUES (41, 'Ashok', 'Kumar', '1985-07-12', 'male', '9000000041', 'ashok.kumar41@example.com', '12 Market Road', 'Hyderabad', '2026-02-10', 'active', 'USA', '500041', '2026-02-13', 1)
INSERT INTO Users VALUES (42, 'Meera', 'Reddy', '1990-09-25', 'female', '9000000042', 'meera.reddy42@example.com', '45 Lake View', 'Chennai', '2026-02-11', 'inactive', 'United Kingdom', '500042', '2026-02-14', 0)
INSERT INTO Users VALUES (43, 'Prakash', 'Mehta', '1988-01-10', 'male', '9000000043', 'prakash.mehta43@example.com', '78 Green Park', 'Delhi', '2026-02-12', 'active', 'Singapore', '500043', '2026-02-15', 1)
INSERT INTO Users VALUES (44, 'Savita', 'Sharma', '1992-05-18', 'female', '9000000044', 'savita.sharma44@example.com', '23 Hill Street', 'Mumbai', '2026-02-13', 'inactive', 'Germany', '500044', '2026-02-16', 0)
INSERT INTO Users VALUES (45, 'Gopal', 'Singh', '1983-10-05', 'male', '9000000045', 'gopal.singh45@example.com', '56 River Road', 'Bangalore', '2026-02-14', 'active', 'India', '500045', '2026-02-17', 1)
INSERT INTO Users VALUES (46, 'Leela', 'Patel', '1995-01-30', 'female', '9000000046', 'leela.patel46@example.com', '89 Rose Colony', 'Ahmedabad', '2026-02-15', 'inactive', 'USA', '500046', '2026-02-18', 0)
INSERT INTO Users VALUES (47, 'Suraj', 'Joshi', '1987-06-14', 'male', '9000000047', 'suraj.joshi47@example.com', '34 Lotus Lane', 'Pune', '2026-02-16', 'active', 'United Kingdom', '500047', '2026-02-19', 1)
INSERT INTO Users VALUES (48, 'Ritu', 'Gupta', '1993-12-22', 'female', '9000000048', 'ritu.gupta48@example.com', '67 Pearl Street', 'Kolkata', '2026-02-17', 'inactive', 'Singapore', '500048', '2026-02-20', 0)
INSERT INTO Users VALUES (49, 'Anand', 'Nair', '1989-03-09', 'male', '9000000049', 'anand.nair49@example.com', '11 Palm Avenue', 'Trivandrum', '2026-02-18', 'active', 'Germany', '500049', '2026-02-21', 1)
INSERT INTO Users VALUES (50, 'Shobha', 'Das', '1991-08-15', 'female', '9000000050', 'shobha.das50@example.com', '90 Sunflower Road', 'Bhubaneswar', '2026-02-19', 'inactive', 'India', '500050', '2026-02-22', 0)

INSERT INTO User_Profile VALUES (1, 1, 'ravi_kumar', 'Ravi@123', 'active', 'OpenVPN', '2026-01-01', '2026-01-01', 2, 1, 'profile_note record 01', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01')
INSERT INTO User_Profile VALUES (2, 2, 'sita_reddy', 'Sita@123', 'active', 'WireGuard', '2026-01-02', '2026-01-02', 3, 0, 'profile_note record 02', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02')
INSERT INTO User_Profile VALUES (3, 3, 'arjun_mehta', 'Arjun@123', 'active', 'IKEv2', '2026-01-03', '2026-01-03', 4, 1, 'profile_note record 03', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03')
INSERT INTO User_Profile VALUES (4, 4, 'priya_sharma', 'Priya@123', 'active', 'WireGuard', '2026-01-04', '2026-01-04', 5, 0, 'profile_note record 04', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04')
INSERT INTO User_Profile VALUES (5, 5, 'vikram_singh', 'Vikram@123', 'inactive', 'OpenVPN', '2026-01-05', '2026-01-05', 6, 1, 'profile_note record 05', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05')
INSERT INTO User_Profile VALUES (6, 6, 'anita_patel', 'Anita@123', 'active', 'IKEv2', '2026-01-06', '2026-01-06', 7, 0, 'profile_note record 06', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06')
INSERT INTO User_Profile VALUES (7, 7, 'rahul_joshi', 'Rahul@123', 'active', 'WireGuard', '2026-01-07', '2026-01-07', 8, 1, 'profile_note record 07', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07')
INSERT INTO User_Profile VALUES (8, 8, 'neha_gupta', 'Neha@123', 'active', 'OpenVPN', '2026-01-08', '2026-01-08', 9, 0, 'profile_note record 08', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08')
INSERT INTO User_Profile VALUES (9, 9, 'karan_nair', 'Karan@123', 'inactive', 'IKEv2', '2026-01-09', '2026-01-09', 10, 1, 'profile_note record 09', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09')
INSERT INTO User_Profile VALUES (10, 10, 'meena_das', 'Meena@123', 'active', 'WireGuard', '2026-01-10', '2026-01-10', 1, 0, 'profile_note record 10', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10')
INSERT INTO User_Profile VALUES (11, 11, 'rohan_iyer', 'Rohan@123', 'active', 'OpenVPN', '2026-01-11', '2026-01-11', 2, 1, 'profile_note record 11', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11')
INSERT INTO User_Profile VALUES (12, 12, 'sneha_kapoor', 'Sneha@123', 'active', 'WireGuard', '2026-01-12', '2026-01-12', 3, 0, 'profile_note record 12', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12')
INSERT INTO User_Profile VALUES (13, 13, 'manoj_rao', 'Manoj@123', 'inactive', 'IKEv2', '2026-01-13', '2026-01-13', 4, 1, 'profile_note record 13', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13')
INSERT INTO User_Profile VALUES (14, 14, 'divya_nair', 'Divya@123', 'active', 'OpenVPN', '2026-01-14', '2026-01-14', 5, 0, 'profile_note record 14', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14')
INSERT INTO User_Profile VALUES (15, 15, 'suresh_patel', 'Suresh@123', 'active', 'WireGuard', '2026-01-15', '2026-01-15', 6, 1, 'profile_note record 15', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15')
INSERT INTO User_Profile VALUES (16, 16, 'anjali_shah', 'Anjali@123', 'active', 'IKEv2', '2026-01-16', '2026-01-16', 7, 0, 'profile_note record 16', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16')
INSERT INTO User_Profile VALUES (17, 17, 'kiran_gupta', 'Kiran@123', 'inactive', 'OpenVPN', '2026-01-17', '2026-01-17', 8, 1, 'profile_note record 17', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17')
INSERT INTO User_Profile VALUES (18, 18, 'pooja_das', 'Pooja@123', 'active', 'WireGuard', '2026-01-18', '2026-01-18', 9, 0, 'profile_note record 18', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18')
INSERT INTO User_Profile VALUES (19, 19, 'vivek_singh', 'Vivek@123', 'active', 'IKEv2', '2026-01-19', '2026-01-19', 10, 1, 'profile_note record 19', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19')
INSERT INTO User_Profile VALUES (20, 20, 'kavita_joshi', 'Kavita@123', 'active', 'OpenVPN', '2026-01-20', '2026-01-20', 1, 0, 'profile_note record 20', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20')
INSERT INTO User_Profile VALUES (21, 21, 'rajesh_kumar', 'Rajesh@123', 'inactive', 'WireGuard', '2026-01-21', '2026-01-21', 2, 1, 'profile_note record 21', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21')
INSERT INTO User_Profile VALUES (22, 22, 'sunita_reddy', 'Sunita@123', 'active', 'IKEv2', '2026-01-22', '2026-01-22', 3, 0, 'profile_note record 22', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22')
INSERT INTO User_Profile VALUES (23, 23, 'amit_mehta', 'Amit@123', 'active', 'OpenVPN', '2026-01-23', '2026-01-23', 4, 1, 'profile_note record 23', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23')
INSERT INTO User_Profile VALUES (24, 24, 'lata_sharma', 'Lata@123', 'active', 'WireGuard', '2026-01-24', '2026-01-24', 5, 0, 'profile_note record 24', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24')
INSERT INTO User_Profile VALUES (25, 25, 'deepak_singh', 'Deepak@123', 'inactive', 'IKEv2', '2026-01-25', '2026-01-25', 6, 1, 'profile_note record 25', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25')
INSERT INTO User_Profile VALUES (26, 26, 'rekha_patel', 'Rekha@123', 'active', 'OpenVPN', '2026-01-26', '2026-01-26', 7, 0, 'profile_note record 26', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26')
INSERT INTO User_Profile VALUES (27, 27, 'sanjay_joshi', 'Sanjay@123', 'active', 'WireGuard', '2026-01-27', '2026-01-27', 8, 1, 'profile_note record 27', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27')
INSERT INTO User_Profile VALUES (28, 28, 'nisha_gupta', 'Nisha@123', 'active', 'IKEv2', '2026-01-28', '2026-01-28', 9, 0, 'profile_note record 28', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28')
INSERT INTO User_Profile VALUES (29, 29, 'harish_nair', 'Harish@123', 'inactive', 'OpenVPN', '2026-02-01', '2026-02-01', 10, 1, 'profile_note record 29', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29')
INSERT INTO User_Profile VALUES (30, 30, 'shalini_das', 'Shalini@123', 'active', 'WireGuard', '2026-02-02', '2026-02-02', 1, 0, 'profile_note record 30', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30')
INSERT INTO User_Profile VALUES (31, 31, 'ajay_kumar', 'Ajay@123', 'active', 'IKEv2', '2026-02-03', '2026-02-03', 2, 1, 'profile_note record 31', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31')
INSERT INTO User_Profile VALUES (32, 32, 'radha_reddy', 'Radha@123', 'active', 'OpenVPN', '2026-02-04', '2026-02-04', 3, 0, 'profile_note record 32', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32')
INSERT INTO User_Profile VALUES (33, 33, 'sandeep_mehta', 'Sandeep@123', 'inactive', 'WireGuard', '2026-02-05', '2026-02-05', 4, 1, 'profile_note record 33', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33')
INSERT INTO User_Profile VALUES (34, 34, 'geeta_sharma', 'Geeta@123', 'active', 'IKEv2', '2026-02-06', '2026-02-06', 5, 0, 'profile_note record 34', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34')
INSERT INTO User_Profile VALUES (35, 35, 'mahesh_singh', 'Mahesh@123', 'active', 'OpenVPN', '2026-02-07', '2026-02-07', 6, 1, 'profile_note record 35', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35')
INSERT INTO User_Profile VALUES (36, 36, 'kiran_patel', 'Kiran@456', 'active', 'WireGuard', '2026-02-08', '2026-02-08', 7, 0, 'profile_note record 36', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36')
INSERT INTO User_Profile VALUES (37, 37, 'ramesh_joshi', 'Ramesh@123', 'inactive', 'IKEv2', '2026-02-09', '2026-02-09', 8, 1, 'profile_note record 37', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37')
INSERT INTO User_Profile VALUES (38, 38, 'seema_gupta', 'Seema@123', 'active', 'OpenVPN', '2026-02-10', '2026-02-10', 9, 0, 'profile_note record 38', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38')
INSERT INTO User_Profile VALUES (39, 39, 'naveen_nair', 'Naveen@123', 'active', 'WireGuard', '2026-02-11', '2026-02-11', 10, 1, 'profile_note record 39', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39')
INSERT INTO User_Profile VALUES (40, 40, 'pallavi_das', 'Pallavi@123', 'active', 'IKEv2', '2026-02-12', '2026-02-12', 1, 0, 'profile_note record 40', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40')
INSERT INTO User_Profile VALUES (41, 41, 'ashok_kumar', 'Ashok@123', 'inactive', 'OpenVPN', '2026-02-13', '2026-02-13', 2, 1, 'profile_note record 41', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41')
INSERT INTO User_Profile VALUES (42, 42, 'meera_reddy', 'Meera@123', 'active', 'WireGuard', '2026-02-14', '2026-02-14', 3, 0, 'profile_note record 42', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42')
INSERT INTO User_Profile VALUES (43, 43, 'prakash_mehta', 'Prakash@123', 'active', 'IKEv2', '2026-02-15', '2026-02-15', 4, 1, 'profile_note record 43', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43')
INSERT INTO User_Profile VALUES (44, 44, 'savita_sharma', 'Savita@123', 'active', 'OpenVPN', '2026-02-16', '2026-02-16', 5, 0, 'profile_note record 44', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44')
INSERT INTO User_Profile VALUES (45, 45, 'gopal_singh', 'Gopal@123', 'inactive', 'WireGuard', '2026-02-17', '2026-02-17', 6, 1, 'profile_note record 45', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45')
INSERT INTO User_Profile VALUES (46, 46, 'leela_patel', 'Leela@123', 'active', 'IKEv2', '2026-02-18', '2026-02-18', 7, 0, 'profile_note record 46', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46')
INSERT INTO User_Profile VALUES (47, 47, 'suraj_joshi', 'Suraj@123', 'active', 'OpenVPN', '2026-02-19', '2026-02-19', 8, 1, 'profile_note record 47', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47')
INSERT INTO User_Profile VALUES (48, 48, 'ritu_gupta', 'Ritu@123', 'active', 'WireGuard', '2026-02-20', '2026-02-20', 9, 0, 'profile_note record 48', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48')
INSERT INTO User_Profile VALUES (49, 49, 'anand_nair', 'Anand@123', 'inactive', 'IKEv2', '2026-02-21', '2026-02-21', 10, 1, 'profile_note record 49', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49')
INSERT INTO User_Profile VALUES (50, 50, 'shobha_das', 'Shobha@123', 'active', 'OpenVPN', '2026-02-22', '2026-02-22', 1, 0, 'profile_note record 50', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50')

INSERT INTO Admin VALUES (1, 'Amit', 'Sharma', 'amit.sharma1@vpndb.com', '9100000001', 'System Admin', 'active', '2026-01-01', 'Network Security', 2, '2026-01-01', 1, 'admin_note record 01', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01')
INSERT INTO Admin VALUES (2, 'Priya', 'Reddy', 'priya.reddy2@vpndb.com', '9100000002', 'Network Admin', 'active', '2026-01-02', 'IT Support', 3, '2026-01-02', 0, 'admin_note record 02', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02')
INSERT INTO Admin VALUES (3, 'Rahul', 'Kumar', 'rahul.kumar3@vpndb.com', '9100000003', 'Security Admin', 'active', '2026-01-03', 'Finance', 4, '2026-01-03', 1, 'admin_note record 03', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03')
INSERT INTO Admin VALUES (4, 'Sneha', 'Patel', 'sneha.patel4@vpndb.com', '9100000004', 'Server Admin', 'active', '2026-01-04', 'Operations', 5, '2026-01-04', 0, 'admin_note record 04', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04')
INSERT INTO Admin VALUES (5, 'Vikram', 'Singh', 'vikram.singh5@vpndb.com', '9100000005', 'System Admin', 'inactive', '2026-01-05', 'Network Security', 6, '2026-01-05', 1, 'admin_note record 05', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05')
INSERT INTO Admin VALUES (6, 'Anjali', 'Shah', 'anjali.shah6@vpndb.com', '9100000006', 'Network Admin', 'active', '2026-01-06', 'IT Support', 7, '2026-01-06', 0, 'admin_note record 06', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06')
INSERT INTO Admin VALUES (7, 'Karan', 'Mehta', 'karan.mehta7@vpndb.com', '9100000007', 'Security Admin', 'active', '2026-01-07', 'Finance', 8, '2026-01-07', 1, 'admin_note record 07', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07')
INSERT INTO Admin VALUES (8, 'Neha', 'Gupta', 'neha.gupta8@vpndb.com', '9100000008', 'Server Admin', 'active', '2026-01-08', 'Operations', 9, '2026-01-08', 0, 'admin_note record 08', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08')
INSERT INTO Admin VALUES (9, 'Arjun', 'Nair', 'arjun.nair9@vpndb.com', '9100000009', 'System Admin', 'inactive', '2026-01-09', 'Network Security', 10, '2026-01-09', 1, 'admin_note record 09', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09')
INSERT INTO Admin VALUES (10, 'Divya', 'Das', 'divya.das10@vpndb.com', '9100000010', 'Network Admin', 'active', '2026-01-10', 'IT Support', 1, '2026-01-10', 0, 'admin_note record 10', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10')
INSERT INTO Admin VALUES (11, 'Rohan', 'Iyer', 'rohan.iyer11@vpndb.com', '9100000011', 'Security Admin', 'active', '2026-01-11', 'Finance', 2, '2026-01-11', 1, 'admin_note record 11', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11')
INSERT INTO Admin VALUES (12, 'Meena', 'Kapoor', 'meena.kapoor12@vpndb.com', '9100000012', 'Server Admin', 'active', '2026-01-12', 'Operations', 3, '2026-01-12', 0, 'admin_note record 12', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12')
INSERT INTO Admin VALUES (13, 'Suresh', 'Rao', 'suresh.rao13@vpndb.com', '9100000013', 'System Admin', 'inactive', '2026-01-13', 'Network Security', 4, '2026-01-13', 1, 'admin_note record 13', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13')
INSERT INTO Admin VALUES (14, 'Pooja', 'Nair', 'pooja.nair14@vpndb.com', '9100000014', 'Network Admin', 'active', '2026-01-14', 'IT Support', 5, '2026-01-14', 0, 'admin_note record 14', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14')
INSERT INTO Admin VALUES (15, 'Manoj', 'Patel', 'manoj.patel15@vpndb.com', '9100000015', 'Security Admin', 'active', '2026-01-15', 'Finance', 6, '2026-01-15', 1, 'admin_note record 15', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15')
INSERT INTO Admin VALUES (16, 'Kavita', 'Shah', 'kavita.shah16@vpndb.com', '9100000016', 'Server Admin', 'active', '2026-01-16', 'Operations', 7, '2026-01-16', 0, 'admin_note record 16', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16')
INSERT INTO Admin VALUES (17, 'Vivek', 'Gupta', 'vivek.gupta17@vpndb.com', '9100000017', 'System Admin', 'inactive', '2026-01-17', 'Network Security', 8, '2026-01-17', 1, 'admin_note record 17', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17')
INSERT INTO Admin VALUES (18, 'Ritu', 'Das', 'ritu.das18@vpndb.com', '9100000018', 'Network Admin', 'active', '2026-01-18', 'IT Support', 9, '2026-01-18', 0, 'admin_note record 18', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18')
INSERT INTO Admin VALUES (19, 'Sanjay', 'Joshi', 'sanjay.joshi19@vpndb.com', '9100000019', 'Security Admin', 'active', '2026-01-19', 'Finance', 10, '2026-01-19', 1, 'admin_note record 19', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19')
INSERT INTO Admin VALUES (20, 'Nisha', 'Verma', 'nisha.verma20@vpndb.com', '9100000020', 'Server Admin', 'active', '2026-01-20', 'Operations', 1, '2026-01-20', 0, 'admin_note record 20', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20')
INSERT INTO Admin VALUES (21, 'Rajesh', 'Kumar', 'rajesh.kumar21@vpndb.com', '9100000021', 'System Admin', 'inactive', '2026-01-21', 'Network Security', 2, '2026-01-21', 1, 'admin_note record 21', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21')
INSERT INTO Admin VALUES (22, 'Sunita', 'Reddy', 'sunita.reddy22@vpndb.com', '9100000022', 'Network Admin', 'active', '2026-01-22', 'IT Support', 3, '2026-01-22', 0, 'admin_note record 22', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22')
INSERT INTO Admin VALUES (23, 'Amit', 'Mehta', 'amit.mehta23@vpndb.com', '9100000023', 'Security Admin', 'active', '2026-01-23', 'Finance', 4, '2026-01-23', 1, 'admin_note record 23', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23')
INSERT INTO Admin VALUES (24, 'Lata', 'Sharma', 'lata.sharma24@vpndb.com', '9100000024', 'Server Admin', 'active', '2026-01-24', 'Operations', 5, '2026-01-24', 0, 'admin_note record 24', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24')
INSERT INTO Admin VALUES (25, 'Deepak', 'Singh', 'deepak.singh25@vpndb.com', '9100000025', 'System Admin', 'inactive', '2026-01-25', 'Network Security', 6, '2026-01-25', 1, 'admin_note record 25', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25')
INSERT INTO Admin VALUES (26, 'Rekha', 'Patel', 'rekha.patel26@vpndb.com', '9100000026', 'Network Admin', 'active', '2026-01-26', 'IT Support', 7, '2026-01-26', 0, 'admin_note record 26', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26')
INSERT INTO Admin VALUES (27, 'Sanjay', 'Joshi', 'sanjay.joshi27@vpndb.com', '9100000027', 'Security Admin', 'active', '2026-01-27', 'Finance', 8, '2026-01-27', 1, 'admin_note record 27', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27')
INSERT INTO Admin VALUES (28, 'Nisha', 'Gupta', 'nisha.gupta28@vpndb.com', '9100000028', 'Server Admin', 'active', '2026-01-28', 'Operations', 9, '2026-01-28', 0, 'admin_note record 28', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28')
INSERT INTO Admin VALUES (29, 'Harish', 'Nair', 'harish.nair29@vpndb.com', '9100000029', 'System Admin', 'inactive', '2026-01-29', 'Network Security', 10, '2026-02-01', 1, 'admin_note record 29', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29')
INSERT INTO Admin VALUES (30, 'Shalini', 'Das', 'shalini.das30@vpndb.com', '9100000030', 'Network Admin', 'active', '2026-01-30', 'IT Support', 1, '2026-02-02', 0, 'admin_note record 30', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30')
INSERT INTO Admin VALUES (31, 'Ajay', 'Kumar', 'ajay.kumar31@vpndb.com', '9100000031', 'Security Admin', 'active', '2026-01-31', 'Finance', 2, '2026-02-03', 1, 'admin_note record 31', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31')
INSERT INTO Admin VALUES (32, 'Radha', 'Reddy', 'radha.reddy32@vpndb.com', '9100000032', 'Server Admin', 'active', '2026-02-01', 'Operations', 3, '2026-02-04', 0, 'admin_note record 32', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32')
INSERT INTO Admin VALUES (33, 'Sandeep', 'Mehta', 'sandeep.mehta33@vpndb.com', '9100000033', 'System Admin', 'inactive', '2026-02-02', 'Network Security', 4, '2026-02-05', 1, 'admin_note record 33', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33')
INSERT INTO Admin VALUES (34, 'Geeta', 'Sharma', 'geeta.sharma34@vpndb.com', '9100000034', 'Network Admin', 'active', '2026-02-03', 'IT Support', 5, '2026-02-06', 0, 'admin_note record 34', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34')
INSERT INTO Admin VALUES (35, 'Mahesh', 'Singh', 'mahesh.singh35@vpndb.com', '9100000035', 'Security Admin', 'active', '2026-02-04', 'Finance', 6, '2026-02-07', 1, 'admin_note record 35', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35')
INSERT INTO Admin VALUES (36, 'Kiran', 'Patel', 'kiran.patel36@vpndb.com', '9100000036', 'Server Admin', 'active', '2026-02-05', 'Operations', 7, '2026-02-08', 0, 'admin_note record 36', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36')
INSERT INTO Admin VALUES (37, 'Ramesh', 'Joshi', 'ramesh.joshi37@vpndb.com', '9100000037', 'System Admin', 'inactive', '2026-02-06', 'Network Security', 8, '2026-02-09', 1, 'admin_note record 37', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37')
INSERT INTO Admin VALUES (38, 'Seema', 'Gupta', 'seema.gupta38@vpndb.com', '9100000038', 'Network Admin', 'active', '2026-02-07', 'IT Support', 9, '2026-02-10', 0, 'admin_note record 38', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38')
INSERT INTO Admin VALUES (39, 'Naveen', 'Nair', 'naveen.nair39@vpndb.com', '9100000039', 'Security Admin', 'active', '2026-02-08', 'Finance', 10, '2026-02-11', 1, 'admin_note record 39', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39')
INSERT INTO Admin VALUES (40, 'Pallavi', 'Das', 'pallavi.das40@vpndb.com', '9100000040', 'Server Admin', 'active', '2026-02-09', 'Operations', 1, '2026-02-12', 0, 'admin_note record 40', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40')
INSERT INTO Admin VALUES (41, 'Ashok', 'Kumar', 'ashok.kumar41@vpndb.com', '9100000041', 'System Admin', 'inactive', '2026-02-10', 'Network Security', 2, '2026-02-13', 1, 'admin_note record 41', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41')
INSERT INTO Admin VALUES (42, 'Meera', 'Reddy', 'meera.reddy42@vpndb.com', '9100000042', 'Network Admin', 'active', '2026-02-11', 'IT Support', 3, '2026-02-14', 0, 'admin_note record 42', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42')
INSERT INTO Admin VALUES (43, 'Prakash', 'Mehta', 'prakash.mehta43@vpndb.com', '9100000043', 'Security Admin', 'active', '2026-02-12', 'Finance', 4, '2026-02-15', 1, 'admin_note record 43', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43')
INSERT INTO Admin VALUES (44, 'Savita', 'Sharma', 'savita.sharma44@vpndb.com', '9100000044', 'Server Admin', 'active', '2026-02-13', 'Operations', 5, '2026-02-16', 0, 'admin_note record 44', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44')
INSERT INTO Admin VALUES (45, 'Gopal', 'Singh', 'gopal.singh45@vpndb.com', '9100000045', 'System Admin', 'inactive', '2026-02-14', 'Network Security', 6, '2026-02-17', 1, 'admin_note record 45', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45')
INSERT INTO Admin VALUES (46, 'Leela', 'Patel', 'leela.patel46@vpndb.com', '9100000046', 'Network Admin', 'active', '2026-02-15', 'IT Support', 7, '2026-02-18', 0, 'admin_note record 46', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46')
INSERT INTO Admin VALUES (47, 'Suraj', 'Joshi', 'suraj.joshi47@vpndb.com', '9100000047', 'Security Admin', 'active', '2026-02-16', 'Finance', 8, '2026-02-19', 1, 'admin_note record 47', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47')
INSERT INTO Admin VALUES (48, 'Ritu', 'Gupta', 'ritu.gupta48@vpndb.com', '9100000048', 'Server Admin', 'active', '2026-02-17', 'Operations', 9, '2026-02-20', 0, 'admin_note record 48', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48')
INSERT INTO Admin VALUES (49, 'Anand', 'Nair', 'anand.nair49@vpndb.com', '9100000049', 'System Admin', 'inactive', '2026-02-18', 'Network Security', 10, '2026-02-21', 1, 'admin_note record 49', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49')
INSERT INTO Admin VALUES (50, 'Shobha', 'Das', 'shobha.das50@vpndb.com', '9100000050', 'Network Admin', 'active', '2026-02-19', 'IT Support', 1, '2026-02-22', 0, 'admin_note record 50', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50')

INSERT INTO Server_Location VALUES (1, 'Hyderabad Central', 'India', 'Hyderabad', 'Telangana', 'HYD-DC01', -39.000000, -79.000000, 'UTC', 600, 'normal', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01')
INSERT INTO Server_Location VALUES (2, 'Mumbai Central', 'India', 'Mumbai', 'Maharashtra', 'MUM-DC01', -38.000000, -78.000000, 'Europe/London', 700, 'enabled', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02')
INSERT INTO Server_Location VALUES (3, 'Bangalore Tech Park', 'India', 'Bangalore', 'Karnataka', 'BLR-DC01', -37.000000, -77.000000, 'America/New_York', 800, 'available', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03')
INSERT INTO Server_Location VALUES (4, 'Chennai IT Hub', 'India', 'Chennai', 'Tamil Nadu', 'CHE-DC01', -36.000000, -76.000000, 'Asia/Singapore', 900, 'active', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04')
INSERT INTO Server_Location VALUES (5, 'Delhi Data Center', 'India', 'Delhi', 'Delhi', 'DEL-DC01', -35.000000, -75.000000, 'Asia/Kolkata', 1000, 'normal', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05')
INSERT INTO Server_Location VALUES (6, 'Pune IT Center', 'India', 'Pune', 'Maharashtra', 'PUN-DC01', -34.000000, -74.000000, 'UTC', 1100, 'enabled', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06')
INSERT INTO Server_Location VALUES (7, 'Kolkata Data Center', 'India', 'Kolkata', 'West Bengal', 'KOL-DC01', -33.000000, -73.000000, 'Europe/London', 1200, 'available', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07')
INSERT INTO Server_Location VALUES (8, 'Ahmedabad Data Center', 'India', 'Ahmedabad', 'Gujarat', 'AHM-DC01', -32.000000, -72.000000, 'America/New_York', 1300, 'active', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08')
INSERT INTO Server_Location VALUES (9, 'Visakhapatnam Center', 'India', 'Visakhapatnam', 'Andhra Pradesh', 'VIZ-DC01', -31.000000, -71.000000, 'Asia/Singapore', 1400, 'normal', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09')
INSERT INTO Server_Location VALUES (10, 'Vijayawada Center', 'India', 'Vijayawada', 'Andhra Pradesh', 'VJA-DC01', -30.000000, -70.000000, 'Asia/Kolkata', 1500, 'enabled', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10')
INSERT INTO Server_Location VALUES (11, 'New York Center', 'USA', 'New York', 'New York', 'NYC-DC01', -29.000000, -69.000000, 'UTC', 1600, 'available', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11')
INSERT INTO Server_Location VALUES (12, 'Los Angeles Center', 'USA', 'Los Angeles', 'California', 'LAX-DC01', -28.000000, -68.000000, 'Europe/London', 1700, 'active', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12')
INSERT INTO Server_Location VALUES (13, 'Chicago Center', 'USA', 'Chicago', 'Illinois', 'CHI-DC01', -27.000000, -67.000000, 'America/New_York', 1800, 'normal', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13')
INSERT INTO Server_Location VALUES (14, 'Dallas Center', 'USA', 'Dallas', 'Texas', 'DAL-DC01', -26.000000, -66.000000, 'Asia/Singapore', 1900, 'enabled', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14')
INSERT INTO Server_Location VALUES (15, 'Seattle Center', 'USA', 'Seattle', 'Washington', 'SEA-DC01', -25.000000, -65.000000, 'Asia/Kolkata', 2000, 'available', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15')
INSERT INTO Server_Location VALUES (16, 'London Center', 'UK', 'London', 'England', 'LON-DC01', -24.000000, -64.000000, 'UTC', 2100, 'active', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16')
INSERT INTO Server_Location VALUES (17, 'Manchester Center', 'UK', 'Manchester', 'England', 'MAN-DC01', -23.000000, -63.000000, 'Europe/London', 2200, 'normal', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17')
INSERT INTO Server_Location VALUES (18, 'Frankfurt Center', 'Germany', 'Frankfurt', 'Hesse', 'FRA-DC01', -22.000000, -62.000000, 'America/New_York', 2300, 'enabled', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18')
INSERT INTO Server_Location VALUES (19, 'Berlin Center', 'Germany', 'Berlin', 'Berlin', 'BER-DC01', -21.000000, -61.000000, 'Asia/Singapore', 2400, 'available', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19')
INSERT INTO Server_Location VALUES (20, 'Paris Center', 'France', 'Paris', 'Ile-de-France', 'PAR-DC01', -20.000000, -60.000000, 'Asia/Kolkata', 2500, 'active', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20')
INSERT INTO Server_Location VALUES (21, 'Toronto Center', 'Canada', 'Toronto', 'Ontario', 'TOR-DC01', -19.000000, -59.000000, 'UTC', 2600, 'normal', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21')
INSERT INTO Server_Location VALUES (22, 'Vancouver Center', 'Canada', 'Vancouver', 'British Columbia', 'VAN-DC01', -18.000000, -58.000000, 'Europe/London', 2700, 'enabled', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22')
INSERT INTO Server_Location VALUES (23, 'Singapore Center', 'Singapore', 'Singapore', 'Central', 'SIN-DC01', -17.000000, -57.000000, 'America/New_York', 2800, 'available', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23')
INSERT INTO Server_Location VALUES (24, 'Tokyo Center', 'Japan', 'Tokyo', 'Kanto', 'TOK-DC01', -16.000000, -56.000000, 'Asia/Singapore', 2900, 'active', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24')
INSERT INTO Server_Location VALUES (25, 'Osaka Center', 'Japan', 'Osaka', 'Kansai', 'OSA-DC01', -15.000000, -55.000000, 'Asia/Kolkata', 3000, 'normal', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25')
INSERT INTO Server_Location VALUES (26, 'Seoul Center', 'South Korea', 'Seoul', 'Seoul', 'SEL-DC01', -14.000000, -54.000000, 'UTC', 3100, 'enabled', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26')
INSERT INTO Server_Location VALUES (27, 'Sydney Center', 'Australia', 'Sydney', 'New South Wales', 'SYD-DC01', -13.000000, -53.000000, 'Europe/London', 3200, 'available', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27')
INSERT INTO Server_Location VALUES (28, 'Melbourne Center', 'Australia', 'Melbourne', 'Victoria', 'MEL-DC01', -12.000000, -52.000000, 'America/New_York', 3300, 'active', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28')
INSERT INTO Server_Location VALUES (29, 'Dubai Center', 'UAE', 'Dubai', 'Dubai', 'DXB-DC01', -11.000000, -51.000000, 'Asia/Singapore', 3400, 'normal', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29')
INSERT INTO Server_Location VALUES (30, 'Abu Dhabi Center', 'UAE', 'Abu Dhabi', 'Abu Dhabi', 'AUH-DC01', -10.000000, -50.000000, 'Asia/Kolkata', 3500, 'enabled', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30')
INSERT INTO Server_Location VALUES (31, 'Amsterdam Center', 'Netherlands', 'Amsterdam', 'North Holland', 'AMS-DC01', -9.000000, -49.000000, 'UTC', 3600, 'available', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31')
INSERT INTO Server_Location VALUES (32, 'Zurich Center', 'Switzerland', 'Zurich', 'Zurich', 'ZRH-DC01', -8.000000, -48.000000, 'Europe/London', 3700, 'active', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32')
INSERT INTO Server_Location VALUES (33, 'Stockholm Center', 'Sweden', 'Stockholm', 'Stockholm', 'STO-DC01', -7.000000, -47.000000, 'America/New_York', 3800, 'normal', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33')
INSERT INTO Server_Location VALUES (34, 'Oslo Center', 'Norway', 'Oslo', 'Oslo', 'OSL-DC01', -6.000000, -46.000000, 'Asia/Singapore', 3900, 'enabled', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34')
INSERT INTO Server_Location VALUES (35, 'Copenhagen Center', 'Denmark', 'Copenhagen', 'Capital', 'CPH-DC01', -5.000000, -45.000000, 'Asia/Kolkata', 4000, 'available', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35')
INSERT INTO Server_Location VALUES (36, 'Madrid Center', 'Spain', 'Madrid', 'Madrid', 'MAD-DC01', -4.000000, -44.000000, 'UTC', 4100, 'active', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36')
INSERT INTO Server_Location VALUES (37, 'Rome Center', 'Italy', 'Rome', 'Lazio', 'ROM-DC01', -3.000000, -43.000000, 'Europe/London', 4200, 'normal', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37')
INSERT INTO Server_Location VALUES (38, 'Milan Center', 'Italy', 'Milan', 'Lombardy', 'MIL-DC01', -2.000000, -42.000000, 'America/New_York', 4300, 'enabled', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38')
INSERT INTO Server_Location VALUES (39, 'São Paulo Center', 'Brazil', 'São Paulo', 'São Paulo', 'SAO-DC01', -1.000000, -41.000000, 'Asia/Singapore', 4400, 'available', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39')
INSERT INTO Server_Location VALUES (40, 'Mexico City Center', 'Mexico', 'Mexico City', 'Mexico City', 'MEX-DC01', 0.000000, -40.000000, 'Asia/Kolkata', 4500, 'active', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40')
INSERT INTO Server_Location VALUES (41, 'Johannesburg Center', 'South Africa', 'Johannesburg', 'Gauteng', 'JNB-DC01', 1.000000, -39.000000, 'UTC', 4600, 'normal', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41')
INSERT INTO Server_Location VALUES (42, 'Cape Town Center', 'South Africa', 'Cape Town', 'Western Cape', 'CPT-DC01', 2.000000, -38.000000, 'Europe/London', 4700, 'enabled', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42')
INSERT INTO Server_Location VALUES (43, 'Moscow Center', 'Russia', 'Moscow', 'Moscow', 'MOS-DC01', 3.000000, -37.000000, 'America/New_York', 4800, 'available', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43')
INSERT INTO Server_Location VALUES (44, 'Istanbul Center', 'Turkey', 'Istanbul', 'Istanbul', 'IST-DC01', 4.000000, -36.000000, 'Asia/Singapore', 4900, 'active', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44')
INSERT INTO Server_Location VALUES (45, 'Hong Kong Center', 'Hong Kong', 'Hong Kong', 'Central', 'HKG-DC01', 5.000000, -35.000000, 'Asia/Kolkata', 5000, 'normal', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45')
INSERT INTO Server_Location VALUES (46, 'Taipei Center', 'Taiwan', 'Taipei', 'Taipei', 'TPE-DC01', 6.000000, -34.000000, 'UTC', 5100, 'enabled', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46')
INSERT INTO Server_Location VALUES (47, 'Bangkok Center', 'Thailand', 'Bangkok', 'Bangkok', 'BKK-DC01', 7.000000, -33.000000, 'Europe/London', 5200, 'available', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47')
INSERT INTO Server_Location VALUES (48, 'Jakarta Center', 'Indonesia', 'Jakarta', 'Jakarta', 'JKT-DC01', 8.000000, -32.000000, 'America/New_York', 5300, 'active', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48')
INSERT INTO Server_Location VALUES (49, 'Kuala Lumpur Center', 'Malaysia', 'Kuala Lumpur', 'Kuala Lumpur', 'KUL-DC01', 9.000000, -31.000000, 'Asia/Singapore', 5400, 'normal', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49')
INSERT INTO Server_Location VALUES (50, 'Auckland Center', 'New Zealand', 'Auckland', 'Auckland', 'AKL-DC01', 10.000000, -30.000000, 'Asia/Kolkata', 5500, 'enabled', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50')

INSERT INTO Server_Type VALUES (1, 'Standard VPN', 'OpenVPN', 'AES-256', 100, 'Standard secure VPN server', 1194, 2, 1, 1, 'normal', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01')
INSERT INTO Server_Type VALUES (2, 'High Speed VPN', 'WireGuard', 'ChaCha20', 1000, 'High speed VPN server', 51820, 3, 0, 0, 'enabled', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02')
INSERT INTO Server_Type VALUES (3, 'Mobile VPN', 'IKEv2', 'AES-256', 200, 'Optimized for mobile devices', 1194, 4, 1, 1, 'available', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03')
INSERT INTO Server_Type VALUES (4, 'Secure VPN', 'OpenVPN', 'AES-256-GCM', 500, 'Enhanced security VPN', 51820, 5, 0, 0, 'active', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04')
INSERT INTO Server_Type VALUES (5, 'Gaming VPN', 'WireGuard', 'ChaCha20-Poly1305', 1000, 'Low latency gaming VPN', 1194, 6, 1, 1, 'normal', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05')
INSERT INTO Server_Type VALUES (6, 'Business VPN', 'IKEv2', 'AES-256', 500, 'VPN for business users', 51820, 7, 0, 0, 'enabled', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06')
INSERT INTO Server_Type VALUES (7, 'Streaming VPN', 'OpenVPN', 'AES-256-GCM', 800, 'Optimized for streaming', 1194, 8, 1, 1, 'available', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07')
INSERT INTO Server_Type VALUES (8, 'Private VPN', 'WireGuard', 'ChaCha20', 700, 'Private high speed VPN', 51820, 9, 0, 0, 'active', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08')
INSERT INTO Server_Type VALUES (9, 'Enterprise VPN', 'IKEv2', 'AES-256', 1000, 'Enterprise level VPN', 1194, 10, 1, 1, 'normal', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09')
INSERT INTO Server_Type VALUES (10, 'Basic VPN', 'OpenVPN', 'AES-128', 100, 'Basic VPN service', 51820, 1, 0, 0, 'enabled', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10')
INSERT INTO Server_Type VALUES (11, 'Premium VPN', 'WireGuard', 'ChaCha20', 1000, 'Premium high speed service', 1194, 2, 1, 1, 'available', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11')
INSERT INTO Server_Type VALUES (12, 'Secure Plus VPN', 'IKEv2', 'AES-256-GCM', 700, 'Advanced secure connection', 51820, 3, 0, 0, 'active', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12')
INSERT INTO Server_Type VALUES (13, 'Fast VPN', 'WireGuard', 'ChaCha20-Poly1305', 900, 'Fast VPN connection', 1194, 4, 1, 1, 'normal', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13')
INSERT INTO Server_Type VALUES (14, 'Global VPN', 'OpenVPN', 'AES-256', 600, 'Global VPN access', 51820, 5, 0, 0, 'enabled', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14')
INSERT INTO Server_Type VALUES (15, 'Corporate VPN', 'IKEv2', 'AES-256', 800, 'Corporate network VPN', 1194, 6, 1, 1, 'available', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15')
INSERT INTO Server_Type VALUES (16, 'Privacy VPN', 'OpenVPN', 'AES-256-GCM', 500, 'Privacy focused VPN', 51820, 7, 0, 0, 'active', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16')
INSERT INTO Server_Type VALUES (17, 'Ultra VPN', 'WireGuard', 'ChaCha20', 1200, 'Ultra high speed VPN', 1194, 8, 1, 1, 'normal', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17')
INSERT INTO Server_Type VALUES (18, 'Remote VPN', 'IKEv2', 'AES-256', 400, 'Remote access VPN', 51820, 9, 0, 0, 'enabled', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18')
INSERT INTO Server_Type VALUES (19, 'Cloud VPN', 'OpenVPN', 'AES-256', 700, 'Cloud based VPN server', 1194, 10, 1, 1, 'available', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19')
INSERT INTO Server_Type VALUES (20, 'Dedicated VPN', 'WireGuard', 'ChaCha20-Poly1305', 1200, 'Dedicated VPN server', 51820, 1, 0, 0, 'active', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20')
INSERT INTO Server_Type VALUES (21, 'Secure Mobile VPN', 'IKEv2', 'AES-256-GCM', 300, 'Secure mobile connection', 1194, 2, 1, 1, 'normal', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21')
INSERT INTO Server_Type VALUES (22, 'Office VPN', 'OpenVPN', 'AES-256', 400, 'Office network VPN', 51820, 3, 0, 0, 'enabled', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22')
INSERT INTO Server_Type VALUES (23, 'Developer VPN', 'WireGuard', 'ChaCha20', 900, 'VPN for developers', 1194, 4, 1, 1, 'available', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23')
INSERT INTO Server_Type VALUES (24, 'Research VPN', 'IKEv2', 'AES-256', 600, 'VPN for research networks', 51820, 5, 0, 0, 'active', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24')
INSERT INTO Server_Type VALUES (25, 'Education VPN', 'OpenVPN', 'AES-256-GCM', 500, 'VPN for educational networks', 1194, 6, 1, 1, 'normal', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25')
INSERT INTO Server_Type VALUES (26, 'Secure Cloud VPN', 'WireGuard', 'ChaCha20-Poly1305', 1000, 'Secure cloud connectivity', 51820, 7, 0, 0, 'enabled', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26')
INSERT INTO Server_Type VALUES (27, 'Travel VPN', 'IKEv2', 'AES-256', 300, 'VPN optimized for travelers', 1194, 8, 1, 1, 'available', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27')
INSERT INTO Server_Type VALUES (28, 'Home VPN', 'OpenVPN', 'AES-256', 300, 'VPN for home networks', 51820, 9, 0, 0, 'active', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28')
INSERT INTO Server_Type VALUES (29, 'Family VPN', 'WireGuard', 'ChaCha20', 600, 'VPN for family devices', 1194, 10, 1, 1, 'normal', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29')
INSERT INTO Server_Type VALUES (30, 'Anonymous VPN', 'IKEv2', 'AES-256-GCM', 500, 'Privacy focused connection', 51820, 1, 0, 0, 'enabled', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30')
INSERT INTO Server_Type VALUES (31, 'Secure Gaming VPN', 'WireGuard', 'ChaCha20-Poly1305', 1200, 'Gaming with secure connection', 1194, 2, 1, 1, 'available', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31')
INSERT INTO Server_Type VALUES (32, 'Streaming Plus VPN', 'OpenVPN', 'AES-256-GCM', 1000, 'High speed streaming VPN', 51820, 3, 0, 0, 'active', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32')
INSERT INTO Server_Type VALUES (33, 'Business Plus VPN', 'IKEv2', 'AES-256', 900, 'Advanced business VPN', 1194, 4, 1, 1, 'normal', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33')
INSERT INTO Server_Type VALUES (34, 'Enterprise Plus VPN', 'WireGuard', 'ChaCha20', 1500, 'High capacity enterprise VPN', 51820, 5, 0, 0, 'enabled', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34')
INSERT INTO Server_Type VALUES (35, 'Secure Enterprise VPN', 'OpenVPN', 'AES-256', 1000, 'Enterprise security VPN', 1194, 6, 1, 1, 'available', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35')
INSERT INTO Server_Type VALUES (36, 'Global Secure VPN', 'IKEv2', 'AES-256-GCM', 800, 'Global secure connectivity', 51820, 7, 0, 0, 'active', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36')
INSERT INTO Server_Type VALUES (37, 'High Capacity VPN', 'WireGuard', 'ChaCha20-Poly1305', 1500, 'High capacity VPN server', 1194, 8, 1, 1, 'normal', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37')
INSERT INTO Server_Type VALUES (38, 'Data Center VPN', 'OpenVPN', 'AES-256-GCM', 1200, 'Data center VPN service', 51820, 9, 0, 0, 'enabled', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38')
INSERT INTO Server_Type VALUES (39, 'Private Cloud VPN', 'IKEv2', 'AES-256', 1000, 'Private cloud VPN', 1194, 10, 1, 1, 'available', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39')
INSERT INTO Server_Type VALUES (40, 'Dedicated Secure VPN', 'WireGuard', 'ChaCha20', 1500, 'Dedicated secure connection', 51820, 1, 0, 0, 'active', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40')
INSERT INTO Server_Type VALUES (41, 'Advanced VPN', 'OpenVPN', 'AES-256-GCM', 800, 'Advanced VPN configuration', 1194, 2, 1, 1, 'normal', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41')
INSERT INTO Server_Type VALUES (42, 'Professional VPN', 'WireGuard', 'ChaCha20-Poly1305', 1200, 'Professional VPN service', 51820, 3, 0, 0, 'enabled', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42')
INSERT INTO Server_Type VALUES (43, 'Professional Mobile VPN', 'IKEv2', 'AES-256', 600, 'Professional mobile VPN', 1194, 4, 1, 1, 'available', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43')
INSERT INTO Server_Type VALUES (44, 'Enterprise Secure VPN', 'OpenVPN', 'AES-256', 1500, 'Enterprise secure service', 51820, 5, 0, 0, 'active', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44')
INSERT INTO Server_Type VALUES (45, 'Ultra Secure VPN', 'WireGuard', 'ChaCha20', 1800, 'Ultra secure high speed VPN', 1194, 6, 1, 1, 'normal', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45')
INSERT INTO Server_Type VALUES (46, 'Premium Mobile VPN', 'IKEv2', 'AES-256-GCM', 800, 'Premium mobile service', 51820, 7, 0, 0, 'enabled', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46')
INSERT INTO Server_Type VALUES (47, 'Premium Gaming VPN', 'WireGuard', 'ChaCha20-Poly1305', 1500, 'Premium gaming connection', 1194, 8, 1, 1, 'available', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47')
INSERT INTO Server_Type VALUES (48, 'Premium Streaming VPN', 'OpenVPN', 'AES-256-GCM', 1200, 'Premium streaming service', 51820, 9, 0, 0, 'active', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48')
INSERT INTO Server_Type VALUES (49, 'Ultimate VPN', 'IKEv2', 'AES-256', 1800, 'Ultimate VPN service', 1194, 10, 1, 1, 'normal', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49')
INSERT INTO Server_Type VALUES (50, 'Ultimate Secure VPN', 'WireGuard', 'ChaCha20-Poly1305', 2000, 'Ultimate high performance VPN', 51820, 1, 0, 0, 'enabled', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50')

INSERT INTO VPN_Server VALUES (1, 1, 1, 1, 'HYD-VPN-01', '10.10.1.1', 'online', 500, 245, 100, 'Debian Linux', 2, 16, '2026-01-01', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (2, 2, 2, 2, 'MUM-VPN-02', '10.10.2.1', 'online', 800, 430, 1000, 'Windows Server', 3, 32, '2026-01-02', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (3, 3, 3, 3, 'BLR-VPN-03', '10.10.3.1', 'online', 600, 315, 200, 'Rocky Linux', 4, 64, '2026-01-03', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (4, 4, 4, 4, 'CHE-VPN-04', '10.10.4.1', 'maintenance', 700, 0, 500, 'Ubuntu Linux', 5, 8, '2026-01-04', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (5, 5, 5, 5, 'DEL-VPN-05', '10.10.5.1', 'online', 900, 675, 1000, 'Debian Linux', 6, 16, '2026-01-05', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (6, 6, 6, 6, 'PUN-VPN-06', '10.10.6.1', 'online', 650, 280, 500, 'Windows Server', 7, 32, '2026-01-06', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (7, 7, 7, 7, 'KOL-VPN-07', '10.10.7.1', 'online', 750, 390, 800, 'Rocky Linux', 8, 64, '2026-01-07', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (8, 8, 8, 8, 'AHM-VPN-08', '10.10.8.1', 'offline', 700, 0, 700, 'Ubuntu Linux', 9, 8, '2026-01-08', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (9, 9, 9, 9, 'VIZ-VPN-09', '10.10.9.1', 'online', 1000, 520, 1000, 'Debian Linux', 10, 16, '2026-01-09', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (10, 10, 10, 10, 'VJA-VPN-10', '10.10.10.1', 'online', 500, 215, 100, 'Windows Server', 1, 32, '2026-01-10', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (11, 11, 11, 11, 'NYC-VPN-11', '10.10.11.1', 'online', 1200, 750, 1000, 'Rocky Linux', 2, 64, '2026-01-11', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (12, 12, 12, 12, 'LAX-VPN-12', '10.10.12.1', 'online', 900, 430, 700, 'Ubuntu Linux', 3, 8, '2026-01-12', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (13, 13, 13, 13, 'CHI-VPN-13', '10.10.13.1', 'maintenance', 800, 0, 900, 'Debian Linux', 4, 16, '2026-01-13', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (14, 14, 14, 14, 'DAL-VPN-14', '10.10.14.1', 'online', 1000, 620, 600, 'Windows Server', 5, 32, '2026-01-14', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (15, 15, 15, 15, 'SEA-VPN-15', '10.10.15.1', 'online', 1100, 580, 800, 'Rocky Linux', 6, 64, '2026-01-15', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (16, 16, 16, 16, 'LON-VPN-16', '10.10.16.1', 'online', 1200, 820, 500, 'Ubuntu Linux', 7, 8, '2026-01-16', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (17, 17, 17, 17, 'MAN-VPN-17', '10.10.17.1', 'offline', 900, 0, 1200, 'Debian Linux', 8, 16, '2026-01-17', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (18, 18, 18, 18, 'FRA-VPN-18', '10.10.18.1', 'online', 1300, 790, 400, 'Windows Server', 9, 32, '2026-01-18', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (19, 19, 19, 19, 'BER-VPN-19', '10.10.19.1', 'online', 1000, 450, 700, 'Rocky Linux', 10, 64, '2026-01-19', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (20, 20, 20, 20, 'PAR-VPN-20', '10.10.20.1', 'online', 1400, 920, 1200, 'Ubuntu Linux', 1, 8, '2026-01-20', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (21, 21, 21, 21, 'TOR-VPN-21', '10.10.21.1', 'online', 900, 480, 300, 'Debian Linux', 2, 16, '2026-01-21', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (22, 22, 22, 22, 'VAN-VPN-22', '10.10.22.1', 'online', 850, 390, 400, 'Windows Server', 3, 32, '2026-01-22', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (23, 23, 23, 23, 'SIN-VPN-23', '10.10.23.1', 'online', 1500, 980, 900, 'Rocky Linux', 4, 64, '2026-01-23', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (24, 24, 24, 24, 'TOK-VPN-24', '10.10.24.1', 'maintenance', 1000, 0, 600, 'Ubuntu Linux', 5, 8, '2026-01-24', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (25, 25, 25, 25, 'OSA-VPN-25', '10.10.25.1', 'online', 950, 510, 500, 'Debian Linux', 6, 16, '2026-01-25', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (26, 26, 26, 26, 'SEL-VPN-26', '10.10.26.1', 'online', 1100, 730, 1000, 'Windows Server', 7, 32, '2026-01-26', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (27, 27, 27, 27, 'SYD-VPN-27', '10.10.27.1', 'online', 1000, 540, 300, 'Rocky Linux', 8, 64, '2026-01-27', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (28, 28, 28, 28, 'MEL-VPN-28', '10.10.28.1', 'offline', 800, 0, 300, 'Ubuntu Linux', 9, 8, '2026-01-28', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (29, 29, 29, 29, 'DXB-VPN-29', '10.10.29.1', 'online', 1300, 870, 600, 'Debian Linux', 10, 16, '2026-02-01', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (30, 30, 30, 30, 'AUH-VPN-30', '10.10.30.1', 'online', 1200, 690, 500, 'Windows Server', 1, 32, '2026-02-02', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (31, 31, 31, 31, 'AMS-VPN-31', '10.10.31.1', 'online', 1400, 910, 1200, 'Rocky Linux', 2, 64, '2026-02-03', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (32, 32, 32, 32, 'ZRH-VPN-32', '10.10.32.1', 'online', 1000, 570, 1000, 'Ubuntu Linux', 3, 8, '2026-02-04', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (33, 33, 33, 33, 'STO-VPN-33', '10.10.33.1', 'maintenance', 900, 0, 900, 'Debian Linux', 4, 16, '2026-02-05', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (34, 34, 34, 34, 'OSL-VPN-34', '10.10.34.1', 'online', 1500, 980, 1500, 'Windows Server', 5, 32, '2026-02-06', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (35, 35, 35, 35, 'CPH-VPN-35', '10.10.35.1', 'online', 1200, 650, 1000, 'Rocky Linux', 6, 64, '2026-02-07', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (36, 36, 36, 36, 'MAD-VPN-36', '10.10.36.1', 'online', 1100, 590, 800, 'Ubuntu Linux', 7, 8, '2026-02-08', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (37, 37, 37, 37, 'ROM-VPN-37', '10.10.37.1', 'online', 1000, 520, 1500, 'Debian Linux', 8, 16, '2026-02-09', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (38, 38, 38, 38, 'MIL-VPN-38', '10.10.38.1', 'offline', 900, 0, 1200, 'Windows Server', 9, 32, '2026-02-10', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (39, 39, 39, 39, 'SAO-VPN-39', '10.10.39.1', 'online', 1300, 710, 1000, 'Rocky Linux', 10, 64, '2026-02-11', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (40, 40, 40, 40, 'MEX-VPN-40', '10.10.40.1', 'online', 1250, 680, 1500, 'Ubuntu Linux', 1, 8, '2026-02-12', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (41, 41, 41, 41, 'JNB-VPN-41', '10.10.41.1', 'online', 1000, 490, 800, 'Debian Linux', 2, 16, '2026-02-13', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (42, 42, 42, 42, 'CPT-VPN-42', '10.10.42.1', 'online', 900, 410, 1200, 'Windows Server', 3, 32, '2026-02-14', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (43, 43, 43, 43, 'MOS-VPN-43', '10.10.43.1', 'maintenance', 1100, 0, 600, 'Rocky Linux', 4, 64, '2026-02-15', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (44, 44, 44, 44, 'IST-VPN-44', '10.10.44.1', 'online', 1300, 760, 1500, 'Ubuntu Linux', 5, 8, '2026-02-16', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (45, 45, 45, 45, 'HKG-VPN-45', '10.10.45.1', 'online', 1600, 1100, 1800, 'Debian Linux', 6, 16, '2026-02-17', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (46, 46, 46, 46, 'TPE-VPN-46', '10.10.46.1', 'online', 1000, 560, 800, 'Windows Server', 7, 32, '2026-02-18', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (47, 47, 47, 47, 'BKK-VPN-47', '10.10.47.1', 'offline', 1200, 0, 1500, 'Rocky Linux', 8, 64, '2026-02-19', '03:00-05:00 UTC')
INSERT INTO VPN_Server VALUES (48, 48, 48, 48, 'JKT-VPN-48', '10.10.48.1', 'online', 1100, 630, 1200, 'Ubuntu Linux', 9, 8, '2026-02-20', '01:00-03:00 UTC')
INSERT INTO VPN_Server VALUES (49, 49, 49, 49, 'KUL-VPN-49', '10.10.49.1', 'online', 1400, 850, 1800, 'Debian Linux', 10, 16, '2026-02-21', '02:00-04:00 UTC')
INSERT INTO VPN_Server VALUES (50, 50, 50, 50, 'AKL-VPN-50', '10.10.50.1', 'online', 1500, 970, 2000, 'Windows Server', 1, 32, '2026-02-22', '03:00-05:00 UTC')

INSERT INTO VPN_Plan VALUES (1, 'Basic Monthly', 'Basic', 1, 199.00, 1, '100 GB', 'active', 'priority email', 2, 1.25, 'manual', 'plan_description record 01', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01')
INSERT INTO VPN_Plan VALUES (2, 'Standard Monthly', 'Standard', 1, 299.00, 3, '250 GB', 'active', '24/7 chat', 3, 2.50, 'automatic', 'plan_description record 02', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02')
INSERT INTO VPN_Plan VALUES (3, 'Premium Monthly', 'Premium', 1, 399.00, 5, 'Unlimited', 'active', 'email', 4, 3.75, 'manual', 'plan_description record 03', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03')
INSERT INTO VPN_Plan VALUES (4, 'Basic Quarterly', 'Basic', 3, 499.00, 1, '300 GB', 'active', 'priority email', 5, 5.00, 'automatic', 'plan_description record 04', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04')
INSERT INTO VPN_Plan VALUES (5, 'Standard Quarterly', 'Standard', 3, 749.00, 3, '750 GB', 'active', '24/7 chat', 6, 6.25, 'manual', 'plan_description record 05', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05')
INSERT INTO VPN_Plan VALUES (6, 'Premium Quarterly', 'Premium', 3, 999.00, 5, 'Unlimited', 'active', 'email', 7, 7.50, 'automatic', 'plan_description record 06', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06')
INSERT INTO VPN_Plan VALUES (7, 'Basic Half Year', 'Basic', 6, 899.00, 1, '600 GB', 'active', 'priority email', 8, 8.75, 'manual', 'plan_description record 07', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07')
INSERT INTO VPN_Plan VALUES (8, 'Standard Half Year', 'Standard', 6, 1299.00, 3, 'Unlimited', 'active', '24/7 chat', 9, 10.00, 'automatic', 'plan_description record 08', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08')
INSERT INTO VPN_Plan VALUES (9, 'Premium Half Year', 'Premium', 6, 1699.00, 5, 'Unlimited', 'active', 'email', 10, 11.25, 'manual', 'plan_description record 09', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09')
INSERT INTO VPN_Plan VALUES (10, 'Basic Annual', 'Basic', 12, 1499.00, 1, '1 TB', 'active', 'priority email', 1, 12.50, 'automatic', 'plan_description record 10', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10')
INSERT INTO VPN_Plan VALUES (11, 'Standard Annual', 'Standard', 12, 2299.00, 3, 'Unlimited', 'active', '24/7 chat', 2, 13.75, 'manual', 'plan_description record 11', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11')
INSERT INTO VPN_Plan VALUES (12, 'Premium Annual', 'Premium', 12, 2999.00, 5, 'Unlimited', 'active', 'email', 3, 15.00, 'automatic', 'plan_description record 12', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12')
INSERT INTO VPN_Plan VALUES (13, 'Family Monthly', 'Family', 1, 499.00, 6, 'Unlimited', 'active', 'priority email', 4, 16.25, 'manual', 'plan_description record 13', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13')
INSERT INTO VPN_Plan VALUES (14, 'Family Quarterly', 'Family', 3, 1299.00, 6, 'Unlimited', 'active', '24/7 chat', 5, 17.50, 'automatic', 'plan_description record 14', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14')
INSERT INTO VPN_Plan VALUES (15, 'Family Annual', 'Family', 12, 3999.00, 8, 'Unlimited', 'active', 'email', 6, 18.75, 'manual', 'plan_description record 15', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15')
INSERT INTO VPN_Plan VALUES (16, 'Student Monthly', 'Student', 1, 149.00, 2, '200 GB', 'active', 'priority email', 7, 20.00, 'automatic', 'plan_description record 16', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16')
INSERT INTO VPN_Plan VALUES (17, 'Student Quarterly', 'Student', 3, 399.00, 2, '600 GB', 'active', '24/7 chat', 8, 21.25, 'manual', 'plan_description record 17', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17')
INSERT INTO VPN_Plan VALUES (18, 'Student Annual', 'Student', 12, 1199.00, 2, 'Unlimited', 'active', 'email', 9, 22.50, 'automatic', 'plan_description record 18', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18')
INSERT INTO VPN_Plan VALUES (19, 'Gaming Monthly', 'Gaming', 1, 449.00, 3, 'Unlimited', 'active', 'priority email', 10, 23.75, 'manual', 'plan_description record 19', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19')
INSERT INTO VPN_Plan VALUES (20, 'Gaming Annual', 'Gaming', 12, 4499.00, 5, 'Unlimited', 'active', '24/7 chat', 1, 0.00, 'automatic', 'plan_description record 20', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20')
INSERT INTO VPN_Plan VALUES (21, 'Streaming Monthly', 'Streaming', 1, 449.00, 3, 'Unlimited', 'active', 'email', 2, 1.25, 'manual', 'plan_description record 21', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21')
INSERT INTO VPN_Plan VALUES (22, 'Streaming Quarterly', 'Streaming', 3, 1199.00, 4, 'Unlimited', 'active', 'priority email', 3, 2.50, 'automatic', 'plan_description record 22', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22')
INSERT INTO VPN_Plan VALUES (23, 'Streaming Annual', 'Streaming', 12, 3999.00, 6, 'Unlimited', 'active', '24/7 chat', 4, 3.75, 'manual', 'plan_description record 23', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23')
INSERT INTO VPN_Plan VALUES (24, 'Business Monthly', 'Business', 1, 699.00, 10, 'Unlimited', 'active', 'email', 5, 5.00, 'automatic', 'plan_description record 24', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24')
INSERT INTO VPN_Plan VALUES (25, 'Business Quarterly', 'Business', 3, 1899.00, 10, 'Unlimited', 'active', 'priority email', 6, 6.25, 'manual', 'plan_description record 25', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25')
INSERT INTO VPN_Plan VALUES (26, 'Business Annual', 'Business', 12, 6999.00, 15, 'Unlimited', 'active', '24/7 chat', 7, 7.50, 'automatic', 'plan_description record 26', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26')
INSERT INTO VPN_Plan VALUES (27, 'Professional Monthly', 'Professional', 1, 799.00, 10, 'Unlimited', 'active', 'email', 8, 8.75, 'manual', 'plan_description record 27', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27')
INSERT INTO VPN_Plan VALUES (28, 'Professional Quarterly', 'Professional', 3, 2199.00, 12, 'Unlimited', 'active', 'priority email', 9, 10.00, 'automatic', 'plan_description record 28', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28')
INSERT INTO VPN_Plan VALUES (29, 'Professional Annual', 'Professional', 12, 7999.00, 20, 'Unlimited', 'active', '24/7 chat', 10, 11.25, 'manual', 'plan_description record 29', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29')
INSERT INTO VPN_Plan VALUES (30, 'Enterprise Monthly', 'Enterprise', 1, 1299.00, 25, 'Unlimited', 'active', 'email', 1, 12.50, 'automatic', 'plan_description record 30', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30')
INSERT INTO VPN_Plan VALUES (31, 'Enterprise Quarterly', 'Enterprise', 3, 3499.00, 30, 'Unlimited', 'active', 'priority email', 2, 13.75, 'manual', 'plan_description record 31', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31')
INSERT INTO VPN_Plan VALUES (32, 'Enterprise Annual', 'Enterprise', 12, 12999.00, 50, 'Unlimited', 'active', '24/7 chat', 3, 15.00, 'automatic', 'plan_description record 32', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32')
INSERT INTO VPN_Plan VALUES (33, 'Mobile Monthly', 'Mobile', 1, 179.00, 2, '150 GB', 'active', 'email', 4, 16.25, 'manual', 'plan_description record 33', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33')
INSERT INTO VPN_Plan VALUES (34, 'Mobile Annual', 'Mobile', 12, 1599.00, 3, 'Unlimited', 'active', 'priority email', 5, 17.50, 'automatic', 'plan_description record 34', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34')
INSERT INTO VPN_Plan VALUES (35, 'Privacy Monthly', 'Privacy', 1, 349.00, 3, 'Unlimited', 'active', '24/7 chat', 6, 18.75, 'manual', 'plan_description record 35', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35')
INSERT INTO VPN_Plan VALUES (36, 'Privacy Annual', 'Privacy', 12, 2999.00, 5, 'Unlimited', 'active', 'email', 7, 20.00, 'automatic', 'plan_description record 36', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36')
INSERT INTO VPN_Plan VALUES (37, 'Secure Monthly', 'Secure', 1, 399.00, 3, 'Unlimited', 'active', 'priority email', 8, 21.25, 'manual', 'plan_description record 37', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37')
INSERT INTO VPN_Plan VALUES (38, 'Secure Annual', 'Secure', 12, 3499.00, 6, 'Unlimited', 'active', '24/7 chat', 9, 22.50, 'automatic', 'plan_description record 38', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38')
INSERT INTO VPN_Plan VALUES (39, 'Ultra Monthly', 'Ultra', 1, 599.00, 5, 'Unlimited', 'active', 'email', 10, 23.75, 'manual', 'plan_description record 39', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39')
INSERT INTO VPN_Plan VALUES (40, 'Ultra Annual', 'Ultra', 12, 4999.00, 10, 'Unlimited', 'active', 'priority email', 1, 0.00, 'automatic', 'plan_description record 40', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40')
INSERT INTO VPN_Plan VALUES (41, 'Travel Monthly', 'Travel', 1, 299.00, 3, '300 GB', 'active', '24/7 chat', 2, 1.25, 'manual', 'plan_description record 41', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41')
INSERT INTO VPN_Plan VALUES (42, 'Travel Annual', 'Travel', 12, 2499.00, 5, 'Unlimited', 'active', 'email', 3, 2.50, 'automatic', 'plan_description record 42', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42')
INSERT INTO VPN_Plan VALUES (43, 'Cloud Monthly', 'Cloud', 1, 499.00, 5, 'Unlimited', 'active', 'priority email', 4, 3.75, 'manual', 'plan_description record 43', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43')
INSERT INTO VPN_Plan VALUES (44, 'Cloud Annual', 'Cloud', 12, 4499.00, 10, 'Unlimited', 'active', '24/7 chat', 5, 5.00, 'automatic', 'plan_description record 44', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44')
INSERT INTO VPN_Plan VALUES (45, 'Dedicated Monthly', 'Dedicated', 1, 999.00, 10, 'Unlimited', 'active', 'email', 6, 6.25, 'manual', 'plan_description record 45', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45')
INSERT INTO VPN_Plan VALUES (46, 'Dedicated Annual', 'Dedicated', 12, 8999.00, 25, 'Unlimited', 'active', 'priority email', 7, 7.50, 'automatic', 'plan_description record 46', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46')
INSERT INTO VPN_Plan VALUES (47, 'Ultimate Monthly', 'Ultimate', 1, 1499.00, 15, 'Unlimited', 'active', '24/7 chat', 8, 8.75, 'manual', 'plan_description record 47', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47')
INSERT INTO VPN_Plan VALUES (48, 'Ultimate Quarterly', 'Ultimate', 3, 3999.00, 20, 'Unlimited', 'active', 'email', 9, 10.00, 'automatic', 'plan_description record 48', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48')
INSERT INTO VPN_Plan VALUES (49, 'Ultimate Annual', 'Ultimate', 12, 14999.00, 50, 'Unlimited', 'active', 'priority email', 10, 11.25, 'manual', 'plan_description record 49', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49')
INSERT INTO VPN_Plan VALUES (50, 'Lifetime Premium', 'Lifetime', 120, 19999.00, 50, 'Unlimited', 'active', '24/7 chat', 1, 12.50, 'automatic', 'plan_description record 50', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50')

INSERT INTO Subscription VALUES (1, 1, 1, 1, '2026-01-01', '2026-02-01', 'active', 'yes', 'quarterly', 1.25, '2026-01-01', '2026-01-01', NULL, 'Additional detail 1 for record 01', 'Additional detail 2 for record 01')
INSERT INTO Subscription VALUES (2, 2, 2, 2, '2026-01-02', '2026-02-02', 'active', 'yes', 'yearly', 2.50, '2026-01-02', '2026-01-02', NULL, 'Additional detail 1 for record 02', 'Additional detail 2 for record 02')
INSERT INTO Subscription VALUES (3, 3, 3, 3, '2026-01-03', '2026-02-03', 'active', 'no', 'monthly', 3.75, '2026-01-03', '2026-01-03', NULL, 'Additional detail 1 for record 03', 'Additional detail 2 for record 03')
INSERT INTO Subscription VALUES (4, 4, 4, 4, '2026-01-04', '2026-04-04', 'active', 'yes', 'quarterly', 5.00, '2026-01-04', '2026-01-04', NULL, 'Additional detail 1 for record 04', 'Additional detail 2 for record 04')
INSERT INTO Subscription VALUES (5, 5, 5, 5, '2026-01-05', '2026-04-05', 'active', 'yes', 'yearly', 6.25, '2026-01-05', '2026-01-05', NULL, 'Additional detail 1 for record 05', 'Additional detail 2 for record 05')
INSERT INTO Subscription VALUES (6, 6, 6, 6, '2026-01-06', '2026-04-06', 'active', 'no', 'monthly', 7.50, '2026-01-06', '2026-01-06', NULL, 'Additional detail 1 for record 06', 'Additional detail 2 for record 06')
INSERT INTO Subscription VALUES (7, 7, 7, 7, '2026-01-07', '2026-07-07', 'active', 'yes', 'quarterly', 8.75, '2026-01-07', '2026-01-07', NULL, 'Additional detail 1 for record 07', 'Additional detail 2 for record 07')
INSERT INTO Subscription VALUES (8, 8, 8, 8, '2026-01-08', '2026-07-08', 'active', 'yes', 'yearly', 10.00, '2026-01-08', '2026-01-08', NULL, 'Additional detail 1 for record 08', 'Additional detail 2 for record 08')
INSERT INTO Subscription VALUES (9, 9, 9, 9, '2026-01-09', '2026-07-09', 'active', 'no', 'monthly', 11.25, '2026-01-09', '2026-01-09', NULL, 'Additional detail 1 for record 09', 'Additional detail 2 for record 09')
INSERT INTO Subscription VALUES (10, 10, 10, 10, '2026-01-10', '2027-01-10', 'active', 'yes', 'quarterly', 12.50, '2026-01-10', '2026-01-10', NULL, 'Additional detail 1 for record 10', 'Additional detail 2 for record 10')
INSERT INTO Subscription VALUES (11, 11, 11, 11, '2026-01-11', '2027-01-11', 'active', 'yes', 'yearly', 13.75, '2026-01-11', '2026-01-11', NULL, 'Additional detail 1 for record 11', 'Additional detail 2 for record 11')
INSERT INTO Subscription VALUES (12, 12, 12, 12, '2026-01-12', '2027-01-12', 'active', 'no', 'monthly', 15.00, '2026-01-12', '2026-01-12', NULL, 'Additional detail 1 for record 12', 'Additional detail 2 for record 12')
INSERT INTO Subscription VALUES (13, 13, 13, 13, '2026-01-13', '2026-02-13', 'active', 'yes', 'quarterly', 16.25, '2026-01-13', '2026-01-13', NULL, 'Additional detail 1 for record 13', 'Additional detail 2 for record 13')
INSERT INTO Subscription VALUES (14, 14, 14, 14, '2026-01-14', '2026-04-14', 'active', 'no', 'yearly', 17.50, '2026-01-14', '2026-01-14', NULL, 'Additional detail 1 for record 14', 'Additional detail 2 for record 14')
INSERT INTO Subscription VALUES (15, 15, 15, 15, '2026-01-15', '2027-01-15', 'active', 'yes', 'monthly', 18.75, '2026-01-15', '2026-01-15', NULL, 'Additional detail 1 for record 15', 'Additional detail 2 for record 15')
INSERT INTO Subscription VALUES (16, 16, 16, 16, '2026-01-16', '2026-02-16', 'expired', 'no', 'quarterly', 20.00, '2026-01-16', '2026-01-16', NULL, 'Additional detail 1 for record 16', 'Additional detail 2 for record 16')
INSERT INTO Subscription VALUES (17, 17, 17, 17, '2026-01-17', '2026-04-17', 'active', 'yes', 'yearly', 21.25, '2026-01-17', '2026-01-17', NULL, 'Additional detail 1 for record 17', 'Additional detail 2 for record 17')
INSERT INTO Subscription VALUES (18, 18, 18, 18, '2026-01-18', '2027-01-18', 'active', 'yes', 'monthly', 22.50, '2026-01-18', '2026-01-18', NULL, 'Additional detail 1 for record 18', 'Additional detail 2 for record 18')
INSERT INTO Subscription VALUES (19, 19, 19, 19, '2026-01-19', '2026-02-19', 'active', 'no', 'quarterly', 23.75, '2026-01-19', '2026-01-19', NULL, 'Additional detail 1 for record 19', 'Additional detail 2 for record 19')
INSERT INTO Subscription VALUES (20, 20, 20, 20, '2026-01-20', '2027-01-20', 'active', 'yes', 'yearly', 0.00, '2026-01-20', '2026-01-20', NULL, 'Additional detail 1 for record 20', 'Additional detail 2 for record 20')
INSERT INTO Subscription VALUES (21, 21, 21, 21, '2026-01-21', '2026-02-21', 'active', 'yes', 'monthly', 1.25, '2026-01-21', '2026-01-21', NULL, 'Additional detail 1 for record 21', 'Additional detail 2 for record 21')
INSERT INTO Subscription VALUES (22, 22, 22, 22, '2026-01-22', '2026-04-22', 'active', 'no', 'quarterly', 2.50, '2026-01-22', '2026-01-22', NULL, 'Additional detail 1 for record 22', 'Additional detail 2 for record 22')
INSERT INTO Subscription VALUES (23, 23, 23, 23, '2026-01-23', '2027-01-23', 'active', 'yes', 'yearly', 3.75, '2026-01-23', '2026-01-23', NULL, 'Additional detail 1 for record 23', 'Additional detail 2 for record 23')
INSERT INTO Subscription VALUES (24, 24, 24, 24, '2026-01-24', '2026-02-24', 'active', 'yes', 'monthly', 5.00, '2026-01-24', '2026-01-24', NULL, 'Additional detail 1 for record 24', 'Additional detail 2 for record 24')
INSERT INTO Subscription VALUES (25, 25, 25, 25, '2026-01-25', '2026-04-25', 'active', 'no', 'quarterly', 6.25, '2026-01-25', '2026-01-25', NULL, 'Additional detail 1 for record 25', 'Additional detail 2 for record 25')
INSERT INTO Subscription VALUES (26, 26, 26, 26, '2026-01-26', '2027-01-26', 'active', 'yes', 'yearly', 7.50, '2026-01-26', '2026-01-26', NULL, 'Additional detail 1 for record 26', 'Additional detail 2 for record 26')
INSERT INTO Subscription VALUES (27, 27, 27, 27, '2026-01-27', '2026-02-27', 'active', 'no', 'monthly', 8.75, '2026-01-27', '2026-01-27', NULL, 'Additional detail 1 for record 27', 'Additional detail 2 for record 27')
INSERT INTO Subscription VALUES (28, 28, 28, 28, '2026-01-28', '2026-04-28', 'active', 'yes', 'quarterly', 10.00, '2026-01-28', '2026-01-28', NULL, 'Additional detail 1 for record 28', 'Additional detail 2 for record 28')
INSERT INTO Subscription VALUES (29, 29, 29, 29, '2026-01-29', '2027-01-29', 'active', 'yes', 'yearly', 11.25, '2026-02-01', '2026-02-01', NULL, 'Additional detail 1 for record 29', 'Additional detail 2 for record 29')
INSERT INTO Subscription VALUES (30, 30, 30, 30, '2026-01-30', '2026-02-28', 'cancelled', 'no', 'monthly', 12.50, '2026-02-02', '2026-02-02', NULL, 'Additional detail 1 for record 30', 'Additional detail 2 for record 30')
INSERT INTO Subscription VALUES (31, 31, 31, 31, '2026-01-31', '2026-05-01', 'active', 'yes', 'quarterly', 13.75, '2026-02-03', '2026-02-03', NULL, 'Additional detail 1 for record 31', 'Additional detail 2 for record 31')
INSERT INTO Subscription VALUES (32, 32, 32, 32, '2026-02-01', '2027-02-01', 'active', 'yes', 'yearly', 15.00, '2026-02-04', '2026-02-04', NULL, 'Additional detail 1 for record 32', 'Additional detail 2 for record 32')
INSERT INTO Subscription VALUES (33, 33, 33, 33, '2026-02-02', '2026-03-02', 'active', 'no', 'monthly', 16.25, '2026-02-05', '2026-02-05', NULL, 'Additional detail 1 for record 33', 'Additional detail 2 for record 33')
INSERT INTO Subscription VALUES (34, 34, 34, 34, '2026-02-03', '2027-02-03', 'active', 'yes', 'quarterly', 17.50, '2026-02-06', '2026-02-06', NULL, 'Additional detail 1 for record 34', 'Additional detail 2 for record 34')
INSERT INTO Subscription VALUES (35, 35, 35, 35, '2026-02-04', '2026-03-04', 'active', 'yes', 'yearly', 18.75, '2026-02-07', '2026-02-07', NULL, 'Additional detail 1 for record 35', 'Additional detail 2 for record 35')
INSERT INTO Subscription VALUES (36, 36, 36, 36, '2026-02-05', '2027-02-05', 'active', 'no', 'monthly', 20.00, '2026-02-08', '2026-02-08', NULL, 'Additional detail 1 for record 36', 'Additional detail 2 for record 36')
INSERT INTO Subscription VALUES (37, 37, 37, 37, '2026-02-06', '2026-03-06', 'active', 'yes', 'quarterly', 21.25, '2026-02-09', '2026-02-09', NULL, 'Additional detail 1 for record 37', 'Additional detail 2 for record 37')
INSERT INTO Subscription VALUES (38, 38, 38, 38, '2026-02-07', '2027-02-07', 'active', 'yes', 'yearly', 22.50, '2026-02-10', '2026-02-10', NULL, 'Additional detail 1 for record 38', 'Additional detail 2 for record 38')
INSERT INTO Subscription VALUES (39, 39, 39, 39, '2026-02-08', '2026-03-08', 'expired', 'no', 'monthly', 23.75, '2026-02-11', '2026-02-11', NULL, 'Additional detail 1 for record 39', 'Additional detail 2 for record 39')
INSERT INTO Subscription VALUES (40, 40, 40, 40, '2026-02-09', '2027-02-09', 'active', 'yes', 'quarterly', 0.00, '2026-02-12', '2026-02-12', NULL, 'Additional detail 1 for record 40', 'Additional detail 2 for record 40')
INSERT INTO Subscription VALUES (41, 41, 41, 41, '2026-02-10', '2026-03-10', 'active', 'yes', 'yearly', 1.25, '2026-02-13', '2026-02-13', NULL, 'Additional detail 1 for record 41', 'Additional detail 2 for record 41')
INSERT INTO Subscription VALUES (42, 42, 42, 42, '2026-02-11', '2027-02-11', 'active', 'no', 'monthly', 2.50, '2026-02-14', '2026-02-14', NULL, 'Additional detail 1 for record 42', 'Additional detail 2 for record 42')
INSERT INTO Subscription VALUES (43, 43, 43, 43, '2026-02-12', '2026-03-12', 'active', 'yes', 'quarterly', 3.75, '2026-02-15', '2026-02-15', NULL, 'Additional detail 1 for record 43', 'Additional detail 2 for record 43')
INSERT INTO Subscription VALUES (44, 44, 44, 44, '2026-02-13', '2027-02-13', 'active', 'yes', 'yearly', 5.00, '2026-02-16', '2026-02-16', NULL, 'Additional detail 1 for record 44', 'Additional detail 2 for record 44')
INSERT INTO Subscription VALUES (45, 45, 45, 45, '2026-02-14', '2026-03-14', 'active', 'no', 'monthly', 6.25, '2026-02-17', '2026-02-17', NULL, 'Additional detail 1 for record 45', 'Additional detail 2 for record 45')
INSERT INTO Subscription VALUES (46, 46, 46, 46, '2026-02-15', '2027-02-15', 'active', 'yes', 'quarterly', 7.50, '2026-02-18', '2026-02-18', NULL, 'Additional detail 1 for record 46', 'Additional detail 2 for record 46')
INSERT INTO Subscription VALUES (47, 47, 47, 47, '2026-02-16', '2026-03-16', 'active', 'no', 'yearly', 8.75, '2026-02-19', '2026-02-19', NULL, 'Additional detail 1 for record 47', 'Additional detail 2 for record 47')
INSERT INTO Subscription VALUES (48, 48, 48, 48, '2026-02-17', '2027-02-17', 'active', 'yes', 'monthly', 10.00, '2026-02-20', '2026-02-20', NULL, 'Additional detail 1 for record 48', 'Additional detail 2 for record 48')
INSERT INTO Subscription VALUES (49, 49, 49, 49, '2026-02-18', '2027-02-18', 'active', 'yes', 'quarterly', 11.25, '2026-02-21', '2026-02-21', NULL, 'Additional detail 1 for record 49', 'Additional detail 2 for record 49')
INSERT INTO Subscription VALUES (50, 50, 50, 50, '2026-02-19', '2036-02-19', 'active', 'no', 'yearly', 12.50, '2026-02-22', '2026-02-22', NULL, 'Additional detail 1 for record 50', 'Additional detail 2 for record 50')

INSERT INTO Payment_Method VALUES (1, 'UPI', 'Google Pay', 'UPI', 'active', 1.25, 'USD', 125.00, 1, 'method_description record 01', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01', 'Additional detail 5 for record 01')
INSERT INTO Payment_Method VALUES (2, 'UPI', 'PhonePe', 'UPI', 'active', 2.50, 'EUR', 150.00, 0, 'method_description record 02', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02', 'Additional detail 5 for record 02')
INSERT INTO Payment_Method VALUES (3, 'UPI', 'Paytm', 'UPI', 'active', 3.75, 'GBP', 175.00, 1, 'method_description record 03', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03', 'Additional detail 5 for record 03')
INSERT INTO Payment_Method VALUES (4, 'UPI', 'Amazon Pay', 'UPI', 'active', 5.00, 'INR', 200.00, 0, 'method_description record 04', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04', 'Additional detail 5 for record 04')
INSERT INTO Payment_Method VALUES (5, 'Credit Card', 'Visa', 'Card', 'active', 6.25, 'USD', 225.00, 1, 'method_description record 05', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05', 'Additional detail 5 for record 05')
INSERT INTO Payment_Method VALUES (6, 'Credit Card', 'Mastercard', 'Card', 'active', 7.50, 'EUR', 250.00, 0, 'method_description record 06', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06', 'Additional detail 5 for record 06')
INSERT INTO Payment_Method VALUES (7, 'Debit Card', 'Visa', 'Card', 'active', 8.75, 'GBP', 275.00, 1, 'method_description record 07', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07', 'Additional detail 5 for record 07')
INSERT INTO Payment_Method VALUES (8, 'Debit Card', 'Mastercard', 'Card', 'active', 10.00, 'INR', 300.00, 0, 'method_description record 08', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08', 'Additional detail 5 for record 08')
INSERT INTO Payment_Method VALUES (9, 'Net Banking', 'SBI', 'Banking', 'active', 11.25, 'USD', 325.00, 1, 'method_description record 09', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09', 'Additional detail 5 for record 09')
INSERT INTO Payment_Method VALUES (10, 'Net Banking', 'HDFC Bank', 'Banking', 'active', 12.50, 'EUR', 350.00, 0, 'method_description record 10', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10', 'Additional detail 5 for record 10')
INSERT INTO Payment_Method VALUES (11, 'Net Banking', 'ICICI Bank', 'Banking', 'active', 13.75, 'GBP', 375.00, 1, 'method_description record 11', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11', 'Additional detail 5 for record 11')
INSERT INTO Payment_Method VALUES (12, 'Net Banking', 'Axis Bank', 'Banking', 'active', 15.00, 'INR', 400.00, 0, 'method_description record 12', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12', 'Additional detail 5 for record 12')
INSERT INTO Payment_Method VALUES (13, 'UPI', 'BHIM', 'UPI', 'active', 16.25, 'USD', 425.00, 1, 'method_description record 13', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13', 'Additional detail 5 for record 13')
INSERT INTO Payment_Method VALUES (14, 'UPI', 'WhatsApp Pay', 'UPI', 'active', 17.50, 'EUR', 450.00, 0, 'method_description record 14', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14', 'Additional detail 5 for record 14')
INSERT INTO Payment_Method VALUES (15, 'Credit Card', 'American Express', 'Card', 'active', 18.75, 'GBP', 475.00, 1, 'method_description record 15', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15', 'Additional detail 5 for record 15')
INSERT INTO Payment_Method VALUES (16, 'Debit Card', 'RuPay', 'Card', 'active', 20.00, 'INR', 500.00, 0, 'method_description record 16', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16', 'Additional detail 5 for record 16')
INSERT INTO Payment_Method VALUES (17, 'Net Banking', 'Kotak Bank', 'Banking', 'active', 21.25, 'USD', 525.00, 1, 'method_description record 17', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17', 'Additional detail 5 for record 17')
INSERT INTO Payment_Method VALUES (18, 'Net Banking', 'Bank of Baroda', 'Banking', 'active', 22.50, 'EUR', 550.00, 0, 'method_description record 18', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18', 'Additional detail 5 for record 18')
INSERT INTO Payment_Method VALUES (19, 'UPI', 'Google Pay', 'UPI', 'active', 23.75, 'GBP', 575.00, 1, 'method_description record 19', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19', 'Additional detail 5 for record 19')
INSERT INTO Payment_Method VALUES (20, 'UPI', 'PhonePe', 'UPI', 'active', 0.00, 'INR', 600.00, 0, 'method_description record 20', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20', 'Additional detail 5 for record 20')
INSERT INTO Payment_Method VALUES (21, 'UPI', 'Paytm', 'UPI', 'active', 1.25, 'USD', 625.00, 1, 'method_description record 21', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21', 'Additional detail 5 for record 21')
INSERT INTO Payment_Method VALUES (22, 'UPI', 'Amazon Pay', 'UPI', 'active', 2.50, 'EUR', 650.00, 0, 'method_description record 22', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22', 'Additional detail 5 for record 22')
INSERT INTO Payment_Method VALUES (23, 'Credit Card', 'Visa', 'Card', 'active', 3.75, 'GBP', 675.00, 1, 'method_description record 23', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23', 'Additional detail 5 for record 23')
INSERT INTO Payment_Method VALUES (24, 'Credit Card', 'Mastercard', 'Card', 'active', 5.00, 'INR', 700.00, 0, 'method_description record 24', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24', 'Additional detail 5 for record 24')
INSERT INTO Payment_Method VALUES (25, 'Debit Card', 'Visa', 'Card', 'active', 6.25, 'USD', 725.00, 1, 'method_description record 25', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25', 'Additional detail 5 for record 25')
INSERT INTO Payment_Method VALUES (26, 'Debit Card', 'Mastercard', 'Card', 'active', 7.50, 'EUR', 750.00, 0, 'method_description record 26', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26', 'Additional detail 5 for record 26')
INSERT INTO Payment_Method VALUES (27, 'Net Banking', 'SBI', 'Banking', 'active', 8.75, 'GBP', 775.00, 1, 'method_description record 27', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27', 'Additional detail 5 for record 27')
INSERT INTO Payment_Method VALUES (28, 'Net Banking', 'HDFC Bank', 'Banking', 'active', 10.00, 'INR', 800.00, 0, 'method_description record 28', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28', 'Additional detail 5 for record 28')
INSERT INTO Payment_Method VALUES (29, 'Net Banking', 'ICICI Bank', 'Banking', 'active', 11.25, 'USD', 825.00, 1, 'method_description record 29', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29', 'Additional detail 5 for record 29')
INSERT INTO Payment_Method VALUES (30, 'Net Banking', 'Axis Bank', 'Banking', 'active', 12.50, 'EUR', 850.00, 0, 'method_description record 30', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30', 'Additional detail 5 for record 30')
INSERT INTO Payment_Method VALUES (31, 'UPI', 'BHIM', 'UPI', 'active', 13.75, 'GBP', 875.00, 1, 'method_description record 31', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31', 'Additional detail 5 for record 31')
INSERT INTO Payment_Method VALUES (32, 'UPI', 'WhatsApp Pay', 'UPI', 'active', 15.00, 'INR', 900.00, 0, 'method_description record 32', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32', 'Additional detail 5 for record 32')
INSERT INTO Payment_Method VALUES (33, 'Credit Card', 'American Express', 'Card', 'active', 16.25, 'USD', 925.00, 1, 'method_description record 33', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33', 'Additional detail 5 for record 33')
INSERT INTO Payment_Method VALUES (34, 'Debit Card', 'RuPay', 'Card', 'active', 17.50, 'EUR', 950.00, 0, 'method_description record 34', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34', 'Additional detail 5 for record 34')
INSERT INTO Payment_Method VALUES (35, 'Net Banking', 'Kotak Bank', 'Banking', 'active', 18.75, 'GBP', 975.00, 1, 'method_description record 35', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35', 'Additional detail 5 for record 35')
INSERT INTO Payment_Method VALUES (36, 'Net Banking', 'Bank of Baroda', 'Banking', 'active', 20.00, 'INR', 1000.00, 0, 'method_description record 36', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36', 'Additional detail 5 for record 36')
INSERT INTO Payment_Method VALUES (37, 'UPI', 'Google Pay', 'UPI', 'active', 21.25, 'USD', 1025.00, 1, 'method_description record 37', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37', 'Additional detail 5 for record 37')
INSERT INTO Payment_Method VALUES (38, 'UPI', 'PhonePe', 'UPI', 'active', 22.50, 'EUR', 1050.00, 0, 'method_description record 38', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38', 'Additional detail 5 for record 38')
INSERT INTO Payment_Method VALUES (39, 'UPI', 'Paytm', 'UPI', 'inactive', 23.75, 'GBP', 1075.00, 1, 'method_description record 39', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39', 'Additional detail 5 for record 39')
INSERT INTO Payment_Method VALUES (40, 'UPI', 'Amazon Pay', 'UPI', 'active', 0.00, 'INR', 1100.00, 0, 'method_description record 40', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40', 'Additional detail 5 for record 40')
INSERT INTO Payment_Method VALUES (41, 'Credit Card', 'Visa', 'Card', 'active', 1.25, 'USD', 1125.00, 1, 'method_description record 41', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41', 'Additional detail 5 for record 41')
INSERT INTO Payment_Method VALUES (42, 'Credit Card', 'Mastercard', 'Card', 'inactive', 2.50, 'EUR', 1150.00, 0, 'method_description record 42', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42', 'Additional detail 5 for record 42')
INSERT INTO Payment_Method VALUES (43, 'Debit Card', 'Visa', 'Card', 'active', 3.75, 'GBP', 1175.00, 1, 'method_description record 43', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43', 'Additional detail 5 for record 43')
INSERT INTO Payment_Method VALUES (44, 'Debit Card', 'RuPay', 'Card', 'active', 5.00, 'INR', 1200.00, 0, 'method_description record 44', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44', 'Additional detail 5 for record 44')
INSERT INTO Payment_Method VALUES (45, 'Net Banking', 'SBI', 'Banking', 'active', 6.25, 'USD', 1225.00, 1, 'method_description record 45', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45', 'Additional detail 5 for record 45')
INSERT INTO Payment_Method VALUES (46, 'Net Banking', 'HDFC Bank', 'Banking', 'active', 7.50, 'EUR', 1250.00, 0, 'method_description record 46', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46', 'Additional detail 5 for record 46')
INSERT INTO Payment_Method VALUES (47, 'Net Banking', 'ICICI Bank', 'Banking', 'inactive', 8.75, 'GBP', 1275.00, 1, 'method_description record 47', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47', 'Additional detail 5 for record 47')
INSERT INTO Payment_Method VALUES (48, 'Net Banking', 'Axis Bank', 'Banking', 'active', 10.00, 'INR', 1300.00, 0, 'method_description record 48', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48', 'Additional detail 5 for record 48')
INSERT INTO Payment_Method VALUES (49, 'UPI', 'BHIM', 'UPI', 'active', 11.25, 'USD', 1325.00, 1, 'method_description record 49', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49', 'Additional detail 5 for record 49')
INSERT INTO Payment_Method VALUES (50, 'UPI', 'WhatsApp Pay', 'UPI', 'active', 12.50, 'EUR', 1350.00, 0, 'method_description record 50', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50', 'Additional detail 5 for record 50')

INSERT INTO Payment VALUES (1, 1, 1, 'TXN100001', '2026-01-01', 199.00, 'successful', 'USD', 1.25, 1.25, 'Razorpay', 'not_requested', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01')
INSERT INTO Payment VALUES (2, 2, 2, 'TXN100002', '2026-01-02', 299.00, 'successful', 'EUR', 2.50, 2.50, 'Stripe', 'processed', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02')
INSERT INTO Payment VALUES (3, 3, 3, 'TXN100003', '2026-01-03', 399.00, 'successful', 'GBP', 3.75, 3.75, 'PayPal', 'none', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03')
INSERT INTO Payment VALUES (4, 4, 4, 'TXN100004', '2026-01-04', 499.00, 'successful', 'INR', 5.00, 5.00, 'PayU', 'not_requested', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04')
INSERT INTO Payment VALUES (5, 5, 5, 'TXN100005', '2026-01-05', 599.00, 'successful', 'USD', 6.25, 6.25, 'Razorpay', 'processed', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05')
INSERT INTO Payment VALUES (6, 6, 6, 'TXN100006', '2026-01-06', 699.00, 'successful', 'EUR', 7.50, 7.50, 'Stripe', 'none', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06')
INSERT INTO Payment VALUES (7, 7, 7, 'TXN100007', '2026-01-07', 799.00, 'successful', 'GBP', 8.75, 8.75, 'PayPal', 'not_requested', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07')
INSERT INTO Payment VALUES (8, 8, 8, 'TXN100008', '2026-01-08', 899.00, 'successful', 'INR', 10.00, 10.00, 'PayU', 'processed', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08')
INSERT INTO Payment VALUES (9, 9, 9, 'TXN100009', '2026-01-09', 999.00, 'successful', 'USD', 11.25, 11.25, 'Razorpay', 'none', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09')
INSERT INTO Payment VALUES (10, 10, 10, 'TXN100010', '2026-01-10', 1099.00, 'successful', 'EUR', 12.50, 12.50, 'Stripe', 'not_requested', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10')
INSERT INTO Payment VALUES (11, 11, 11, 'TXN100011', '2026-01-11', 1199.00, 'successful', 'GBP', 13.75, 13.75, 'PayPal', 'processed', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11')
INSERT INTO Payment VALUES (12, 12, 12, 'TXN100012', '2026-01-12', 1299.00, 'successful', 'INR', 15.00, 15.00, 'PayU', 'none', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12')
INSERT INTO Payment VALUES (13, 13, 13, 'TXN100013', '2026-01-13', 1399.00, 'pending', 'USD', 16.25, 16.25, 'Razorpay', 'not_requested', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13')
INSERT INTO Payment VALUES (14, 14, 14, 'TXN100014', '2026-01-14', 1499.00, 'successful', 'EUR', 17.50, 17.50, 'Stripe', 'processed', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14')
INSERT INTO Payment VALUES (15, 15, 15, 'TXN100015', '2026-01-15', 1599.00, 'successful', 'GBP', 18.75, 18.75, 'PayPal', 'none', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15')
INSERT INTO Payment VALUES (16, 16, 16, 'TXN100016', '2026-01-16', 1699.00, 'successful', 'INR', 20.00, 20.00, 'PayU', 'not_requested', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16')
INSERT INTO Payment VALUES (17, 17, 17, 'TXN100017', '2026-01-17', 1799.00, 'failed', 'USD', 21.25, 21.25, 'Razorpay', 'processed', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17')
INSERT INTO Payment VALUES (18, 18, 18, 'TXN100018', '2026-01-18', 1899.00, 'successful', 'EUR', 22.50, 22.50, 'Stripe', 'none', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18')
INSERT INTO Payment VALUES (19, 19, 19, 'TXN100019', '2026-01-19', 1999.00, 'successful', 'GBP', 23.75, 23.75, 'PayPal', 'not_requested', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19')
INSERT INTO Payment VALUES (20, 20, 20, 'TXN100020', '2026-01-20', 2099.00, 'successful', 'INR', 0.00, 0.00, 'PayU', 'processed', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20')
INSERT INTO Payment VALUES (21, 21, 21, 'TXN100021', '2026-01-21', 2199.00, 'successful', 'USD', 1.25, 1.25, 'Razorpay', 'none', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21')
INSERT INTO Payment VALUES (22, 22, 22, 'TXN100022', '2026-01-22', 2299.00, 'successful', 'EUR', 2.50, 2.50, 'Stripe', 'not_requested', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22')
INSERT INTO Payment VALUES (23, 23, 23, 'TXN100023', '2026-01-23', 2399.00, 'refunded', 'GBP', 3.75, 3.75, 'PayPal', 'processed', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23')
INSERT INTO Payment VALUES (24, 24, 24, 'TXN100024', '2026-01-24', 2499.00, 'successful', 'INR', 5.00, 5.00, 'PayU', 'none', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24')
INSERT INTO Payment VALUES (25, 25, 25, 'TXN100025', '2026-01-25', 2599.00, 'successful', 'USD', 6.25, 6.25, 'Razorpay', 'not_requested', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25')
INSERT INTO Payment VALUES (26, 26, 26, 'TXN100026', '2026-01-26', 2699.00, 'successful', 'EUR', 7.50, 7.50, 'Stripe', 'processed', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26')
INSERT INTO Payment VALUES (27, 27, 27, 'TXN100027', '2026-01-27', 2799.00, 'pending', 'GBP', 8.75, 8.75, 'PayPal', 'none', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27')
INSERT INTO Payment VALUES (28, 28, 28, 'TXN100028', '2026-01-28', 2899.00, 'successful', 'INR', 10.00, 10.00, 'PayU', 'not_requested', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28')
INSERT INTO Payment VALUES (29, 29, 29, 'TXN100029', '2026-01-29', 2999.00, 'successful', 'USD', 11.25, 11.25, 'Razorpay', 'processed', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29')
INSERT INTO Payment VALUES (30, 30, 30, 'TXN100030', '2026-01-30', 3099.00, 'successful', 'EUR', 12.50, 12.50, 'Stripe', 'none', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30')
INSERT INTO Payment VALUES (31, 31, 31, 'TXN100031', '2026-01-31', 3199.00, 'successful', 'GBP', 13.75, 13.75, 'PayPal', 'not_requested', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31')
INSERT INTO Payment VALUES (32, 32, 32, 'TXN100032', '2026-02-01', 3299.00, 'successful', 'INR', 15.00, 15.00, 'PayU', 'processed', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32')
INSERT INTO Payment VALUES (33, 33, 33, 'TXN100033', '2026-02-02', 3399.00, 'successful', 'USD', 16.25, 16.25, 'Razorpay', 'none', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33')
INSERT INTO Payment VALUES (34, 34, 34, 'TXN100034', '2026-02-03', 3499.00, 'failed', 'EUR', 17.50, 17.50, 'Stripe', 'not_requested', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34')
INSERT INTO Payment VALUES (35, 35, 35, 'TXN100035', '2026-02-04', 3599.00, 'successful', 'GBP', 18.75, 18.75, 'PayPal', 'processed', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35')
INSERT INTO Payment VALUES (36, 36, 36, 'TXN100036', '2026-02-05', 3699.00, 'successful', 'INR', 20.00, 20.00, 'PayU', 'none', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36')
INSERT INTO Payment VALUES (37, 37, 37, 'TXN100037', '2026-02-06', 3799.00, 'successful', 'USD', 21.25, 21.25, 'Razorpay', 'not_requested', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37')
INSERT INTO Payment VALUES (38, 38, 38, 'TXN100038', '2026-02-07', 3899.00, 'successful', 'EUR', 22.50, 22.50, 'Stripe', 'processed', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38')
INSERT INTO Payment VALUES (39, 39, 39, 'TXN100039', '2026-02-08', 3999.00, 'refunded', 'GBP', 23.75, 23.75, 'PayPal', 'none', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39')
INSERT INTO Payment VALUES (40, 40, 40, 'TXN100040', '2026-02-09', 4099.00, 'successful', 'INR', 0.00, 0.00, 'PayU', 'not_requested', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40')
INSERT INTO Payment VALUES (41, 41, 41, 'TXN100041', '2026-02-10', 4199.00, 'successful', 'USD', 1.25, 1.25, 'Razorpay', 'processed', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41')
INSERT INTO Payment VALUES (42, 42, 42, 'TXN100042', '2026-02-11', 4299.00, 'successful', 'EUR', 2.50, 2.50, 'Stripe', 'none', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42')
INSERT INTO Payment VALUES (43, 43, 43, 'TXN100043', '2026-02-12', 4399.00, 'pending', 'GBP', 3.75, 3.75, 'PayPal', 'not_requested', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43')
INSERT INTO Payment VALUES (44, 44, 44, 'TXN100044', '2026-02-13', 4499.00, 'successful', 'INR', 5.00, 5.00, 'PayU', 'processed', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44')
INSERT INTO Payment VALUES (45, 45, 45, 'TXN100045', '2026-02-14', 4599.00, 'successful', 'USD', 6.25, 6.25, 'Razorpay', 'none', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45')
INSERT INTO Payment VALUES (46, 46, 46, 'TXN100046', '2026-02-15', 4699.00, 'successful', 'EUR', 7.50, 7.50, 'Stripe', 'not_requested', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46')
INSERT INTO Payment VALUES (47, 47, 47, 'TXN100047', '2026-02-16', 4799.00, 'failed', 'GBP', 8.75, 8.75, 'PayPal', 'processed', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47')
INSERT INTO Payment VALUES (48, 48, 48, 'TXN100048', '2026-02-17', 4899.00, 'successful', 'INR', 10.00, 10.00, 'PayU', 'none', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48')
INSERT INTO Payment VALUES (49, 49, 49, 'TXN100049', '2026-02-18', 4999.00, 'successful', 'USD', 11.25, 11.25, 'Razorpay', 'not_requested', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49')
INSERT INTO Payment VALUES (50, 50, 50, 'TXN100050', '2026-02-19', 5099.00, 'successful', 'EUR', 12.50, 12.50, 'Stripe', 'processed', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50')

INSERT INTO Device VALUES (1, 1, 'Ravi Laptop', 'Laptop', 'Windows 11', 'active', '2026-01-01', 'Model-B', 'DEV-0001', '2.1.1', '2026-01-01', 1, 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01')
INSERT INTO Device VALUES (2, 2, 'Sita Mobile', 'Mobile', 'Android 15', 'active', '2026-01-02', 'Model-C', 'DEV-0002', '3.2.2', '2026-01-02', 0, 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02')
INSERT INTO Device VALUES (3, 3, 'Arjun Desktop', 'Desktop', 'Windows 10', 'active', '2026-01-03', 'Model-D', 'DEV-0003', '1.3.3', '2026-01-03', 1, 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03')
INSERT INTO Device VALUES (4, 4, 'Priya Tablet', 'Tablet', 'Android 14', 'active', '2026-01-04', 'Model-A', 'DEV-0004', '2.4.4', '2026-01-04', 0, 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04')
INSERT INTO Device VALUES (5, 5, 'Vikram Laptop', 'Laptop', 'Ubuntu 24.04', 'inactive', '2026-01-05', 'Model-B', 'DEV-0005', '3.5.0', '2026-01-05', 1, 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05')
INSERT INTO Device VALUES (6, 6, 'User6 Laptop', 'Laptop', 'iOS 18', 'active', '2026-01-06', 'Model-C', 'DEV-0006', '1.6.1', '2026-01-06', 0, 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06')
INSERT INTO Device VALUES (7, 7, 'User7 Mobile', 'Mobile', 'macOS Sequoia', 'inactive', '2026-01-07', 'Model-D', 'DEV-0007', '2.7.2', '2026-01-07', 1, 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07')
INSERT INTO Device VALUES (8, 8, 'User8 Desktop', 'Desktop', 'Windows 11', 'active', '2026-01-08', 'Model-A', 'DEV-0008', '3.8.3', '2026-01-08', 0, 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08')
INSERT INTO Device VALUES (9, 9, 'User9 Tablet', 'Tablet', 'Android 15', 'active', '2026-01-09', 'Model-B', 'DEV-0009', '1.9.4', '2026-01-09', 1, 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09')
INSERT INTO Device VALUES (10, 10, 'User10 Smart TV', 'Smart TV', 'Windows 10', 'active', '2026-01-10', 'Model-C', 'DEV-0010', '2.0.0', '2026-01-10', 0, 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10')
INSERT INTO Device VALUES (11, 11, 'User11 Laptop', 'Laptop', 'Android 14', 'active', '2026-01-11', 'Model-D', 'DEV-0011', '3.1.1', '2026-01-11', 1, 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11')
INSERT INTO Device VALUES (12, 12, 'User12 Mobile', 'Mobile', 'Ubuntu 24.04', 'active', '2026-01-12', 'Model-A', 'DEV-0012', '1.2.2', '2026-01-12', 0, 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12')
INSERT INTO Device VALUES (13, 13, 'User13 Desktop', 'Desktop', 'iOS 18', 'active', '2026-01-13', 'Model-B', 'DEV-0013', '2.3.3', '2026-01-13', 1, 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13')
INSERT INTO Device VALUES (14, 14, 'User14 Tablet', 'Tablet', 'macOS Sequoia', 'inactive', '2026-01-14', 'Model-C', 'DEV-0014', '3.4.4', '2026-01-14', 0, 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14')
INSERT INTO Device VALUES (15, 15, 'User15 Smart TV', 'Smart TV', 'Windows 11', 'active', '2026-01-15', 'Model-D', 'DEV-0015', '1.5.0', '2026-01-15', 1, 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15')
INSERT INTO Device VALUES (16, 16, 'User16 Laptop', 'Laptop', 'Android 15', 'active', '2026-01-16', 'Model-A', 'DEV-0016', '2.6.1', '2026-01-16', 0, 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16')
INSERT INTO Device VALUES (17, 17, 'User17 Mobile', 'Mobile', 'Windows 10', 'active', '2026-01-17', 'Model-B', 'DEV-0017', '3.7.2', '2026-01-17', 1, 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17')
INSERT INTO Device VALUES (18, 18, 'User18 Desktop', 'Desktop', 'Android 14', 'active', '2026-01-18', 'Model-C', 'DEV-0018', '1.8.3', '2026-01-18', 0, 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18')
INSERT INTO Device VALUES (19, 19, 'User19 Tablet', 'Tablet', 'Ubuntu 24.04', 'active', '2026-01-19', 'Model-D', 'DEV-0019', '2.9.4', '2026-01-19', 1, 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19')
INSERT INTO Device VALUES (20, 20, 'User20 Smart TV', 'Smart TV', 'iOS 18', 'active', '2026-01-20', 'Model-A', 'DEV-0020', '3.0.0', '2026-01-20', 0, 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20')
INSERT INTO Device VALUES (21, 21, 'User21 Laptop', 'Laptop', 'macOS Sequoia', 'inactive', '2026-01-21', 'Model-B', 'DEV-0021', '1.1.1', '2026-01-21', 1, 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21')
INSERT INTO Device VALUES (22, 22, 'User22 Mobile', 'Mobile', 'Windows 11', 'active', '2026-01-22', 'Model-C', 'DEV-0022', '2.2.2', '2026-01-22', 0, 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22')
INSERT INTO Device VALUES (23, 23, 'User23 Desktop', 'Desktop', 'Android 15', 'active', '2026-01-23', 'Model-D', 'DEV-0023', '3.3.3', '2026-01-23', 1, 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23')
INSERT INTO Device VALUES (24, 24, 'User24 Tablet', 'Tablet', 'Windows 10', 'active', '2026-01-24', 'Model-A', 'DEV-0024', '1.4.4', '2026-01-24', 0, 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24')
INSERT INTO Device VALUES (25, 25, 'User25 Smart TV', 'Smart TV', 'Android 14', 'active', '2026-01-25', 'Model-B', 'DEV-0025', '2.5.0', '2026-01-25', 1, 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25')
INSERT INTO Device VALUES (26, 26, 'User26 Laptop', 'Laptop', 'Ubuntu 24.04', 'active', '2026-01-26', 'Model-C', 'DEV-0026', '3.6.1', '2026-01-26', 0, 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26')
INSERT INTO Device VALUES (27, 27, 'User27 Mobile', 'Mobile', 'iOS 18', 'active', '2026-01-27', 'Model-D', 'DEV-0027', '1.7.2', '2026-01-27', 1, 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27')
INSERT INTO Device VALUES (28, 28, 'User28 Desktop', 'Desktop', 'macOS Sequoia', 'inactive', '2026-01-28', 'Model-A', 'DEV-0028', '2.8.3', '2026-01-28', 0, 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28')
INSERT INTO Device VALUES (29, 29, 'User29 Tablet', 'Tablet', 'Windows 11', 'active', '2026-01-29', 'Model-B', 'DEV-0029', '3.9.4', '2026-02-01', 1, 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29')
INSERT INTO Device VALUES (30, 30, 'User30 Smart TV', 'Smart TV', 'Android 15', 'active', '2026-01-30', 'Model-C', 'DEV-0030', '1.0.0', '2026-02-02', 0, 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30')
INSERT INTO Device VALUES (31, 31, 'User31 Laptop', 'Laptop', 'Windows 10', 'active', '2026-01-31', 'Model-D', 'DEV-0031', '2.1.1', '2026-02-03', 1, 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31')
INSERT INTO Device VALUES (32, 32, 'User32 Mobile', 'Mobile', 'Android 14', 'active', '2026-02-01', 'Model-A', 'DEV-0032', '3.2.2', '2026-02-04', 0, 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32')
INSERT INTO Device VALUES (33, 33, 'User33 Desktop', 'Desktop', 'Ubuntu 24.04', 'active', '2026-02-02', 'Model-B', 'DEV-0033', '1.3.3', '2026-02-05', 1, 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33')
INSERT INTO Device VALUES (34, 34, 'User34 Tablet', 'Tablet', 'iOS 18', 'active', '2026-02-03', 'Model-C', 'DEV-0034', '2.4.4', '2026-02-06', 0, 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34')
INSERT INTO Device VALUES (35, 35, 'User35 Smart TV', 'Smart TV', 'macOS Sequoia', 'inactive', '2026-02-04', 'Model-D', 'DEV-0035', '3.5.0', '2026-02-07', 1, 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35')
INSERT INTO Device VALUES (36, 36, 'User36 Laptop', 'Laptop', 'Windows 11', 'active', '2026-02-05', 'Model-A', 'DEV-0036', '1.6.1', '2026-02-08', 0, 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36')
INSERT INTO Device VALUES (37, 37, 'User37 Mobile', 'Mobile', 'Android 15', 'active', '2026-02-06', 'Model-B', 'DEV-0037', '2.7.2', '2026-02-09', 1, 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37')
INSERT INTO Device VALUES (38, 38, 'User38 Desktop', 'Desktop', 'Windows 10', 'active', '2026-02-07', 'Model-C', 'DEV-0038', '3.8.3', '2026-02-10', 0, 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38')
INSERT INTO Device VALUES (39, 39, 'User39 Tablet', 'Tablet', 'Android 14', 'active', '2026-02-08', 'Model-D', 'DEV-0039', '1.9.4', '2026-02-11', 1, 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39')
INSERT INTO Device VALUES (40, 40, 'User40 Smart TV', 'Smart TV', 'Ubuntu 24.04', 'active', '2026-02-09', 'Model-A', 'DEV-0040', '2.0.0', '2026-02-12', 0, 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40')
INSERT INTO Device VALUES (41, 41, 'User41 Laptop', 'Laptop', 'iOS 18', 'active', '2026-02-10', 'Model-B', 'DEV-0041', '3.1.1', '2026-02-13', 1, 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41')
INSERT INTO Device VALUES (42, 42, 'User42 Mobile', 'Mobile', 'macOS Sequoia', 'inactive', '2026-02-11', 'Model-C', 'DEV-0042', '1.2.2', '2026-02-14', 0, 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42')
INSERT INTO Device VALUES (43, 43, 'User43 Desktop', 'Desktop', 'Windows 11', 'active', '2026-02-12', 'Model-D', 'DEV-0043', '2.3.3', '2026-02-15', 1, 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43')
INSERT INTO Device VALUES (44, 44, 'User44 Tablet', 'Tablet', 'Android 15', 'active', '2026-02-13', 'Model-A', 'DEV-0044', '3.4.4', '2026-02-16', 0, 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44')
INSERT INTO Device VALUES (45, 45, 'User45 Smart TV', 'Smart TV', 'Windows 10', 'active', '2026-02-14', 'Model-B', 'DEV-0045', '1.5.0', '2026-02-17', 1, 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45')
INSERT INTO Device VALUES (46, 46, 'User46 Laptop', 'Laptop', 'Android 14', 'active', '2026-02-15', 'Model-C', 'DEV-0046', '2.6.1', '2026-02-18', 0, 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46')
INSERT INTO Device VALUES (47, 47, 'User47 Mobile', 'Mobile', 'Ubuntu 24.04', 'active', '2026-02-16', 'Model-D', 'DEV-0047', '3.7.2', '2026-02-19', 1, 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47')
INSERT INTO Device VALUES (48, 48, 'User48 Desktop', 'Desktop', 'iOS 18', 'active', '2026-02-17', 'Model-A', 'DEV-0048', '1.8.3', '2026-02-20', 0, 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48')
INSERT INTO Device VALUES (49, 49, 'User49 Tablet', 'Tablet', 'macOS Sequoia', 'inactive', '2026-02-18', 'Model-B', 'DEV-0049', '2.9.4', '2026-02-21', 1, 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49')
INSERT INTO Device VALUES (50, 50, 'User50 Smart TV', 'Smart TV', 'Windows 11', 'active', '2026-02-19', 'Model-C', 'DEV-0050', '3.0.0', '2026-02-22', 0, 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50')

INSERT INTO User_Device VALUES (1, 1, 1, '2026-01-01', 'active', 'Work laptop', 1, '2026-01-01', 'restricted', 'notes record 01', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01', 'Additional detail 5 for record 01')
INSERT INTO User_Device VALUES (2, 2, 2, '2026-01-02', 'active', 'Tablet', 0, '2026-01-02', 'full', 'notes record 02', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02', 'Additional detail 5 for record 02')
INSERT INTO User_Device VALUES (3, 3, 3, '2026-01-03', 'active', 'Home PC', 1, '2026-01-03', 'standard', 'notes record 03', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03', 'Additional detail 5 for record 03')
INSERT INTO User_Device VALUES (4, 4, 4, '2026-01-04', 'active', 'Personal phone', 0, '2026-01-04', 'restricted', 'notes record 04', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04', 'Additional detail 5 for record 04')
INSERT INTO User_Device VALUES (5, 5, 5, '2026-01-05', 'inactive', 'Work laptop', 1, '2026-01-05', 'full', 'notes record 05', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05', 'Additional detail 5 for record 05')
INSERT INTO User_Device VALUES (6, 6, 6, '2026-01-06', 'active', 'Tablet', 0, '2026-01-06', 'standard', 'notes record 06', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06', 'Additional detail 5 for record 06')
INSERT INTO User_Device VALUES (7, 7, 7, '2026-01-07', 'inactive', 'Home PC', 1, '2026-01-07', 'restricted', 'notes record 07', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07', 'Additional detail 5 for record 07')
INSERT INTO User_Device VALUES (8, 8, 8, '2026-01-08', 'active', 'Personal phone', 0, '2026-01-08', 'full', 'notes record 08', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08', 'Additional detail 5 for record 08')
INSERT INTO User_Device VALUES (9, 9, 9, '2026-01-09', 'active', 'Work laptop', 1, '2026-01-09', 'standard', 'notes record 09', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09', 'Additional detail 5 for record 09')
INSERT INTO User_Device VALUES (10, 10, 10, '2026-01-10', 'active', 'Tablet', 0, '2026-01-10', 'restricted', 'notes record 10', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10', 'Additional detail 5 for record 10')
INSERT INTO User_Device VALUES (11, 11, 11, '2026-01-11', 'active', 'Home PC', 1, '2026-01-11', 'full', 'notes record 11', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11', 'Additional detail 5 for record 11')
INSERT INTO User_Device VALUES (12, 12, 12, '2026-01-12', 'active', 'Personal phone', 0, '2026-01-12', 'standard', 'notes record 12', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12', 'Additional detail 5 for record 12')
INSERT INTO User_Device VALUES (13, 13, 13, '2026-01-13', 'active', 'Work laptop', 1, '2026-01-13', 'restricted', 'notes record 13', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13', 'Additional detail 5 for record 13')
INSERT INTO User_Device VALUES (14, 14, 14, '2026-01-14', 'inactive', 'Tablet', 0, '2026-01-14', 'full', 'notes record 14', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14', 'Additional detail 5 for record 14')
INSERT INTO User_Device VALUES (15, 15, 15, '2026-01-15', 'active', 'Home PC', 1, '2026-01-15', 'standard', 'notes record 15', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15', 'Additional detail 5 for record 15')
INSERT INTO User_Device VALUES (16, 16, 16, '2026-01-16', 'active', 'Personal phone', 0, '2026-01-16', 'restricted', 'notes record 16', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16', 'Additional detail 5 for record 16')
INSERT INTO User_Device VALUES (17, 17, 17, '2026-01-17', 'active', 'Work laptop', 1, '2026-01-17', 'full', 'notes record 17', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17', 'Additional detail 5 for record 17')
INSERT INTO User_Device VALUES (18, 18, 18, '2026-01-18', 'active', 'Tablet', 0, '2026-01-18', 'standard', 'notes record 18', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18', 'Additional detail 5 for record 18')
INSERT INTO User_Device VALUES (19, 19, 19, '2026-01-19', 'active', 'Home PC', 1, '2026-01-19', 'restricted', 'notes record 19', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19', 'Additional detail 5 for record 19')
INSERT INTO User_Device VALUES (20, 20, 20, '2026-01-20', 'active', 'Personal phone', 0, '2026-01-20', 'full', 'notes record 20', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20', 'Additional detail 5 for record 20')
INSERT INTO User_Device VALUES (21, 21, 21, '2026-01-21', 'inactive', 'Work laptop', 1, '2026-01-21', 'standard', 'notes record 21', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21', 'Additional detail 5 for record 21')
INSERT INTO User_Device VALUES (22, 22, 22, '2026-01-22', 'active', 'Tablet', 0, '2026-01-22', 'restricted', 'notes record 22', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22', 'Additional detail 5 for record 22')
INSERT INTO User_Device VALUES (23, 23, 23, '2026-01-23', 'active', 'Home PC', 1, '2026-01-23', 'full', 'notes record 23', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23', 'Additional detail 5 for record 23')
INSERT INTO User_Device VALUES (24, 24, 24, '2026-01-24', 'active', 'Personal phone', 0, '2026-01-24', 'standard', 'notes record 24', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24', 'Additional detail 5 for record 24')
INSERT INTO User_Device VALUES (25, 25, 25, '2026-01-25', 'active', 'Work laptop', 1, '2026-01-25', 'restricted', 'notes record 25', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25', 'Additional detail 5 for record 25')
INSERT INTO User_Device VALUES (26, 26, 26, '2026-01-26', 'active', 'Tablet', 0, '2026-01-26', 'full', 'notes record 26', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26', 'Additional detail 5 for record 26')
INSERT INTO User_Device VALUES (27, 27, 27, '2026-01-27', 'active', 'Home PC', 1, '2026-01-27', 'standard', 'notes record 27', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27', 'Additional detail 5 for record 27')
INSERT INTO User_Device VALUES (28, 28, 28, '2026-01-28', 'inactive', 'Personal phone', 0, '2026-01-28', 'restricted', 'notes record 28', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28', 'Additional detail 5 for record 28')
INSERT INTO User_Device VALUES (29, 29, 29, '2026-01-29', 'active', 'Work laptop', 1, '2026-02-01', 'full', 'notes record 29', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29', 'Additional detail 5 for record 29')
INSERT INTO User_Device VALUES (30, 30, 30, '2026-01-30', 'active', 'Tablet', 0, '2026-02-02', 'standard', 'notes record 30', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30', 'Additional detail 5 for record 30')
INSERT INTO User_Device VALUES (31, 31, 31, '2026-01-31', 'active', 'Home PC', 1, '2026-02-03', 'restricted', 'notes record 31', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31', 'Additional detail 5 for record 31')
INSERT INTO User_Device VALUES (32, 32, 32, '2026-02-01', 'active', 'Personal phone', 0, '2026-02-04', 'full', 'notes record 32', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32', 'Additional detail 5 for record 32')
INSERT INTO User_Device VALUES (33, 33, 33, '2026-02-02', 'active', 'Work laptop', 1, '2026-02-05', 'standard', 'notes record 33', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33', 'Additional detail 5 for record 33')
INSERT INTO User_Device VALUES (34, 34, 34, '2026-02-03', 'active', 'Tablet', 0, '2026-02-06', 'restricted', 'notes record 34', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34', 'Additional detail 5 for record 34')
INSERT INTO User_Device VALUES (35, 35, 35, '2026-02-04', 'inactive', 'Home PC', 1, '2026-02-07', 'full', 'notes record 35', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35', 'Additional detail 5 for record 35')
INSERT INTO User_Device VALUES (36, 36, 36, '2026-02-05', 'active', 'Personal phone', 0, '2026-02-08', 'standard', 'notes record 36', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36', 'Additional detail 5 for record 36')
INSERT INTO User_Device VALUES (37, 37, 37, '2026-02-06', 'active', 'Work laptop', 1, '2026-02-09', 'restricted', 'notes record 37', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37', 'Additional detail 5 for record 37')
INSERT INTO User_Device VALUES (38, 38, 38, '2026-02-07', 'active', 'Tablet', 0, '2026-02-10', 'full', 'notes record 38', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38', 'Additional detail 5 for record 38')
INSERT INTO User_Device VALUES (39, 39, 39, '2026-02-08', 'active', 'Home PC', 1, '2026-02-11', 'standard', 'notes record 39', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39', 'Additional detail 5 for record 39')
INSERT INTO User_Device VALUES (40, 40, 40, '2026-02-09', 'active', 'Personal phone', 0, '2026-02-12', 'restricted', 'notes record 40', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40', 'Additional detail 5 for record 40')
INSERT INTO User_Device VALUES (41, 41, 41, '2026-02-10', 'active', 'Work laptop', 1, '2026-02-13', 'full', 'notes record 41', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41', 'Additional detail 5 for record 41')
INSERT INTO User_Device VALUES (42, 42, 42, '2026-02-11', 'inactive', 'Tablet', 0, '2026-02-14', 'standard', 'notes record 42', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42', 'Additional detail 5 for record 42')
INSERT INTO User_Device VALUES (43, 43, 43, '2026-02-12', 'active', 'Home PC', 1, '2026-02-15', 'restricted', 'notes record 43', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43', 'Additional detail 5 for record 43')
INSERT INTO User_Device VALUES (44, 44, 44, '2026-02-13', 'active', 'Personal phone', 0, '2026-02-16', 'full', 'notes record 44', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44', 'Additional detail 5 for record 44')
INSERT INTO User_Device VALUES (45, 45, 45, '2026-02-14', 'active', 'Work laptop', 1, '2026-02-17', 'standard', 'notes record 45', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45', 'Additional detail 5 for record 45')
INSERT INTO User_Device VALUES (46, 46, 46, '2026-02-15', 'active', 'Tablet', 0, '2026-02-18', 'restricted', 'notes record 46', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46', 'Additional detail 5 for record 46')
INSERT INTO User_Device VALUES (47, 47, 47, '2026-02-16', 'active', 'Home PC', 1, '2026-02-19', 'full', 'notes record 47', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47', 'Additional detail 5 for record 47')
INSERT INTO User_Device VALUES (48, 48, 48, '2026-02-17', 'active', 'Personal phone', 0, '2026-02-20', 'standard', 'notes record 48', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48', 'Additional detail 5 for record 48')
INSERT INTO User_Device VALUES (49, 49, 49, '2026-02-18', 'inactive', 'Work laptop', 1, '2026-02-21', 'restricted', 'notes record 49', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49', 'Additional detail 5 for record 49')
INSERT INTO User_Device VALUES (50, 50, 50, '2026-02-19', 'active', 'Tablet', 0, '2026-02-22', 'full', 'notes record 50', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50', 'Additional detail 5 for record 50')

INSERT INTO VPN_Session VALUES (1, 1, 1, 1, '2026-01-10 09:00:00', '2026-01-10 10:00:00', 'disconnected', '172.16.1.1', 18, 1048576, 1048576, 'US', 'completed', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01')
INSERT INTO VPN_Session VALUES (2, 2, 2, 2, '2026-01-11 10:00:00', NULL, 'connected', '172.16.1.2', 21, 2097152, 2097152, 'GB', 'network reset', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02')
INSERT INTO VPN_Session VALUES (3, 3, 3, 3, '2026-01-12 11:00:00', '2026-01-12 12:00:00', 'disconnected', '172.16.1.3', 24, 3145728, 3145728, 'SG', 'user request', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03')
INSERT INTO VPN_Session VALUES (4, 4, 4, 4, '2026-01-13 12:00:00', NULL, 'connected', '172.16.1.4', 27, 4194304, 4194304, 'DE', 'completed', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04')
INSERT INTO VPN_Session VALUES (5, 5, 5, 5, '2026-01-14 13:00:00', '2026-01-14 13:30:00', 'failed', '172.16.1.5', 30, 5242880, 5242880, 'IN', 'network reset', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05')
INSERT INTO VPN_Session VALUES (6, 6, 6, 6, '2026-01-15 14:00:00', NULL, 'connected', '172.16.1.6', 33, 6291456, 6291456, 'US', 'user request', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06')
INSERT INTO VPN_Session VALUES (7, 7, 7, 7, '2026-01-16 15:00:00', '2026-01-16 16:00:00', 'disconnected', '172.16.1.7', 36, 7340032, 7340032, 'GB', 'completed', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07')
INSERT INTO VPN_Session VALUES (8, 8, 8, 8, '2026-01-17 16:00:00', '2026-01-17 17:00:00', 'disconnected', '172.16.1.8', 39, 8388608, 8388608, 'SG', 'network reset', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08')
INSERT INTO VPN_Session VALUES (9, 9, 9, 9, '2026-01-18 17:00:00', NULL, 'connected', '172.16.1.9', 42, 9437184, 9437184, 'DE', 'user request', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09')
INSERT INTO VPN_Session VALUES (10, 10, 10, 10, '2026-01-19 18:00:00', '2026-01-19 19:00:00', 'failed', '172.16.1.10', 45, 10485760, 10485760, 'IN', 'completed', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10')
INSERT INTO VPN_Session VALUES (11, 11, 11, 11, '2026-01-20 19:00:00', '2026-01-20 20:00:00', 'disconnected', '172.16.1.11', 48, 11534336, 11534336, 'US', 'network reset', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11')
INSERT INTO VPN_Session VALUES (12, 12, 12, 12, '2026-01-21 08:00:00', NULL, 'connected', '172.16.1.12', 51, 12582912, 12582912, 'GB', 'user request', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12')
INSERT INTO VPN_Session VALUES (13, 13, 13, 13, '2026-01-22 09:00:00', '2026-01-22 10:00:00', 'disconnected', '172.16.1.13', 54, 13631488, 13631488, 'SG', 'completed', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13')
INSERT INTO VPN_Session VALUES (14, 14, 14, 14, '2026-01-23 10:00:00', '2026-01-23 11:00:00', 'disconnected', '172.16.1.14', 57, 14680064, 14680064, 'DE', 'network reset', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14')
INSERT INTO VPN_Session VALUES (15, 15, 15, 15, '2026-01-24 11:00:00', NULL, 'connected', '172.16.1.15', 60, 15728640, 15728640, 'IN', 'user request', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15')
INSERT INTO VPN_Session VALUES (16, 16, 16, 16, '2026-01-25 12:00:00', '2026-01-25 13:00:00', 'disconnected', '172.16.1.16', 63, 16777216, 16777216, 'US', 'completed', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16')
INSERT INTO VPN_Session VALUES (17, 17, 17, 17, '2026-01-26 13:00:00', '2026-01-26 14:00:00', 'disconnected', '172.16.1.17', 66, 17825792, 17825792, 'GB', 'network reset', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17')
INSERT INTO VPN_Session VALUES (18, 18, 18, 18, '2026-01-27 14:00:00', NULL, 'connected', '172.16.1.18', 69, 18874368, 18874368, 'SG', 'user request', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18')
INSERT INTO VPN_Session VALUES (19, 19, 19, 19, '2026-01-28 15:00:00', '2026-01-28 16:00:00', 'disconnected', '172.16.1.19', 72, 19922944, 19922944, 'DE', 'completed', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19')
INSERT INTO VPN_Session VALUES (20, 20, 20, 20, '2026-01-29 16:00:00', '2026-01-29 17:00:00', 'failed', '172.16.1.20', 75, 20971520, 20971520, 'IN', 'network reset', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20')
INSERT INTO VPN_Session VALUES (21, 21, 21, 21, '2026-01-30 17:00:00', NULL, 'connected', '172.16.1.21', 78, 22020096, 22020096, 'US', 'user request', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21')
INSERT INTO VPN_Session VALUES (22, 22, 22, 22, '2026-01-31 18:00:00', '2026-01-31 19:00:00', 'disconnected', '172.16.1.22', 81, 23068672, 23068672, 'GB', 'completed', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22')
INSERT INTO VPN_Session VALUES (23, 23, 23, 23, '2026-02-01 19:00:00', '2026-02-01 20:00:00', 'disconnected', '172.16.1.23', 84, 24117248, 24117248, 'SG', 'network reset', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23')
INSERT INTO VPN_Session VALUES (24, 24, 24, 24, '2026-02-02 08:00:00', NULL, 'connected', '172.16.1.24', 87, 25165824, 25165824, 'DE', 'user request', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24')
INSERT INTO VPN_Session VALUES (25, 25, 25, 25, '2026-02-03 09:00:00', '2026-02-03 10:00:00', 'failed', '172.16.1.25', 90, 26214400, 26214400, 'IN', 'completed', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25')
INSERT INTO VPN_Session VALUES (26, 26, 26, 26, '2026-02-04 10:00:00', '2026-02-04 11:00:00', 'disconnected', '172.16.1.26', 93, 27262976, 27262976, 'US', 'network reset', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26')
INSERT INTO VPN_Session VALUES (27, 27, 27, 27, '2026-02-05 11:00:00', NULL, 'connected', '172.16.1.27', 96, 28311552, 28311552, 'GB', 'user request', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27')
INSERT INTO VPN_Session VALUES (28, 28, 28, 28, '2026-02-06 12:00:00', '2026-02-06 13:00:00', 'disconnected', '172.16.1.28', 99, 29360128, 29360128, 'SG', 'completed', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28')
INSERT INTO VPN_Session VALUES (29, 29, 29, 29, '2026-02-07 13:00:00', '2026-02-07 14:00:00', 'disconnected', '172.16.1.29', 102, 30408704, 30408704, 'DE', 'network reset', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29')
INSERT INTO VPN_Session VALUES (30, 30, 30, 30, '2026-02-08 14:00:00', NULL, 'connected', '172.16.1.30', 105, 31457280, 31457280, 'IN', 'user request', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30')
INSERT INTO VPN_Session VALUES (31, 31, 31, 31, '2026-02-09 15:00:00', '2026-02-09 16:00:00', 'disconnected', '172.16.1.31', 108, 32505856, 32505856, 'US', 'completed', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31')
INSERT INTO VPN_Session VALUES (32, 32, 32, 32, '2026-02-10 16:00:00', '2026-02-10 17:00:00', 'disconnected', '172.16.1.32', 111, 33554432, 33554432, 'GB', 'network reset', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32')
INSERT INTO VPN_Session VALUES (33, 33, 33, 33, '2026-02-11 17:00:00', NULL, 'connected', '172.16.1.33', 114, 34603008, 34603008, 'SG', 'user request', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33')
INSERT INTO VPN_Session VALUES (34, 34, 34, 34, '2026-02-12 18:00:00', '2026-02-12 19:00:00', 'disconnected', '172.16.1.34', 117, 35651584, 35651584, 'DE', 'completed', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34')
INSERT INTO VPN_Session VALUES (35, 35, 35, 35, '2026-02-13 19:00:00', '2026-02-13 20:00:00', 'failed', '172.16.1.35', 120, 36700160, 36700160, 'IN', 'network reset', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35')
INSERT INTO VPN_Session VALUES (36, 36, 36, 36, '2026-02-14 08:00:00', NULL, 'connected', '172.16.1.36', 123, 37748736, 37748736, 'US', 'user request', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36')
INSERT INTO VPN_Session VALUES (37, 37, 37, 37, '2026-02-15 09:00:00', '2026-02-15 10:00:00', 'disconnected', '172.16.1.37', 126, 38797312, 38797312, 'GB', 'completed', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37')
INSERT INTO VPN_Session VALUES (38, 38, 38, 38, '2026-02-16 10:00:00', '2026-02-16 11:00:00', 'disconnected', '172.16.1.38', 129, 39845888, 39845888, 'SG', 'network reset', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38')
INSERT INTO VPN_Session VALUES (39, 39, 39, 39, '2026-02-17 11:00:00', NULL, 'connected', '172.16.1.39', 132, 40894464, 40894464, 'DE', 'user request', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39')
INSERT INTO VPN_Session VALUES (40, 40, 40, 40, '2026-02-18 12:00:00', '2026-02-18 13:00:00', 'failed', '172.16.1.40', 135, 41943040, 41943040, 'IN', 'completed', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40')
INSERT INTO VPN_Session VALUES (41, 41, 41, 41, '2026-02-19 13:00:00', '2026-02-19 14:00:00', 'disconnected', '172.16.1.41', 138, 42991616, 42991616, 'US', 'network reset', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41')
INSERT INTO VPN_Session VALUES (42, 42, 42, 42, '2026-02-20 14:00:00', NULL, 'connected', '172.16.1.42', 141, 44040192, 44040192, 'GB', 'user request', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42')
INSERT INTO VPN_Session VALUES (43, 43, 43, 43, '2026-02-21 15:00:00', '2026-02-21 16:00:00', 'disconnected', '172.16.1.43', 144, 45088768, 45088768, 'SG', 'completed', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43')
INSERT INTO VPN_Session VALUES (44, 44, 44, 44, '2026-02-22 16:00:00', '2026-02-22 17:00:00', 'disconnected', '172.16.1.44', 147, 46137344, 46137344, 'DE', 'network reset', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44')
INSERT INTO VPN_Session VALUES (45, 45, 45, 45, '2026-02-23 17:00:00', NULL, 'connected', '172.16.1.45', 150, 47185920, 47185920, 'IN', 'user request', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45')
INSERT INTO VPN_Session VALUES (46, 46, 46, 46, '2026-02-24 18:00:00', '2026-02-24 19:00:00', 'disconnected', '172.16.1.46', 153, 48234496, 48234496, 'US', 'completed', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46')
INSERT INTO VPN_Session VALUES (47, 47, 47, 47, '2026-02-25 19:00:00', '2026-02-25 20:00:00', 'disconnected', '172.16.1.47', 156, 49283072, 49283072, 'GB', 'network reset', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47')
INSERT INTO VPN_Session VALUES (48, 48, 48, 48, '2026-02-26 08:00:00', NULL, 'connected', '172.16.1.48', 159, 50331648, 50331648, 'SG', 'user request', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48')
INSERT INTO VPN_Session VALUES (49, 49, 49, 49, '2026-02-27 09:00:00', '2026-02-27 10:00:00', 'disconnected', '172.16.1.49', 162, 51380224, 51380224, 'DE', 'completed', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49')
INSERT INTO VPN_Session VALUES (50, 50, 50, 50, '2026-02-28 10:00:00', '2026-02-28 11:00:00', 'failed', '172.16.1.50', 165, 52428800, 52428800, 'IN', 'network reset', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50')

INSERT INTO Connection_Log VALUES (1, 1, '2026-01-10 09:00:00', 'connect', 'VPN connection established', '192.168.0.2', 1194, 'TLS 1.2', 2, 'admin', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01', 'Additional detail 5 for record 01')
INSERT INTO Connection_Log VALUES (2, 2, '2026-01-11 10:00:00', 'connect', 'VPN connection established', '192.168.0.3', 51820, 'WireGuard 1.0', 3, 'security_service', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02', 'Additional detail 5 for record 02')
INSERT INTO Connection_Log VALUES (3, 3, '2026-01-12 11:00:00', 'disconnect', 'User disconnected from VPN', '192.168.0.4', 1194, 'TLS 1.3', 4, 'system', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03', 'Additional detail 5 for record 03')
INSERT INTO Connection_Log VALUES (4, 4, '2026-01-13 12:00:00', 'connect', 'VPN connection established', '192.168.0.5', 51820, 'TLS 1.2', 5, 'admin', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04', 'Additional detail 5 for record 04')
INSERT INTO Connection_Log VALUES (5, 5, '2026-01-14 13:00:00', 'failure', 'Authentication failed', '192.168.0.6', 1194, 'WireGuard 1.0', 6, 'security_service', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05', 'Additional detail 5 for record 05')
INSERT INTO Connection_Log VALUES (6, 6, '2026-01-15 14:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.7', 51820, 'TLS 1.3', 7, 'system', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06', 'Additional detail 5 for record 06')
INSERT INTO Connection_Log VALUES (7, 7, '2026-01-16 15:05:00', 'failure', 'Authentication failed', '192.168.0.8', 1194, 'TLS 1.2', 8, 'admin', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07', 'Additional detail 5 for record 07')
INSERT INTO Connection_Log VALUES (8, 8, '2026-01-17 16:05:00', 'reconnect', 'VPN connection restored', '192.168.0.9', 51820, 'WireGuard 1.0', 9, 'security_service', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08', 'Additional detail 5 for record 08')
INSERT INTO Connection_Log VALUES (9, 9, '2026-01-18 17:05:00', 'connect', 'VPN connection established', '192.168.0.10', 1194, 'TLS 1.3', 10, 'system', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09', 'Additional detail 5 for record 09')
INSERT INTO Connection_Log VALUES (10, 10, '2026-01-19 18:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.11', 51820, 'TLS 1.2', 1, 'admin', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10', 'Additional detail 5 for record 10')
INSERT INTO Connection_Log VALUES (11, 11, '2026-01-20 19:05:00', 'failure', 'Authentication failed', '192.168.0.12', 1194, 'WireGuard 1.0', 2, 'security_service', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11', 'Additional detail 5 for record 11')
INSERT INTO Connection_Log VALUES (12, 12, '2026-01-21 08:05:00', 'reconnect', 'VPN connection restored', '192.168.0.13', 51820, 'TLS 1.3', 3, 'system', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12', 'Additional detail 5 for record 12')
INSERT INTO Connection_Log VALUES (13, 13, '2026-01-22 09:05:00', 'connect', 'VPN connection established', '192.168.0.14', 1194, 'TLS 1.2', 4, 'admin', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13', 'Additional detail 5 for record 13')
INSERT INTO Connection_Log VALUES (14, 14, '2026-01-23 10:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.15', 51820, 'WireGuard 1.0', 5, 'security_service', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14', 'Additional detail 5 for record 14')
INSERT INTO Connection_Log VALUES (15, 15, '2026-01-24 11:05:00', 'failure', 'Authentication failed', '192.168.0.16', 1194, 'TLS 1.3', 6, 'system', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15', 'Additional detail 5 for record 15')
INSERT INTO Connection_Log VALUES (16, 16, '2026-01-25 12:05:00', 'reconnect', 'VPN connection restored', '192.168.0.17', 51820, 'TLS 1.2', 7, 'admin', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16', 'Additional detail 5 for record 16')
INSERT INTO Connection_Log VALUES (17, 17, '2026-01-26 13:05:00', 'connect', 'VPN connection established', '192.168.0.18', 1194, 'WireGuard 1.0', 8, 'security_service', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17', 'Additional detail 5 for record 17')
INSERT INTO Connection_Log VALUES (18, 18, '2026-01-27 14:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.19', 51820, 'TLS 1.3', 9, 'system', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18', 'Additional detail 5 for record 18')
INSERT INTO Connection_Log VALUES (19, 19, '2026-01-28 15:05:00', 'failure', 'Authentication failed', '192.168.0.20', 1194, 'TLS 1.2', 10, 'admin', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19', 'Additional detail 5 for record 19')
INSERT INTO Connection_Log VALUES (20, 20, '2026-01-29 16:05:00', 'reconnect', 'VPN connection restored', '192.168.0.21', 51820, 'WireGuard 1.0', 1, 'security_service', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20', 'Additional detail 5 for record 20')
INSERT INTO Connection_Log VALUES (21, 21, '2026-01-30 17:05:00', 'connect', 'VPN connection established', '192.168.0.22', 1194, 'TLS 1.3', 2, 'system', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21', 'Additional detail 5 for record 21')
INSERT INTO Connection_Log VALUES (22, 22, '2026-01-31 18:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.23', 51820, 'TLS 1.2', 3, 'admin', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22', 'Additional detail 5 for record 22')
INSERT INTO Connection_Log VALUES (23, 23, '2026-02-01 19:05:00', 'failure', 'Authentication failed', '192.168.0.24', 1194, 'WireGuard 1.0', 4, 'security_service', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23', 'Additional detail 5 for record 23')
INSERT INTO Connection_Log VALUES (24, 24, '2026-02-02 08:05:00', 'reconnect', 'VPN connection restored', '192.168.0.25', 51820, 'TLS 1.3', 5, 'system', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24', 'Additional detail 5 for record 24')
INSERT INTO Connection_Log VALUES (25, 25, '2026-02-03 09:05:00', 'connect', 'VPN connection established', '192.168.0.26', 1194, 'TLS 1.2', 6, 'admin', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25', 'Additional detail 5 for record 25')
INSERT INTO Connection_Log VALUES (26, 26, '2026-02-04 10:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.27', 51820, 'WireGuard 1.0', 7, 'security_service', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26', 'Additional detail 5 for record 26')
INSERT INTO Connection_Log VALUES (27, 27, '2026-02-05 11:05:00', 'failure', 'Authentication failed', '192.168.0.28', 1194, 'TLS 1.3', 8, 'system', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27', 'Additional detail 5 for record 27')
INSERT INTO Connection_Log VALUES (28, 28, '2026-02-06 12:05:00', 'reconnect', 'VPN connection restored', '192.168.0.29', 51820, 'TLS 1.2', 9, 'admin', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28', 'Additional detail 5 for record 28')
INSERT INTO Connection_Log VALUES (29, 29, '2026-02-07 13:05:00', 'connect', 'VPN connection established', '192.168.0.30', 1194, 'WireGuard 1.0', 10, 'security_service', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29', 'Additional detail 5 for record 29')
INSERT INTO Connection_Log VALUES (30, 30, '2026-02-08 14:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.31', 51820, 'TLS 1.3', 1, 'system', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30', 'Additional detail 5 for record 30')
INSERT INTO Connection_Log VALUES (31, 31, '2026-02-09 15:05:00', 'failure', 'Authentication failed', '192.168.0.32', 1194, 'TLS 1.2', 2, 'admin', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31', 'Additional detail 5 for record 31')
INSERT INTO Connection_Log VALUES (32, 32, '2026-02-10 16:05:00', 'reconnect', 'VPN connection restored', '192.168.0.33', 51820, 'WireGuard 1.0', 3, 'security_service', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32', 'Additional detail 5 for record 32')
INSERT INTO Connection_Log VALUES (33, 33, '2026-02-11 17:05:00', 'connect', 'VPN connection established', '192.168.0.34', 1194, 'TLS 1.3', 4, 'system', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33', 'Additional detail 5 for record 33')
INSERT INTO Connection_Log VALUES (34, 34, '2026-02-12 18:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.35', 51820, 'TLS 1.2', 5, 'admin', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34', 'Additional detail 5 for record 34')
INSERT INTO Connection_Log VALUES (35, 35, '2026-02-13 19:05:00', 'failure', 'Authentication failed', '192.168.0.36', 1194, 'WireGuard 1.0', 6, 'security_service', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35', 'Additional detail 5 for record 35')
INSERT INTO Connection_Log VALUES (36, 36, '2026-02-14 08:05:00', 'reconnect', 'VPN connection restored', '192.168.0.37', 51820, 'TLS 1.3', 7, 'system', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36', 'Additional detail 5 for record 36')
INSERT INTO Connection_Log VALUES (37, 37, '2026-02-15 09:05:00', 'connect', 'VPN connection established', '192.168.0.38', 1194, 'TLS 1.2', 8, 'admin', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37', 'Additional detail 5 for record 37')
INSERT INTO Connection_Log VALUES (38, 38, '2026-02-16 10:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.39', 51820, 'WireGuard 1.0', 9, 'security_service', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38', 'Additional detail 5 for record 38')
INSERT INTO Connection_Log VALUES (39, 39, '2026-02-17 11:05:00', 'failure', 'Authentication failed', '192.168.0.40', 1194, 'TLS 1.3', 10, 'system', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39', 'Additional detail 5 for record 39')
INSERT INTO Connection_Log VALUES (40, 40, '2026-02-18 12:05:00', 'reconnect', 'VPN connection restored', '192.168.0.41', 51820, 'TLS 1.2', 1, 'admin', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40', 'Additional detail 5 for record 40')
INSERT INTO Connection_Log VALUES (41, 41, '2026-02-19 13:05:00', 'connect', 'VPN connection established', '192.168.0.42', 1194, 'WireGuard 1.0', 2, 'security_service', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41', 'Additional detail 5 for record 41')
INSERT INTO Connection_Log VALUES (42, 42, '2026-02-20 14:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.43', 51820, 'TLS 1.3', 3, 'system', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42', 'Additional detail 5 for record 42')
INSERT INTO Connection_Log VALUES (43, 43, '2026-02-21 15:05:00', 'failure', 'Authentication failed', '192.168.0.44', 1194, 'TLS 1.2', 4, 'admin', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43', 'Additional detail 5 for record 43')
INSERT INTO Connection_Log VALUES (44, 44, '2026-02-22 16:05:00', 'reconnect', 'VPN connection restored', '192.168.0.45', 51820, 'WireGuard 1.0', 5, 'security_service', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44', 'Additional detail 5 for record 44')
INSERT INTO Connection_Log VALUES (45, 45, '2026-02-23 17:05:00', 'connect', 'VPN connection established', '192.168.0.46', 1194, 'TLS 1.3', 6, 'system', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45', 'Additional detail 5 for record 45')
INSERT INTO Connection_Log VALUES (46, 46, '2026-02-24 18:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.47', 51820, 'TLS 1.2', 7, 'admin', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46', 'Additional detail 5 for record 46')
INSERT INTO Connection_Log VALUES (47, 47, '2026-02-25 19:05:00', 'failure', 'Authentication failed', '192.168.0.48', 1194, 'WireGuard 1.0', 8, 'security_service', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47', 'Additional detail 5 for record 47')
INSERT INTO Connection_Log VALUES (48, 48, '2026-02-26 08:05:00', 'reconnect', 'VPN connection restored', '192.168.0.49', 51820, 'TLS 1.3', 9, 'system', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48', 'Additional detail 5 for record 48')
INSERT INTO Connection_Log VALUES (49, 49, '2026-02-27 09:05:00', 'connect', 'VPN connection established', '192.168.0.50', 1194, 'TLS 1.2', 10, 'admin', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49', 'Additional detail 5 for record 49')
INSERT INTO Connection_Log VALUES (50, 50, '2026-02-28 10:05:00', 'disconnect', 'User disconnected from VPN', '192.168.0.51', 51820, 'WireGuard 1.0', 1, 'security_service', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50', 'Additional detail 5 for record 50')

INSERT INTO Usage_Record VALUES (1, 1, 120.50, 340.25, 460.75, '2026-01-10', 'quarterly', 100, 1, 100, 1.25, 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01')
INSERT INTO Usage_Record VALUES (2, 2, 80.00, 250.00, 330.00, '2026-01-11', 'yearly', 200, 0, 200, 2.50, 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02')
INSERT INTO Usage_Record VALUES (3, 3, 60.75, 140.50, 201.25, '2026-01-12', 'monthly', 300, 1, 300, 3.75, 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03')
INSERT INTO Usage_Record VALUES (4, 4, 200.00, 500.00, 700.00, '2026-01-13', 'quarterly', 400, 0, 400, 5.00, 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04')
INSERT INTO Usage_Record VALUES (5, 5, 10.00, 20.00, 30.00, '2026-01-14', 'yearly', 500, 1, 500, 6.25, 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05')
INSERT INTO Usage_Record VALUES (6, 6, 68.50, 161.00, 229.50, '2026-01-15', 'monthly', 600, 0, 600, 7.50, 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06')
INSERT INTO Usage_Record VALUES (7, 7, 75.75, 174.50, 250.25, '2026-01-16', 'quarterly', 700, 1, 700, 8.75, 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07')
INSERT INTO Usage_Record VALUES (8, 8, 83.00, 188.00, 271.00, '2026-01-17', 'yearly', 0, 0, 0, 10.00, 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08')
INSERT INTO Usage_Record VALUES (9, 9, 90.25, 201.50, 291.75, '2026-01-18', 'monthly', 100, 1, 100, 11.25, 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09')
INSERT INTO Usage_Record VALUES (10, 10, 97.50, 215.00, 312.50, '2026-01-19', 'quarterly', 200, 0, 200, 12.50, 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10')
INSERT INTO Usage_Record VALUES (11, 11, 104.75, 228.50, 333.25, '2026-01-20', 'yearly', 300, 1, 300, 13.75, 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11')
INSERT INTO Usage_Record VALUES (12, 12, 112.00, 242.00, 354.00, '2026-01-21', 'monthly', 400, 0, 400, 15.00, 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12')
INSERT INTO Usage_Record VALUES (13, 13, 119.25, 255.50, 374.75, '2026-01-22', 'quarterly', 500, 1, 500, 16.25, 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13')
INSERT INTO Usage_Record VALUES (14, 14, 126.50, 269.00, 395.50, '2026-01-23', 'yearly', 600, 0, 600, 17.50, 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14')
INSERT INTO Usage_Record VALUES (15, 15, 133.75, 282.50, 416.25, '2026-01-24', 'monthly', 700, 1, 700, 18.75, 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15')
INSERT INTO Usage_Record VALUES (16, 16, 141.00, 296.00, 437.00, '2026-01-25', 'quarterly', 0, 0, 0, 20.00, 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16')
INSERT INTO Usage_Record VALUES (17, 17, 148.25, 309.50, 457.75, '2026-01-26', 'yearly', 100, 1, 100, 21.25, 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17')
INSERT INTO Usage_Record VALUES (18, 18, 155.50, 323.00, 478.50, '2026-01-27', 'monthly', 200, 0, 200, 22.50, 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18')
INSERT INTO Usage_Record VALUES (19, 19, 162.75, 336.50, 499.25, '2026-01-28', 'quarterly', 300, 1, 300, 23.75, 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19')
INSERT INTO Usage_Record VALUES (20, 20, 170.00, 350.00, 520.00, '2026-01-29', 'yearly', 400, 0, 400, 0.00, 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20')
INSERT INTO Usage_Record VALUES (21, 21, 177.25, 363.50, 540.75, '2026-01-30', 'monthly', 500, 1, 500, 1.25, 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21')
INSERT INTO Usage_Record VALUES (22, 22, 184.50, 377.00, 561.50, '2026-01-31', 'quarterly', 600, 0, 600, 2.50, 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22')
INSERT INTO Usage_Record VALUES (23, 23, 191.75, 390.50, 582.25, '2026-02-01', 'yearly', 700, 1, 700, 3.75, 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23')
INSERT INTO Usage_Record VALUES (24, 24, 199.00, 404.00, 603.00, '2026-02-02', 'monthly', 0, 0, 0, 5.00, 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24')
INSERT INTO Usage_Record VALUES (25, 25, 206.25, 417.50, 623.75, '2026-02-03', 'quarterly', 100, 1, 100, 6.25, 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25')
INSERT INTO Usage_Record VALUES (26, 26, 213.50, 431.00, 644.50, '2026-02-04', 'yearly', 200, 0, 200, 7.50, 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26')
INSERT INTO Usage_Record VALUES (27, 27, 220.75, 444.50, 665.25, '2026-02-05', 'monthly', 300, 1, 300, 8.75, 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27')
INSERT INTO Usage_Record VALUES (28, 28, 228.00, 458.00, 686.00, '2026-02-06', 'quarterly', 400, 0, 400, 10.00, 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28')
INSERT INTO Usage_Record VALUES (29, 29, 235.25, 471.50, 706.75, '2026-02-07', 'yearly', 500, 1, 500, 11.25, 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29')
INSERT INTO Usage_Record VALUES (30, 30, 242.50, 485.00, 727.50, '2026-02-08', 'monthly', 600, 0, 600, 12.50, 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30')
INSERT INTO Usage_Record VALUES (31, 31, 249.75, 498.50, 748.25, '2026-02-09', 'quarterly', 700, 1, 700, 13.75, 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31')
INSERT INTO Usage_Record VALUES (32, 32, 257.00, 512.00, 769.00, '2026-02-10', 'yearly', 0, 0, 0, 15.00, 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32')
INSERT INTO Usage_Record VALUES (33, 33, 264.25, 525.50, 789.75, '2026-02-11', 'monthly', 100, 1, 100, 16.25, 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33')
INSERT INTO Usage_Record VALUES (34, 34, 271.50, 539.00, 810.50, '2026-02-12', 'quarterly', 200, 0, 200, 17.50, 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34')
INSERT INTO Usage_Record VALUES (35, 35, 278.75, 552.50, 831.25, '2026-02-13', 'yearly', 300, 1, 300, 18.75, 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35')
INSERT INTO Usage_Record VALUES (36, 36, 286.00, 566.00, 852.00, '2026-02-14', 'monthly', 400, 0, 400, 20.00, 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36')
INSERT INTO Usage_Record VALUES (37, 37, 293.25, 579.50, 872.75, '2026-02-15', 'quarterly', 500, 1, 500, 21.25, 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37')
INSERT INTO Usage_Record VALUES (38, 38, 300.50, 593.00, 893.50, '2026-02-16', 'yearly', 600, 0, 600, 22.50, 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38')
INSERT INTO Usage_Record VALUES (39, 39, 307.75, 606.50, 914.25, '2026-02-17', 'monthly', 700, 1, 700, 23.75, 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39')
INSERT INTO Usage_Record VALUES (40, 40, 315.00, 620.00, 935.00, '2026-02-18', 'quarterly', 0, 0, 0, 0.00, 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40')
INSERT INTO Usage_Record VALUES (41, 41, 322.25, 633.50, 955.75, '2026-02-19', 'yearly', 100, 1, 100, 1.25, 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41')
INSERT INTO Usage_Record VALUES (42, 42, 329.50, 647.00, 976.50, '2026-02-20', 'monthly', 200, 0, 200, 2.50, 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42')
INSERT INTO Usage_Record VALUES (43, 43, 336.75, 660.50, 997.25, '2026-02-21', 'quarterly', 300, 1, 300, 3.75, 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43')
INSERT INTO Usage_Record VALUES (44, 44, 344.00, 674.00, 1018.00, '2026-02-22', 'yearly', 400, 0, 400, 5.00, 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44')
INSERT INTO Usage_Record VALUES (45, 45, 351.25, 687.50, 1038.75, '2026-02-23', 'monthly', 500, 1, 500, 6.25, 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45')
INSERT INTO Usage_Record VALUES (46, 46, 358.50, 701.00, 1059.50, '2026-02-24', 'quarterly', 600, 0, 600, 7.50, 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46')
INSERT INTO Usage_Record VALUES (47, 47, 365.75, 714.50, 1080.25, '2026-02-25', 'yearly', 700, 1, 700, 8.75, 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47')
INSERT INTO Usage_Record VALUES (48, 48, 373.00, 728.00, 1101.00, '2026-02-26', 'monthly', 0, 0, 0, 10.00, 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48')
INSERT INTO Usage_Record VALUES (49, 49, 380.25, 741.50, 1121.75, '2026-02-27', 'quarterly', 100, 1, 100, 11.25, 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49')
INSERT INTO Usage_Record VALUES (50, 50, 387.50, 755.00, 1142.50, '2026-02-28', 'yearly', 200, 0, 200, 12.50, 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50')

INSERT INTO Security_Log VALUES (1, 1, 1, '2026-01-10 09:05:00', 'multiple_login_attempts', 'medium', 'open', '192.168.0.2', 2, 1, 'alerted', 'admin', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01')
INSERT INTO Security_Log VALUES (2, 2, 2, '2026-01-11 10:05:00', 'new_device_login', 'low', 'resolved', '192.168.0.3', 3, 2, 'allowed', 'security_service', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02')
INSERT INTO Security_Log VALUES (3, 3, 3, '2026-01-12 11:05:00', 'authentication_failure', 'high', 'open', '192.168.0.4', 4, 3, 'reviewed', 'system', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03')
INSERT INTO Security_Log VALUES (4, 4, 4, '2026-01-13 12:05:00', 'unusual_traffic', 'medium', 'resolved', '192.168.0.5', 5, 4, 'blocked', 'admin', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04')
INSERT INTO Security_Log VALUES (5, 5, 5, '2026-01-14 13:05:00', 'blocked_connection', 'high', 'resolved', '192.168.0.6', 6, 5, 'alerted', 'security_service', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05')
INSERT INTO Security_Log VALUES (6, 6, 6, '2026-01-15 14:05:00', 'new_device_login', 'high', 'resolved', '192.168.0.7', 7, 6, 'allowed', 'system', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06')
INSERT INTO Security_Log VALUES (7, 7, 7, '2026-01-16 15:05:00', 'authentication_failure', 'low', 'resolved', '192.168.0.8', 8, 7, 'reviewed', 'admin', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07')
INSERT INTO Security_Log VALUES (8, 8, 8, '2026-01-17 16:05:00', 'unusual_traffic', 'medium', 'open', '192.168.0.9', 9, 8, 'blocked', 'security_service', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08')
INSERT INTO Security_Log VALUES (9, 9, 9, '2026-01-18 17:05:00', 'blocked_connection', 'high', 'resolved', '192.168.0.10', 10, 9, 'alerted', 'system', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09')
INSERT INTO Security_Log VALUES (10, 10, 10, '2026-01-19 18:05:00', 'multiple_login_attempts', 'low', 'resolved', '192.168.0.11', 1, 10, 'allowed', 'admin', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10')
INSERT INTO Security_Log VALUES (11, 11, 11, '2026-01-20 19:05:00', 'new_device_login', 'medium', 'resolved', '192.168.0.12', 2, 11, 'reviewed', 'security_service', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11')
INSERT INTO Security_Log VALUES (12, 12, 12, '2026-01-21 08:05:00', 'authentication_failure', 'high', 'open', '192.168.0.13', 3, 12, 'blocked', 'system', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12')
INSERT INTO Security_Log VALUES (13, 13, 13, '2026-01-22 09:05:00', 'unusual_traffic', 'low', 'resolved', '192.168.0.14', 4, 13, 'alerted', 'admin', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13')
INSERT INTO Security_Log VALUES (14, 14, 14, '2026-01-23 10:05:00', 'blocked_connection', 'medium', 'resolved', '192.168.0.15', 5, 14, 'allowed', 'security_service', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14')
INSERT INTO Security_Log VALUES (15, 15, 15, '2026-01-24 11:05:00', 'multiple_login_attempts', 'high', 'resolved', '192.168.0.16', 6, 15, 'reviewed', 'system', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15')
INSERT INTO Security_Log VALUES (16, 16, 16, '2026-01-25 12:05:00', 'new_device_login', 'low', 'open', '192.168.0.17', 7, 16, 'blocked', 'admin', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16')
INSERT INTO Security_Log VALUES (17, 17, 17, '2026-01-26 13:05:00', 'authentication_failure', 'medium', 'resolved', '192.168.0.18', 8, 17, 'alerted', 'security_service', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17')
INSERT INTO Security_Log VALUES (18, 18, 18, '2026-01-27 14:05:00', 'unusual_traffic', 'high', 'resolved', '192.168.0.19', 9, 18, 'allowed', 'system', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18')
INSERT INTO Security_Log VALUES (19, 19, 19, '2026-01-28 15:05:00', 'blocked_connection', 'low', 'resolved', '192.168.0.20', 10, 19, 'reviewed', 'admin', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19')
INSERT INTO Security_Log VALUES (20, 20, 20, '2026-01-29 16:05:00', 'multiple_login_attempts', 'medium', 'open', '192.168.0.21', 1, 20, 'blocked', 'security_service', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20')
INSERT INTO Security_Log VALUES (21, 21, 21, '2026-01-30 17:05:00', 'new_device_login', 'high', 'resolved', '192.168.0.22', 2, 21, 'alerted', 'system', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21')
INSERT INTO Security_Log VALUES (22, 22, 22, '2026-01-31 18:05:00', 'authentication_failure', 'low', 'resolved', '192.168.0.23', 3, 22, 'allowed', 'admin', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22')
INSERT INTO Security_Log VALUES (23, 23, 23, '2026-02-01 19:05:00', 'unusual_traffic', 'medium', 'resolved', '192.168.0.24', 4, 23, 'reviewed', 'security_service', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23')
INSERT INTO Security_Log VALUES (24, 24, 24, '2026-02-02 08:05:00', 'blocked_connection', 'high', 'open', '192.168.0.25', 5, 24, 'blocked', 'system', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24')
INSERT INTO Security_Log VALUES (25, 25, 25, '2026-02-03 09:05:00', 'multiple_login_attempts', 'low', 'resolved', '192.168.0.26', 6, 25, 'alerted', 'admin', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25')
INSERT INTO Security_Log VALUES (26, 26, 26, '2026-02-04 10:05:00', 'new_device_login', 'medium', 'resolved', '192.168.0.27', 7, 26, 'allowed', 'security_service', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26')
INSERT INTO Security_Log VALUES (27, 27, 27, '2026-02-05 11:05:00', 'authentication_failure', 'high', 'resolved', '192.168.0.28', 8, 27, 'reviewed', 'system', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27')
INSERT INTO Security_Log VALUES (28, 28, 28, '2026-02-06 12:05:00', 'unusual_traffic', 'low', 'open', '192.168.0.29', 9, 28, 'blocked', 'admin', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28')
INSERT INTO Security_Log VALUES (29, 29, 29, '2026-02-07 13:05:00', 'blocked_connection', 'medium', 'resolved', '192.168.0.30', 10, 29, 'alerted', 'security_service', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29')
INSERT INTO Security_Log VALUES (30, 30, 30, '2026-02-08 14:05:00', 'multiple_login_attempts', 'high', 'resolved', '192.168.0.31', 1, 30, 'allowed', 'system', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30')
INSERT INTO Security_Log VALUES (31, 31, 31, '2026-02-09 15:05:00', 'new_device_login', 'low', 'resolved', '192.168.0.32', 2, 31, 'reviewed', 'admin', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31')
INSERT INTO Security_Log VALUES (32, 32, 32, '2026-02-10 16:05:00', 'authentication_failure', 'medium', 'open', '192.168.0.33', 3, 32, 'blocked', 'security_service', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32')
INSERT INTO Security_Log VALUES (33, 33, 33, '2026-02-11 17:05:00', 'unusual_traffic', 'high', 'resolved', '192.168.0.34', 4, 33, 'alerted', 'system', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33')
INSERT INTO Security_Log VALUES (34, 34, 34, '2026-02-12 18:05:00', 'blocked_connection', 'low', 'resolved', '192.168.0.35', 5, 34, 'allowed', 'admin', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34')
INSERT INTO Security_Log VALUES (35, 35, 35, '2026-02-13 19:05:00', 'multiple_login_attempts', 'medium', 'resolved', '192.168.0.36', 6, 35, 'reviewed', 'security_service', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35')
INSERT INTO Security_Log VALUES (36, 36, 36, '2026-02-14 08:05:00', 'new_device_login', 'high', 'open', '192.168.0.37', 7, 36, 'blocked', 'system', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36')
INSERT INTO Security_Log VALUES (37, 37, 37, '2026-02-15 09:05:00', 'authentication_failure', 'low', 'resolved', '192.168.0.38', 8, 37, 'alerted', 'admin', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37')
INSERT INTO Security_Log VALUES (38, 38, 38, '2026-02-16 10:05:00', 'unusual_traffic', 'medium', 'resolved', '192.168.0.39', 9, 38, 'allowed', 'security_service', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38')
INSERT INTO Security_Log VALUES (39, 39, 39, '2026-02-17 11:05:00', 'blocked_connection', 'high', 'resolved', '192.168.0.40', 10, 39, 'reviewed', 'system', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39')
INSERT INTO Security_Log VALUES (40, 40, 40, '2026-02-18 12:05:00', 'multiple_login_attempts', 'low', 'open', '192.168.0.41', 1, 40, 'blocked', 'admin', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40')
INSERT INTO Security_Log VALUES (41, 41, 41, '2026-02-19 13:05:00', 'new_device_login', 'medium', 'resolved', '192.168.0.42', 2, 41, 'alerted', 'security_service', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41')
INSERT INTO Security_Log VALUES (42, 42, 42, '2026-02-20 14:05:00', 'authentication_failure', 'high', 'resolved', '192.168.0.43', 3, 42, 'allowed', 'system', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42')
INSERT INTO Security_Log VALUES (43, 43, 43, '2026-02-21 15:05:00', 'unusual_traffic', 'low', 'resolved', '192.168.0.44', 4, 43, 'reviewed', 'admin', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43')
INSERT INTO Security_Log VALUES (44, 44, 44, '2026-02-22 16:05:00', 'blocked_connection', 'medium', 'open', '192.168.0.45', 5, 44, 'blocked', 'security_service', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44')
INSERT INTO Security_Log VALUES (45, 45, 45, '2026-02-23 17:05:00', 'multiple_login_attempts', 'high', 'resolved', '192.168.0.46', 6, 45, 'alerted', 'system', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45')
INSERT INTO Security_Log VALUES (46, 46, 46, '2026-02-24 18:05:00', 'new_device_login', 'low', 'resolved', '192.168.0.47', 7, 46, 'allowed', 'admin', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46')
INSERT INTO Security_Log VALUES (47, 47, 47, '2026-02-25 19:05:00', 'authentication_failure', 'medium', 'resolved', '192.168.0.48', 8, 47, 'reviewed', 'security_service', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47')
INSERT INTO Security_Log VALUES (48, 48, 48, '2026-02-26 08:05:00', 'unusual_traffic', 'high', 'open', '192.168.0.49', 9, 48, 'blocked', 'system', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48')
INSERT INTO Security_Log VALUES (49, 49, 49, '2026-02-27 09:05:00', 'blocked_connection', 'low', 'resolved', '192.168.0.50', 10, 49, 'alerted', 'admin', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49')
INSERT INTO Security_Log VALUES (50, 50, 50, '2026-02-28 10:05:00', 'multiple_login_attempts', 'medium', 'resolved', '192.168.0.51', 1, 50, 'allowed', 'security_service', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50')

INSERT INTO Server_Maintenance VALUES (1, 1, 1, '2026-02-01', 'software_update', 'completed', 'VPN server software updated', 1.25, 18, 125.00, '2027-01-01', 'admin', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01')
INSERT INTO Server_Maintenance VALUES (2, 2, 2, '2026-02-02', 'security_patch', 'completed', 'Security patch installed', 2.50, 21, 150.00, '2027-01-02', 'security_service', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02')
INSERT INTO Server_Maintenance VALUES (3, 3, 3, '2026-02-03', 'hardware_check', 'scheduled', 'Routine hardware inspection', 3.75, 24, 175.00, '2027-01-03', 'system', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03')
INSERT INTO Server_Maintenance VALUES (4, 4, 4, '2026-02-04', 'network_check', 'pending', 'Network performance check pending', 5.00, 27, 200.00, '2027-01-04', 'admin', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04')
INSERT INTO Server_Maintenance VALUES (5, 5, 5, '2026-02-05', 'software_update', 'completed', 'Server configuration updated', 6.25, 30, 225.00, '2027-01-05', 'security_service', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05')
INSERT INTO Server_Maintenance VALUES (6, 6, 6, '2026-02-06', 'security_patch', 'pending', 'Security patch installed', 7.50, 33, 250.00, '2027-01-06', 'system', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06')
INSERT INTO Server_Maintenance VALUES (7, 7, 7, '2026-02-07', 'hardware_check', 'scheduled', 'Routine hardware inspection completed', 8.75, 36, 275.00, '2027-01-07', 'admin', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07')
INSERT INTO Server_Maintenance VALUES (8, 8, 8, '2026-02-08', 'network_check', 'completed', 'Network performance check completed', 10.00, 39, 300.00, '2027-01-08', 'security_service', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08')
INSERT INTO Server_Maintenance VALUES (9, 9, 9, '2026-02-09', 'software_update', 'pending', 'VPN server software updated', 11.25, 42, 325.00, '2027-01-09', 'system', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09')
INSERT INTO Server_Maintenance VALUES (10, 10, 10, '2026-02-10', 'security_patch', 'scheduled', 'Security patch installed', 12.50, 45, 350.00, '2027-01-10', 'admin', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10')
INSERT INTO Server_Maintenance VALUES (11, 11, 11, '2026-02-11', 'hardware_check', 'completed', 'Routine hardware inspection completed', 13.75, 48, 375.00, '2027-01-11', 'security_service', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11')
INSERT INTO Server_Maintenance VALUES (12, 12, 12, '2026-02-12', 'network_check', 'pending', 'Network performance check completed', 15.00, 51, 400.00, '2027-01-12', 'system', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12')
INSERT INTO Server_Maintenance VALUES (13, 13, 13, '2026-02-13', 'software_update', 'scheduled', 'VPN server software updated', 16.25, 54, 425.00, '2027-01-13', 'admin', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13')
INSERT INTO Server_Maintenance VALUES (14, 14, 14, '2026-02-14', 'security_patch', 'completed', 'Security patch installed', 17.50, 57, 450.00, '2027-01-14', 'security_service', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14')
INSERT INTO Server_Maintenance VALUES (15, 15, 15, '2026-02-15', 'hardware_check', 'pending', 'Routine hardware inspection completed', 18.75, 60, 475.00, '2027-01-15', 'system', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15')
INSERT INTO Server_Maintenance VALUES (16, 16, 16, '2026-02-16', 'network_check', 'scheduled', 'Network performance check completed', 20.00, 63, 500.00, '2027-01-16', 'admin', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16')
INSERT INTO Server_Maintenance VALUES (17, 17, 17, '2026-02-17', 'software_update', 'completed', 'VPN server software updated', 21.25, 66, 525.00, '2027-01-17', 'security_service', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17')
INSERT INTO Server_Maintenance VALUES (18, 18, 18, '2026-02-18', 'security_patch', 'pending', 'Security patch installed', 22.50, 69, 550.00, '2027-01-18', 'system', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18')
INSERT INTO Server_Maintenance VALUES (19, 19, 19, '2026-02-19', 'hardware_check', 'scheduled', 'Routine hardware inspection completed', 23.75, 72, 575.00, '2027-01-19', 'admin', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19')
INSERT INTO Server_Maintenance VALUES (20, 20, 20, '2026-02-20', 'network_check', 'completed', 'Network performance check completed', 0.00, 75, 600.00, '2027-01-20', 'security_service', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20')
INSERT INTO Server_Maintenance VALUES (21, 21, 21, '2026-02-21', 'software_update', 'pending', 'VPN server software updated', 1.25, 78, 625.00, '2027-01-21', 'system', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21')
INSERT INTO Server_Maintenance VALUES (22, 22, 22, '2026-02-22', 'security_patch', 'scheduled', 'Security patch installed', 2.50, 81, 650.00, '2027-01-22', 'admin', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22')
INSERT INTO Server_Maintenance VALUES (23, 23, 23, '2026-02-23', 'hardware_check', 'completed', 'Routine hardware inspection completed', 3.75, 84, 675.00, '2027-01-23', 'security_service', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23')
INSERT INTO Server_Maintenance VALUES (24, 24, 24, '2026-02-24', 'network_check', 'pending', 'Network performance check completed', 5.00, 87, 700.00, '2027-01-24', 'system', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24')
INSERT INTO Server_Maintenance VALUES (25, 25, 25, '2026-02-25', 'software_update', 'scheduled', 'VPN server software updated', 6.25, 90, 725.00, '2027-01-25', 'admin', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25')
INSERT INTO Server_Maintenance VALUES (26, 26, 26, '2026-02-26', 'security_patch', 'completed', 'Security patch installed', 7.50, 93, 750.00, '2027-01-26', 'security_service', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26')
INSERT INTO Server_Maintenance VALUES (27, 27, 27, '2026-02-27', 'hardware_check', 'pending', 'Routine hardware inspection completed', 8.75, 96, 775.00, '2027-01-27', 'system', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27')
INSERT INTO Server_Maintenance VALUES (28, 28, 28, '2026-02-28', 'network_check', 'scheduled', 'Network performance check completed', 10.00, 99, 800.00, '2027-01-28', 'admin', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28')
INSERT INTO Server_Maintenance VALUES (29, 29, 29, '2026-03-01', 'software_update', 'completed', 'VPN server software updated', 11.25, 102, 825.00, '2027-02-01', 'security_service', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29')
INSERT INTO Server_Maintenance VALUES (30, 30, 30, '2026-03-02', 'security_patch', 'pending', 'Security patch installed', 12.50, 105, 850.00, '2027-02-02', 'system', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30')
INSERT INTO Server_Maintenance VALUES (31, 31, 31, '2026-03-03', 'hardware_check', 'scheduled', 'Routine hardware inspection completed', 13.75, 108, 875.00, '2027-02-03', 'admin', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31')
INSERT INTO Server_Maintenance VALUES (32, 32, 32, '2026-03-04', 'network_check', 'completed', 'Network performance check completed', 15.00, 111, 900.00, '2027-02-04', 'security_service', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32')
INSERT INTO Server_Maintenance VALUES (33, 33, 33, '2026-03-05', 'software_update', 'pending', 'VPN server software updated', 16.25, 114, 925.00, '2027-02-05', 'system', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33')
INSERT INTO Server_Maintenance VALUES (34, 34, 34, '2026-03-06', 'security_patch', 'scheduled', 'Security patch installed', 17.50, 117, 950.00, '2027-02-06', 'admin', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34')
INSERT INTO Server_Maintenance VALUES (35, 35, 35, '2026-03-07', 'hardware_check', 'completed', 'Routine hardware inspection completed', 18.75, 120, 975.00, '2027-02-07', 'security_service', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35')
INSERT INTO Server_Maintenance VALUES (36, 36, 36, '2026-03-08', 'network_check', 'pending', 'Network performance check completed', 20.00, 123, 1000.00, '2027-02-08', 'system', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36')
INSERT INTO Server_Maintenance VALUES (37, 37, 37, '2026-03-09', 'software_update', 'scheduled', 'VPN server software updated', 21.25, 126, 1025.00, '2027-02-09', 'admin', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37')
INSERT INTO Server_Maintenance VALUES (38, 38, 38, '2026-03-10', 'security_patch', 'completed', 'Security patch installed', 22.50, 129, 1050.00, '2027-02-10', 'security_service', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38')
INSERT INTO Server_Maintenance VALUES (39, 39, 39, '2026-03-11', 'hardware_check', 'pending', 'Routine hardware inspection completed', 23.75, 132, 1075.00, '2027-02-11', 'system', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39')
INSERT INTO Server_Maintenance VALUES (40, 40, 40, '2026-03-12', 'network_check', 'scheduled', 'Network performance check completed', 0.00, 135, 1100.00, '2027-02-12', 'admin', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40')
INSERT INTO Server_Maintenance VALUES (41, 41, 41, '2026-03-13', 'software_update', 'completed', 'VPN server software updated', 1.25, 138, 1125.00, '2027-02-13', 'security_service', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41')
INSERT INTO Server_Maintenance VALUES (42, 42, 42, '2026-03-14', 'security_patch', 'pending', 'Security patch installed', 2.50, 141, 1150.00, '2027-02-14', 'system', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42')
INSERT INTO Server_Maintenance VALUES (43, 43, 43, '2026-03-15', 'hardware_check', 'scheduled', 'Routine hardware inspection completed', 3.75, 144, 1175.00, '2027-02-15', 'admin', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43')
INSERT INTO Server_Maintenance VALUES (44, 44, 44, '2026-03-16', 'network_check', 'completed', 'Network performance check completed', 5.00, 147, 1200.00, '2027-02-16', 'security_service', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44')
INSERT INTO Server_Maintenance VALUES (45, 45, 45, '2026-03-17', 'software_update', 'pending', 'VPN server software updated', 6.25, 150, 1225.00, '2027-02-17', 'system', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45')
INSERT INTO Server_Maintenance VALUES (46, 46, 46, '2026-03-18', 'security_patch', 'scheduled', 'Security patch installed', 7.50, 153, 1250.00, '2027-02-18', 'admin', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46')
INSERT INTO Server_Maintenance VALUES (47, 47, 47, '2026-03-19', 'hardware_check', 'completed', 'Routine hardware inspection completed', 8.75, 156, 1275.00, '2027-02-19', 'security_service', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47')
INSERT INTO Server_Maintenance VALUES (48, 48, 48, '2026-03-20', 'network_check', 'pending', 'Network performance check completed', 10.00, 159, 1300.00, '2027-02-20', 'system', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48')
INSERT INTO Server_Maintenance VALUES (49, 49, 49, '2026-03-21', 'software_update', 'scheduled', 'VPN server software updated', 11.25, 162, 1325.00, '2027-02-21', 'admin', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49')
INSERT INTO Server_Maintenance VALUES (50, 50, 50, '2026-03-22', 'security_patch', 'completed', 'Security patch installed', 12.50, 165, 1350.00, '2027-02-22', 'security_service', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50')

INSERT INTO Support_Ticket VALUES (1, 1, 'Connection issue', 'VPN connection disconnects frequently', '2026-02-01', 'open', 'high', 'web portal', 'Billing Support', NULL, 1, 2, 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01')
INSERT INTO Support_Ticket VALUES (2, 2, 'Slow speed', 'VPN speed is lower than expected', '2026-02-02', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 2, 3, 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02')
INSERT INTO Support_Ticket VALUES (3, 3, 'Login problem', 'Unable to log in to the VPN account', '2026-02-03', 'closed', 'high', 'email', 'Network Support', NULL, 3, 4, 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03')
INSERT INTO Support_Ticket VALUES (4, 4, 'Payment query', 'Need help with subscription payment', '2026-02-04', 'open', 'low', 'web portal', 'Billing Support', '2026-01-04', 4, 5, 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04')
INSERT INTO Support_Ticket VALUES (5, 5, 'Device setup', 'Need help configuring a new device', '2026-02-05', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 6, 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05')
INSERT INTO Support_Ticket VALUES (6, 6, 'Server location request', 'Please help choose a nearby server', '2026-02-06', 'closed', 'high', 'email', 'Network Support', NULL, 0, 7, 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06')
INSERT INTO Support_Ticket VALUES (7, 7, 'Subscription renewal', 'Need help renewing the VPN subscription', '2026-02-07', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 8, 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07')
INSERT INTO Support_Ticket VALUES (8, 8, 'Security concern', 'Please review a security notification', '2026-02-08', 'in_progress', 'medium', 'mobile app', 'Security Team', '2026-01-08', 2, 9, 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08')
INSERT INTO Support_Ticket VALUES (9, 9, 'Connection issue', 'VPN connection disconnects frequently', '2026-02-09', 'closed', 'high', 'email', 'Network Support', NULL, 3, 10, 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09')
INSERT INTO Support_Ticket VALUES (10, 10, 'Slow speed', 'VPN speed is lower than expected', '2026-02-10', 'open', 'low', 'web portal', 'Billing Support', NULL, 4, 1, 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10')
INSERT INTO Support_Ticket VALUES (11, 11, 'Login problem', 'Unable to log in to the VPN account', '2026-02-11', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 2, 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11')
INSERT INTO Support_Ticket VALUES (12, 12, 'Payment query', 'Need help with subscription payment', '2026-02-12', 'closed', 'high', 'email', 'Network Support', '2026-01-12', 0, 3, 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12')
INSERT INTO Support_Ticket VALUES (13, 13, 'Device setup', 'Need help configuring a new device', '2026-02-13', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 4, 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13')
INSERT INTO Support_Ticket VALUES (14, 14, 'Server location request', 'Please help choose a nearby server', '2026-02-14', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 2, 5, 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14')
INSERT INTO Support_Ticket VALUES (15, 15, 'Subscription renewal', 'Need help renewing the VPN subscription', '2026-02-15', 'closed', 'high', 'email', 'Network Support', NULL, 3, 6, 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15')
INSERT INTO Support_Ticket VALUES (16, 16, 'Security concern', 'Please review a security notification', '2026-02-16', 'open', 'low', 'web portal', 'Billing Support', '2026-01-16', 4, 7, 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16')
INSERT INTO Support_Ticket VALUES (17, 17, 'Connection issue', 'VPN connection disconnects frequently', '2026-02-17', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 8, 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17')
INSERT INTO Support_Ticket VALUES (18, 18, 'Slow speed', 'VPN speed is lower than expected', '2026-02-18', 'closed', 'high', 'email', 'Network Support', NULL, 0, 9, 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18')
INSERT INTO Support_Ticket VALUES (19, 19, 'Login problem', 'Unable to log in to the VPN account', '2026-02-19', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 10, 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19')
INSERT INTO Support_Ticket VALUES (20, 20, 'Payment query', 'Need help with subscription payment', '2026-02-20', 'in_progress', 'medium', 'mobile app', 'Security Team', '2026-01-20', 2, 1, 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20')
INSERT INTO Support_Ticket VALUES (21, 21, 'Device setup', 'Need help configuring a new device', '2026-02-21', 'closed', 'high', 'email', 'Network Support', NULL, 3, 2, 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21')
INSERT INTO Support_Ticket VALUES (22, 22, 'Server location request', 'Please help choose a nearby server', '2026-02-22', 'open', 'low', 'web portal', 'Billing Support', NULL, 4, 3, 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22')
INSERT INTO Support_Ticket VALUES (23, 23, 'Subscription renewal', 'Need help renewing the VPN subscription', '2026-02-23', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 4, 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23')
INSERT INTO Support_Ticket VALUES (24, 24, 'Security concern', 'Please review a security notification', '2026-02-24', 'closed', 'high', 'email', 'Network Support', '2026-01-24', 0, 5, 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24')
INSERT INTO Support_Ticket VALUES (25, 25, 'Connection issue', 'VPN connection disconnects frequently', '2026-02-25', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 6, 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25')
INSERT INTO Support_Ticket VALUES (26, 26, 'Slow speed', 'VPN speed is lower than expected', '2026-02-26', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 2, 7, 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26')
INSERT INTO Support_Ticket VALUES (27, 27, 'Login problem', 'Unable to log in to the VPN account', '2026-02-27', 'closed', 'high', 'email', 'Network Support', NULL, 3, 8, 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27')
INSERT INTO Support_Ticket VALUES (28, 28, 'Payment query', 'Need help with subscription payment', '2026-02-28', 'open', 'low', 'web portal', 'Billing Support', '2026-01-28', 4, 9, 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28')
INSERT INTO Support_Ticket VALUES (29, 29, 'Device setup', 'Need help configuring a new device', '2026-03-01', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 10, 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29')
INSERT INTO Support_Ticket VALUES (30, 30, 'Server location request', 'Please help choose a nearby server', '2026-03-02', 'closed', 'high', 'email', 'Network Support', NULL, 0, 1, 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30')
INSERT INTO Support_Ticket VALUES (31, 31, 'Subscription renewal', 'Need help renewing the VPN subscription', '2026-03-03', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 2, 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31')
INSERT INTO Support_Ticket VALUES (32, 32, 'Security concern', 'Please review a security notification', '2026-03-04', 'in_progress', 'medium', 'mobile app', 'Security Team', '2026-02-04', 2, 3, 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32')
INSERT INTO Support_Ticket VALUES (33, 33, 'Connection issue', 'VPN connection disconnects frequently', '2026-03-05', 'closed', 'high', 'email', 'Network Support', NULL, 3, 4, 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33')
INSERT INTO Support_Ticket VALUES (34, 34, 'Slow speed', 'VPN speed is lower than expected', '2026-03-06', 'open', 'low', 'web portal', 'Billing Support', NULL, 4, 5, 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34')
INSERT INTO Support_Ticket VALUES (35, 35, 'Login problem', 'Unable to log in to the VPN account', '2026-03-07', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 6, 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35')
INSERT INTO Support_Ticket VALUES (36, 36, 'Payment query', 'Need help with subscription payment', '2026-03-08', 'closed', 'high', 'email', 'Network Support', '2026-02-08', 0, 7, 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36')
INSERT INTO Support_Ticket VALUES (37, 37, 'Device setup', 'Need help configuring a new device', '2026-03-09', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 8, 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37')
INSERT INTO Support_Ticket VALUES (38, 38, 'Server location request', 'Please help choose a nearby server', '2026-03-10', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 2, 9, 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38')
INSERT INTO Support_Ticket VALUES (39, 39, 'Subscription renewal', 'Need help renewing the VPN subscription', '2026-03-11', 'closed', 'high', 'email', 'Network Support', NULL, 3, 10, 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39')
INSERT INTO Support_Ticket VALUES (40, 40, 'Security concern', 'Please review a security notification', '2026-03-12', 'open', 'low', 'web portal', 'Billing Support', '2026-02-12', 4, 1, 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40')
INSERT INTO Support_Ticket VALUES (41, 41, 'Connection issue', 'VPN connection disconnects frequently', '2026-03-13', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 2, 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41')
INSERT INTO Support_Ticket VALUES (42, 42, 'Slow speed', 'VPN speed is lower than expected', '2026-03-14', 'closed', 'high', 'email', 'Network Support', NULL, 0, 3, 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42')
INSERT INTO Support_Ticket VALUES (43, 43, 'Login problem', 'Unable to log in to the VPN account', '2026-03-15', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 4, 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43')
INSERT INTO Support_Ticket VALUES (44, 44, 'Payment query', 'Need help with subscription payment', '2026-03-16', 'in_progress', 'medium', 'mobile app', 'Security Team', '2026-02-16', 2, 5, 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44')
INSERT INTO Support_Ticket VALUES (45, 45, 'Device setup', 'Need help configuring a new device', '2026-03-17', 'closed', 'high', 'email', 'Network Support', NULL, 3, 6, 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45')
INSERT INTO Support_Ticket VALUES (46, 46, 'Server location request', 'Please help choose a nearby server', '2026-03-18', 'open', 'low', 'web portal', 'Billing Support', NULL, 4, 7, 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46')
INSERT INTO Support_Ticket VALUES (47, 47, 'Subscription renewal', 'Need help renewing the VPN subscription', '2026-03-19', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 5, 8, 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47')
INSERT INTO Support_Ticket VALUES (48, 48, 'Security concern', 'Please review a security notification', '2026-03-20', 'closed', 'high', 'email', 'Network Support', '2026-02-20', 0, 9, 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48')
INSERT INTO Support_Ticket VALUES (49, 49, 'Connection issue', 'VPN connection disconnects frequently', '2026-03-21', 'open', 'low', 'web portal', 'Billing Support', NULL, 1, 10, 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49')
INSERT INTO Support_Ticket VALUES (50, 50, 'Slow speed', 'VPN speed is lower than expected', '2026-03-22', 'in_progress', 'medium', 'mobile app', 'Security Team', NULL, 2, 1, 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50')

INSERT INTO Ticket_Response VALUES (1, 1, 1, 'We are checking the connection logs', '2026-02-01', 'update', 'web portal', 18, 1, 'normal', 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01', 'Additional detail 5 for record 01')
INSERT INTO Ticket_Response VALUES (2, 2, 2, 'Please select a nearby VPN server', '2026-02-02', 'resolution', 'mobile app', 21, 0, 'enabled', 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02', 'Additional detail 5 for record 02')
INSERT INTO Ticket_Response VALUES (3, 3, 3, 'Your login issue has been resolved', '2026-02-03', 'answer', 'email', 24, 1, 'available', 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03', 'Additional detail 5 for record 03')
INSERT INTO Ticket_Response VALUES (4, 4, 4, 'Please share the payment transaction ID', '2026-02-04', 'update', 'web portal', 27, 0, 'active', 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04', 'Additional detail 5 for record 04')
INSERT INTO Ticket_Response VALUES (5, 5, 5, 'Please follow the device setup guide', '2026-02-05', 'resolution', 'mobile app', 30, 1, 'normal', 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05', 'Additional detail 5 for record 05')
INSERT INTO Ticket_Response VALUES (6, 6, 6, 'We have reviewed your request', '2026-02-06', 'answer', 'email', 33, 0, 'enabled', 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06', 'Additional detail 5 for record 06')
INSERT INTO Ticket_Response VALUES (7, 7, 7, 'Your subscription details have been updated', '2026-02-07', 'update', 'web portal', 36, 1, 'available', 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07', 'Additional detail 5 for record 07')
INSERT INTO Ticket_Response VALUES (8, 8, 8, 'We are checking the connection logs', '2026-02-08', 'resolution', 'mobile app', 39, 0, 'active', 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08', 'Additional detail 5 for record 08')
INSERT INTO Ticket_Response VALUES (9, 9, 9, 'Please select a nearby VPN server', '2026-02-09', 'answer', 'email', 42, 1, 'normal', 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09', 'Additional detail 5 for record 09')
INSERT INTO Ticket_Response VALUES (10, 10, 10, 'Your login issue has been resolved', '2026-02-10', 'update', 'web portal', 45, 0, 'enabled', 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10', 'Additional detail 5 for record 10')
INSERT INTO Ticket_Response VALUES (11, 11, 11, 'Please share the payment transaction ID', '2026-02-11', 'resolution', 'mobile app', 48, 1, 'available', 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11', 'Additional detail 5 for record 11')
INSERT INTO Ticket_Response VALUES (12, 12, 12, 'Please follow the device setup guide', '2026-02-12', 'answer', 'email', 51, 0, 'active', 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12', 'Additional detail 5 for record 12')
INSERT INTO Ticket_Response VALUES (13, 13, 13, 'We have reviewed your request', '2026-02-13', 'update', 'web portal', 54, 1, 'normal', 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13', 'Additional detail 5 for record 13')
INSERT INTO Ticket_Response VALUES (14, 14, 14, 'Your subscription details have been updated', '2026-02-14', 'resolution', 'mobile app', 57, 0, 'enabled', 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14', 'Additional detail 5 for record 14')
INSERT INTO Ticket_Response VALUES (15, 15, 15, 'We are checking the connection logs', '2026-02-15', 'answer', 'email', 60, 1, 'available', 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15', 'Additional detail 5 for record 15')
INSERT INTO Ticket_Response VALUES (16, 16, 16, 'Please select a nearby VPN server', '2026-02-16', 'update', 'web portal', 63, 0, 'active', 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16', 'Additional detail 5 for record 16')
INSERT INTO Ticket_Response VALUES (17, 17, 17, 'Your login issue has been resolved', '2026-02-17', 'resolution', 'mobile app', 66, 1, 'normal', 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17', 'Additional detail 5 for record 17')
INSERT INTO Ticket_Response VALUES (18, 18, 18, 'Please share the payment transaction ID', '2026-02-18', 'answer', 'email', 69, 0, 'enabled', 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18', 'Additional detail 5 for record 18')
INSERT INTO Ticket_Response VALUES (19, 19, 19, 'Please follow the device setup guide', '2026-02-19', 'update', 'web portal', 72, 1, 'available', 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19', 'Additional detail 5 for record 19')
INSERT INTO Ticket_Response VALUES (20, 20, 20, 'We have reviewed your request', '2026-02-20', 'resolution', 'mobile app', 75, 0, 'active', 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20', 'Additional detail 5 for record 20')
INSERT INTO Ticket_Response VALUES (21, 21, 21, 'Your subscription details have been updated', '2026-02-21', 'answer', 'email', 78, 1, 'normal', 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21', 'Additional detail 5 for record 21')
INSERT INTO Ticket_Response VALUES (22, 22, 22, 'We are checking the connection logs', '2026-02-22', 'update', 'web portal', 81, 0, 'enabled', 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22', 'Additional detail 5 for record 22')
INSERT INTO Ticket_Response VALUES (23, 23, 23, 'Please select a nearby VPN server', '2026-02-23', 'resolution', 'mobile app', 84, 1, 'available', 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23', 'Additional detail 5 for record 23')
INSERT INTO Ticket_Response VALUES (24, 24, 24, 'Your login issue has been resolved', '2026-02-24', 'answer', 'email', 87, 0, 'active', 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24', 'Additional detail 5 for record 24')
INSERT INTO Ticket_Response VALUES (25, 25, 25, 'Please share the payment transaction ID', '2026-02-25', 'update', 'web portal', 90, 1, 'normal', 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25', 'Additional detail 5 for record 25')
INSERT INTO Ticket_Response VALUES (26, 26, 26, 'Please follow the device setup guide', '2026-02-26', 'resolution', 'mobile app', 93, 0, 'enabled', 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26', 'Additional detail 5 for record 26')
INSERT INTO Ticket_Response VALUES (27, 27, 27, 'We have reviewed your request', '2026-02-27', 'answer', 'email', 96, 1, 'available', 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27', 'Additional detail 5 for record 27')
INSERT INTO Ticket_Response VALUES (28, 28, 28, 'Your subscription details have been updated', '2026-02-28', 'update', 'web portal', 99, 0, 'active', 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28', 'Additional detail 5 for record 28')
INSERT INTO Ticket_Response VALUES (29, 29, 29, 'We are checking the connection logs', '2026-03-01', 'resolution', 'mobile app', 102, 1, 'normal', 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29', 'Additional detail 5 for record 29')
INSERT INTO Ticket_Response VALUES (30, 30, 30, 'Please select a nearby VPN server', '2026-03-02', 'answer', 'email', 105, 0, 'enabled', 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30', 'Additional detail 5 for record 30')
INSERT INTO Ticket_Response VALUES (31, 31, 31, 'Your login issue has been resolved', '2026-03-03', 'update', 'web portal', 108, 1, 'available', 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31', 'Additional detail 5 for record 31')
INSERT INTO Ticket_Response VALUES (32, 32, 32, 'Please share the payment transaction ID', '2026-03-04', 'resolution', 'mobile app', 111, 0, 'active', 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32', 'Additional detail 5 for record 32')
INSERT INTO Ticket_Response VALUES (33, 33, 33, 'Please follow the device setup guide', '2026-03-05', 'answer', 'email', 114, 1, 'normal', 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33', 'Additional detail 5 for record 33')
INSERT INTO Ticket_Response VALUES (34, 34, 34, 'We have reviewed your request', '2026-03-06', 'update', 'web portal', 117, 0, 'enabled', 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34', 'Additional detail 5 for record 34')
INSERT INTO Ticket_Response VALUES (35, 35, 35, 'Your subscription details have been updated', '2026-03-07', 'resolution', 'mobile app', 120, 1, 'available', 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35', 'Additional detail 5 for record 35')
INSERT INTO Ticket_Response VALUES (36, 36, 36, 'We are checking the connection logs', '2026-03-08', 'answer', 'email', 123, 0, 'active', 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36', 'Additional detail 5 for record 36')
INSERT INTO Ticket_Response VALUES (37, 37, 37, 'Please select a nearby VPN server', '2026-03-09', 'update', 'web portal', 126, 1, 'normal', 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37', 'Additional detail 5 for record 37')
INSERT INTO Ticket_Response VALUES (38, 38, 38, 'Your login issue has been resolved', '2026-03-10', 'resolution', 'mobile app', 129, 0, 'enabled', 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38', 'Additional detail 5 for record 38')
INSERT INTO Ticket_Response VALUES (39, 39, 39, 'Please share the payment transaction ID', '2026-03-11', 'answer', 'email', 132, 1, 'available', 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39', 'Additional detail 5 for record 39')
INSERT INTO Ticket_Response VALUES (40, 40, 40, 'Please follow the device setup guide', '2026-03-12', 'update', 'web portal', 135, 0, 'active', 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40', 'Additional detail 5 for record 40')
INSERT INTO Ticket_Response VALUES (41, 41, 41, 'We have reviewed your request', '2026-03-13', 'resolution', 'mobile app', 138, 1, 'normal', 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41', 'Additional detail 5 for record 41')
INSERT INTO Ticket_Response VALUES (42, 42, 42, 'Your subscription details have been updated', '2026-03-14', 'answer', 'email', 141, 0, 'enabled', 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42', 'Additional detail 5 for record 42')
INSERT INTO Ticket_Response VALUES (43, 43, 43, 'We are checking the connection logs', '2026-03-15', 'update', 'web portal', 144, 1, 'available', 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43', 'Additional detail 5 for record 43')
INSERT INTO Ticket_Response VALUES (44, 44, 44, 'Please select a nearby VPN server', '2026-03-16', 'resolution', 'mobile app', 147, 0, 'active', 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44', 'Additional detail 5 for record 44')
INSERT INTO Ticket_Response VALUES (45, 45, 45, 'Your login issue has been resolved', '2026-03-17', 'answer', 'email', 150, 1, 'normal', 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45', 'Additional detail 5 for record 45')
INSERT INTO Ticket_Response VALUES (46, 46, 46, 'Please share the payment transaction ID', '2026-03-18', 'update', 'web portal', 153, 0, 'enabled', 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46', 'Additional detail 5 for record 46')
INSERT INTO Ticket_Response VALUES (47, 47, 47, 'Please follow the device setup guide', '2026-03-19', 'resolution', 'mobile app', 156, 1, 'available', 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47', 'Additional detail 5 for record 47')
INSERT INTO Ticket_Response VALUES (48, 48, 48, 'We have reviewed your request', '2026-03-20', 'answer', 'email', 159, 0, 'active', 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48', 'Additional detail 5 for record 48')
INSERT INTO Ticket_Response VALUES (49, 49, 49, 'Your subscription details have been updated', '2026-03-21', 'update', 'web portal', 162, 1, 'normal', 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49', 'Additional detail 5 for record 49')
INSERT INTO Ticket_Response VALUES (50, 50, 50, 'We are checking the connection logs', '2026-03-22', 'resolution', 'mobile app', 165, 0, 'enabled', 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50', 'Additional detail 5 for record 50')

INSERT INTO Feedback VALUES (1, 1, 1, 5, 'Fast and reliable connection', '2026-02-01', 'reliability', '2.1.1', 'desktop', 1, 1, 'Additional detail 1 for record 01', 'Additional detail 2 for record 01', 'Additional detail 3 for record 01', 'Additional detail 4 for record 01')
INSERT INTO Feedback VALUES (2, 2, 2, 4, 'Good service with stable speed', '2026-02-02', 'support', '3.2.2', 'tablet', 0, 0, 'Additional detail 1 for record 02', 'Additional detail 2 for record 02', 'Additional detail 3 for record 02', 'Additional detail 4 for record 02')
INSERT INTO Feedback VALUES (3, 3, 3, 3, 'Connection is acceptable', '2026-02-03', 'security', '1.3.3', 'mobile', 1, 1, 'Additional detail 1 for record 03', 'Additional detail 2 for record 03', 'Additional detail 3 for record 03', 'Additional detail 4 for record 03')
INSERT INTO Feedback VALUES (4, 4, 4, 5, 'Easy to use application', '2026-02-04', 'speed', '2.4.4', 'desktop', 0, 0, 'Additional detail 1 for record 04', 'Additional detail 2 for record 04', 'Additional detail 3 for record 04', 'Additional detail 4 for record 04')
INSERT INTO Feedback VALUES (5, 5, 5, 2, 'Connection needs improvement', '2026-02-05', 'reliability', '3.5.0', 'tablet', 1, 1, 'Additional detail 1 for record 05', 'Additional detail 2 for record 05', 'Additional detail 3 for record 05', 'Additional detail 4 for record 05')
INSERT INTO Feedback VALUES (6, 6, 6, 1, 'Helpful support team', '2026-02-06', 'support', '1.6.1', 'mobile', 0, 0, 'Additional detail 1 for record 06', 'Additional detail 2 for record 06', 'Additional detail 3 for record 06', 'Additional detail 4 for record 06')
INSERT INTO Feedback VALUES (7, 7, 7, 2, 'Simple and secure VPN service', '2026-02-07', 'security', '2.7.2', 'desktop', 1, 1, 'Additional detail 1 for record 07', 'Additional detail 2 for record 07', 'Additional detail 3 for record 07', 'Additional detail 4 for record 07')
INSERT INTO Feedback VALUES (8, 8, 8, 3, 'Fast and reliable connection', '2026-02-08', 'speed', '3.8.3', 'tablet', 0, 0, 'Additional detail 1 for record 08', 'Additional detail 2 for record 08', 'Additional detail 3 for record 08', 'Additional detail 4 for record 08')
INSERT INTO Feedback VALUES (9, 9, 9, 4, 'Good service with stable speed', '2026-02-09', 'reliability', '1.9.4', 'mobile', 1, 1, 'Additional detail 1 for record 09', 'Additional detail 2 for record 09', 'Additional detail 3 for record 09', 'Additional detail 4 for record 09')
INSERT INTO Feedback VALUES (10, 10, 10, 5, 'Connection is acceptable', '2026-02-10', 'support', '2.0.0', 'desktop', 0, 0, 'Additional detail 1 for record 10', 'Additional detail 2 for record 10', 'Additional detail 3 for record 10', 'Additional detail 4 for record 10')
INSERT INTO Feedback VALUES (11, 11, 11, 1, 'Easy to use application', '2026-02-11', 'security', '3.1.1', 'tablet', 1, 1, 'Additional detail 1 for record 11', 'Additional detail 2 for record 11', 'Additional detail 3 for record 11', 'Additional detail 4 for record 11')
INSERT INTO Feedback VALUES (12, 12, 12, 2, 'Connection needs improvement', '2026-02-12', 'speed', '1.2.2', 'mobile', 0, 0, 'Additional detail 1 for record 12', 'Additional detail 2 for record 12', 'Additional detail 3 for record 12', 'Additional detail 4 for record 12')
INSERT INTO Feedback VALUES (13, 13, 13, 3, 'Helpful support team', '2026-02-13', 'reliability', '2.3.3', 'desktop', 1, 1, 'Additional detail 1 for record 13', 'Additional detail 2 for record 13', 'Additional detail 3 for record 13', 'Additional detail 4 for record 13')
INSERT INTO Feedback VALUES (14, 14, 14, 4, 'Simple and secure VPN service', '2026-02-14', 'support', '3.4.4', 'tablet', 0, 0, 'Additional detail 1 for record 14', 'Additional detail 2 for record 14', 'Additional detail 3 for record 14', 'Additional detail 4 for record 14')
INSERT INTO Feedback VALUES (15, 15, 15, 5, 'Fast and reliable connection', '2026-02-15', 'security', '1.5.0', 'mobile', 1, 1, 'Additional detail 1 for record 15', 'Additional detail 2 for record 15', 'Additional detail 3 for record 15', 'Additional detail 4 for record 15')
INSERT INTO Feedback VALUES (16, 16, 16, 1, 'Good service with stable speed', '2026-02-16', 'speed', '2.6.1', 'desktop', 0, 0, 'Additional detail 1 for record 16', 'Additional detail 2 for record 16', 'Additional detail 3 for record 16', 'Additional detail 4 for record 16')
INSERT INTO Feedback VALUES (17, 17, 17, 2, 'Connection is acceptable', '2026-02-17', 'reliability', '3.7.2', 'tablet', 1, 1, 'Additional detail 1 for record 17', 'Additional detail 2 for record 17', 'Additional detail 3 for record 17', 'Additional detail 4 for record 17')
INSERT INTO Feedback VALUES (18, 18, 18, 3, 'Easy to use application', '2026-02-18', 'support', '1.8.3', 'mobile', 0, 0, 'Additional detail 1 for record 18', 'Additional detail 2 for record 18', 'Additional detail 3 for record 18', 'Additional detail 4 for record 18')
INSERT INTO Feedback VALUES (19, 19, 19, 4, 'Connection needs improvement', '2026-02-19', 'security', '2.9.4', 'desktop', 1, 1, 'Additional detail 1 for record 19', 'Additional detail 2 for record 19', 'Additional detail 3 for record 19', 'Additional detail 4 for record 19')
INSERT INTO Feedback VALUES (20, 20, 20, 5, 'Helpful support team', '2026-02-20', 'speed', '3.0.0', 'tablet', 0, 0, 'Additional detail 1 for record 20', 'Additional detail 2 for record 20', 'Additional detail 3 for record 20', 'Additional detail 4 for record 20')
INSERT INTO Feedback VALUES (21, 21, 21, 1, 'Simple and secure VPN service', '2026-02-21', 'reliability', '1.1.1', 'mobile', 1, 1, 'Additional detail 1 for record 21', 'Additional detail 2 for record 21', 'Additional detail 3 for record 21', 'Additional detail 4 for record 21')
INSERT INTO Feedback VALUES (22, 22, 22, 2, 'Fast and reliable connection', '2026-02-22', 'support', '2.2.2', 'desktop', 0, 0, 'Additional detail 1 for record 22', 'Additional detail 2 for record 22', 'Additional detail 3 for record 22', 'Additional detail 4 for record 22')
INSERT INTO Feedback VALUES (23, 23, 23, 3, 'Good service with stable speed', '2026-02-23', 'security', '3.3.3', 'tablet', 1, 1, 'Additional detail 1 for record 23', 'Additional detail 2 for record 23', 'Additional detail 3 for record 23', 'Additional detail 4 for record 23')
INSERT INTO Feedback VALUES (24, 24, 24, 4, 'Connection is acceptable', '2026-02-24', 'speed', '1.4.4', 'mobile', 0, 0, 'Additional detail 1 for record 24', 'Additional detail 2 for record 24', 'Additional detail 3 for record 24', 'Additional detail 4 for record 24')
INSERT INTO Feedback VALUES (25, 25, 25, 5, 'Easy to use application', '2026-02-25', 'reliability', '2.5.0', 'desktop', 1, 1, 'Additional detail 1 for record 25', 'Additional detail 2 for record 25', 'Additional detail 3 for record 25', 'Additional detail 4 for record 25')
INSERT INTO Feedback VALUES (26, 26, 26, 1, 'Connection needs improvement', '2026-02-26', 'support', '3.6.1', 'tablet', 0, 0, 'Additional detail 1 for record 26', 'Additional detail 2 for record 26', 'Additional detail 3 for record 26', 'Additional detail 4 for record 26')
INSERT INTO Feedback VALUES (27, 27, 27, 2, 'Helpful support team', '2026-02-27', 'security', '1.7.2', 'mobile', 1, 1, 'Additional detail 1 for record 27', 'Additional detail 2 for record 27', 'Additional detail 3 for record 27', 'Additional detail 4 for record 27')
INSERT INTO Feedback VALUES (28, 28, 28, 3, 'Simple and secure VPN service', '2026-02-28', 'speed', '2.8.3', 'desktop', 0, 0, 'Additional detail 1 for record 28', 'Additional detail 2 for record 28', 'Additional detail 3 for record 28', 'Additional detail 4 for record 28')
INSERT INTO Feedback VALUES (29, 29, 29, 4, 'Fast and reliable connection', '2026-03-01', 'reliability', '3.9.4', 'tablet', 1, 1, 'Additional detail 1 for record 29', 'Additional detail 2 for record 29', 'Additional detail 3 for record 29', 'Additional detail 4 for record 29')
INSERT INTO Feedback VALUES (30, 30, 30, 5, 'Good service with stable speed', '2026-03-02', 'support', '1.0.0', 'mobile', 0, 0, 'Additional detail 1 for record 30', 'Additional detail 2 for record 30', 'Additional detail 3 for record 30', 'Additional detail 4 for record 30')
INSERT INTO Feedback VALUES (31, 31, 31, 1, 'Connection is acceptable', '2026-03-03', 'security', '2.1.1', 'desktop', 1, 1, 'Additional detail 1 for record 31', 'Additional detail 2 for record 31', 'Additional detail 3 for record 31', 'Additional detail 4 for record 31')
INSERT INTO Feedback VALUES (32, 32, 32, 2, 'Easy to use application', '2026-03-04', 'speed', '3.2.2', 'tablet', 0, 0, 'Additional detail 1 for record 32', 'Additional detail 2 for record 32', 'Additional detail 3 for record 32', 'Additional detail 4 for record 32')
INSERT INTO Feedback VALUES (33, 33, 33, 3, 'Connection needs improvement', '2026-03-05', 'reliability', '1.3.3', 'mobile', 1, 1, 'Additional detail 1 for record 33', 'Additional detail 2 for record 33', 'Additional detail 3 for record 33', 'Additional detail 4 for record 33')
INSERT INTO Feedback VALUES (34, 34, 34, 4, 'Helpful support team', '2026-03-06', 'support', '2.4.4', 'desktop', 0, 0, 'Additional detail 1 for record 34', 'Additional detail 2 for record 34', 'Additional detail 3 for record 34', 'Additional detail 4 for record 34')
INSERT INTO Feedback VALUES (35, 35, 35, 5, 'Simple and secure VPN service', '2026-03-07', 'security', '3.5.0', 'tablet', 1, 1, 'Additional detail 1 for record 35', 'Additional detail 2 for record 35', 'Additional detail 3 for record 35', 'Additional detail 4 for record 35')
INSERT INTO Feedback VALUES (36, 36, 36, 1, 'Fast and reliable connection', '2026-03-08', 'speed', '1.6.1', 'mobile', 0, 0, 'Additional detail 1 for record 36', 'Additional detail 2 for record 36', 'Additional detail 3 for record 36', 'Additional detail 4 for record 36')
INSERT INTO Feedback VALUES (37, 37, 37, 2, 'Good service with stable speed', '2026-03-09', 'reliability', '2.7.2', 'desktop', 1, 1, 'Additional detail 1 for record 37', 'Additional detail 2 for record 37', 'Additional detail 3 for record 37', 'Additional detail 4 for record 37')
INSERT INTO Feedback VALUES (38, 38, 38, 3, 'Connection is acceptable', '2026-03-10', 'support', '3.8.3', 'tablet', 0, 0, 'Additional detail 1 for record 38', 'Additional detail 2 for record 38', 'Additional detail 3 for record 38', 'Additional detail 4 for record 38')
INSERT INTO Feedback VALUES (39, 39, 39, 4, 'Easy to use application', '2026-03-11', 'security', '1.9.4', 'mobile', 1, 1, 'Additional detail 1 for record 39', 'Additional detail 2 for record 39', 'Additional detail 3 for record 39', 'Additional detail 4 for record 39')
INSERT INTO Feedback VALUES (40, 40, 40, 5, 'Connection needs improvement', '2026-03-12', 'speed', '2.0.0', 'desktop', 0, 0, 'Additional detail 1 for record 40', 'Additional detail 2 for record 40', 'Additional detail 3 for record 40', 'Additional detail 4 for record 40')
INSERT INTO Feedback VALUES (41, 41, 41, 1, 'Helpful support team', '2026-03-13', 'reliability', '3.1.1', 'tablet', 1, 1, 'Additional detail 1 for record 41', 'Additional detail 2 for record 41', 'Additional detail 3 for record 41', 'Additional detail 4 for record 41')
INSERT INTO Feedback VALUES (42, 42, 42, 2, 'Simple and secure VPN service', '2026-03-14', 'support', '1.2.2', 'mobile', 0, 0, 'Additional detail 1 for record 42', 'Additional detail 2 for record 42', 'Additional detail 3 for record 42', 'Additional detail 4 for record 42')
INSERT INTO Feedback VALUES (43, 43, 43, 3, 'Fast and reliable connection', '2026-03-15', 'security', '2.3.3', 'desktop', 1, 1, 'Additional detail 1 for record 43', 'Additional detail 2 for record 43', 'Additional detail 3 for record 43', 'Additional detail 4 for record 43')
INSERT INTO Feedback VALUES (44, 44, 44, 4, 'Good service with stable speed', '2026-03-16', 'speed', '3.4.4', 'tablet', 0, 0, 'Additional detail 1 for record 44', 'Additional detail 2 for record 44', 'Additional detail 3 for record 44', 'Additional detail 4 for record 44')
INSERT INTO Feedback VALUES (45, 45, 45, 5, 'Connection is acceptable', '2026-03-17', 'reliability', '1.5.0', 'mobile', 1, 1, 'Additional detail 1 for record 45', 'Additional detail 2 for record 45', 'Additional detail 3 for record 45', 'Additional detail 4 for record 45')
INSERT INTO Feedback VALUES (46, 46, 46, 1, 'Easy to use application', '2026-03-18', 'support', '2.6.1', 'desktop', 0, 0, 'Additional detail 1 for record 46', 'Additional detail 2 for record 46', 'Additional detail 3 for record 46', 'Additional detail 4 for record 46')
INSERT INTO Feedback VALUES (47, 47, 47, 2, 'Connection needs improvement', '2026-03-19', 'security', '3.7.2', 'tablet', 1, 1, 'Additional detail 1 for record 47', 'Additional detail 2 for record 47', 'Additional detail 3 for record 47', 'Additional detail 4 for record 47')
INSERT INTO Feedback VALUES (48, 48, 48, 3, 'Helpful support team', '2026-03-20', 'speed', '1.8.3', 'mobile', 0, 0, 'Additional detail 1 for record 48', 'Additional detail 2 for record 48', 'Additional detail 3 for record 48', 'Additional detail 4 for record 48')
INSERT INTO Feedback VALUES (49, 49, 49, 4, 'Simple and secure VPN service', '2026-03-21', 'reliability', '2.9.4', 'desktop', 1, 1, 'Additional detail 1 for record 49', 'Additional detail 2 for record 49', 'Additional detail 3 for record 49', 'Additional detail 4 for record 49')
INSERT INTO Feedback VALUES (50, 50, 50, 5, 'Fast and reliable connection', '2026-03-22', 'support', '3.0.0', 'tablet', 0, 0, 'Additional detail 1 for record 50', 'Additional detail 2 for record 50', 'Additional detail 3 for record 50', 'Additional detail 4 for record 50')

-- DISPLAY ALL TABLES
SELECT * FROM Users
SELECT * FROM User_Profile
SELECT * FROM Admin
SELECT * FROM Server_Location
SELECT * FROM Server_Type
SELECT * FROM VPN_Server
SELECT * FROM VPN_Plan
SELECT * FROM Subscription
SELECT * FROM Payment_Method
SELECT * FROM Payment
SELECT * FROM Device
SELECT * FROM User_Device
SELECT * FROM VPN_Session
SELECT * FROM Connection_Log
SELECT * FROM Usage_Record
SELECT * FROM Security_Log
SELECT * FROM Server_Maintenance
SELECT * FROM Support_Ticket
SELECT * FROM Ticket_Response
SELECT * FROM Feedback

SELECT * FROM Users WHERE country = 'USA' AND 1 = 1
SELECT email, phone FROM Users WHERE gender = 'female' AND 2 = 2
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 3 = 3
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 4 = 4
SELECT * FROM VPN_Plan WHERE price < 500 AND 5 = 5
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 6 = 6
SELECT * FROM Payment WHERE payment_status = 'successful' AND 7 = 7
SELECT * FROM Users WHERE country = 'USA' AND 8 = 8
SELECT email, phone FROM Users WHERE gender = 'female' AND 9 = 9
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 10 = 10
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 11 = 11
SELECT * FROM VPN_Plan WHERE price < 500 AND 12 = 12
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 13 = 13
SELECT * FROM Payment WHERE payment_status = 'successful' AND 14 = 14
SELECT * FROM Users WHERE country = 'USA' AND 15 = 15
SELECT email, phone FROM Users WHERE gender = 'female' AND 16 = 16
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 17 = 17
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 18 = 18
SELECT * FROM VPN_Plan WHERE price < 500 AND 19 = 19
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 20 = 20
SELECT * FROM Payment WHERE payment_status = 'successful' AND 21 = 21
SELECT * FROM Users WHERE country = 'USA' AND 22 = 22
SELECT email, phone FROM Users WHERE gender = 'female' AND 23 = 23
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 24 = 24
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 25 = 25
SELECT * FROM VPN_Plan WHERE price < 500 AND 26 = 26
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 27 = 27
SELECT * FROM Payment WHERE payment_status = 'successful' AND 28 = 28
SELECT * FROM Users WHERE country = 'USA' AND 29 = 29
SELECT email, phone FROM Users WHERE gender = 'female' AND 30 = 30
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 31 = 31
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 32 = 32
SELECT * FROM VPN_Plan WHERE price < 500 AND 33 = 33
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 34 = 34
SELECT * FROM Payment WHERE payment_status = 'successful' AND 35 = 35
SELECT * FROM Users WHERE country = 'USA' AND 36 = 36
SELECT email, phone FROM Users WHERE gender = 'female' AND 37 = 37
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 38 = 38
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 39 = 39
SELECT * FROM VPN_Plan WHERE price < 500 AND 40 = 40
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 41 = 41
SELECT * FROM Payment WHERE payment_status = 'successful' AND 42 = 42
SELECT * FROM Users WHERE country = 'USA' AND 43 = 43
SELECT email, phone FROM Users WHERE gender = 'female' AND 44 = 44
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 45 = 45
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 46 = 46
SELECT * FROM VPN_Plan WHERE price < 500 AND 47 = 47
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 48 = 48
SELECT * FROM Payment WHERE payment_status = 'successful' AND 49 = 49
SELECT * FROM Users WHERE country = 'USA' AND 50 = 50
SELECT email, phone FROM Users WHERE gender = 'female' AND 51 = 51
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 52 = 52
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 53 = 53
SELECT * FROM VPN_Plan WHERE price < 500 AND 54 = 54
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 55 = 55
SELECT * FROM Payment WHERE payment_status = 'successful' AND 56 = 56
SELECT * FROM Users WHERE country = 'USA' AND 57 = 57
SELECT email, phone FROM Users WHERE gender = 'female' AND 58 = 58
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 59 = 59
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 60 = 60
SELECT * FROM VPN_Plan WHERE price < 500 AND 61 = 61
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 62 = 62
SELECT * FROM Payment WHERE payment_status = 'successful' AND 63 = 63
SELECT * FROM Users WHERE country = 'USA' AND 64 = 64
SELECT email, phone FROM Users WHERE gender = 'female' AND 65 = 65
SELECT * FROM VPN_Server WHERE server_status = 'online' AND 66 = 66
SELECT server_name, server_ip FROM VPN_Server WHERE current_users > 100 AND 67 = 67
SELECT * FROM VPN_Plan WHERE price < 500 AND 68 = 68
SELECT plan_name, duration_months FROM VPN_Plan WHERE plan_status = 'active' AND 69 = 69
SELECT * FROM Payment WHERE payment_status = 'successful' AND 70 = 70
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 71 = 71
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 72 = 72
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 73 = 73
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 74 = 74
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 75 = 75
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 76 = 76
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 77 = 77
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 78 = 78
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 79 = 79
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 80 = 80
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 81 = 81
SELECT first_name FROM Users WHERE registration_date > '2026-01-01' AND 82 = 82
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 83 = 83
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 84 = 84
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 85 = 85
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 86 = 86
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 87 = 87
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 88 = 88
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 89 = 89
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 90 = 90
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 91 = 91
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 92 = 92
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 93 = 93
SELECT last_name FROM Users WHERE registration_date > '2026-01-01' AND 94 = 94
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 95 = 95
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 96 = 96
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 97 = 97
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 98 = 98
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 99 = 99
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 100 = 100
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 101 = 101
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 102 = 102
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 103 = 103
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 104 = 104
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 105 = 105
SELECT city FROM Users WHERE registration_date > '2026-01-01' AND 106 = 106
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 107 = 107
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 108 = 108
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 109 = 109
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 110 = 110
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 111 = 111
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 112 = 112
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 113 = 113
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 114 = 114
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 115 = 115
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 116 = 116
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 117 = 117
SELECT postal_code FROM Users WHERE registration_date > '2026-01-01' AND 118 = 118
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 119 = 119
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 120 = 120
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 121 = 121
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 122 = 122
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 123 = 123
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 124 = 124
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 125 = 125
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 126 = 126
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 127 = 127
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 128 = 128
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 129 = 129
SELECT address FROM Users WHERE registration_date > '2026-01-01' AND 130 = 130
SELECT country, COUNT(*) FROM Users  WHERE 131 = 131 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 132 = 132 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 133 = 133 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 134 = 134 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 135 = 135 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 136 = 136 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 137 = 137 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 138 = 138 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 139 = 139 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 140 = 140 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 141 = 141 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 142 = 142 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 143 = 143 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 144 = 144 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 145 = 145 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 146 = 146 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 147 = 147 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 148 = 148 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 149 = 149 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 150 = 150 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 151 = 151 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 152 = 152 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 153 = 153 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 154 = 154 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 155 = 155 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 156 = 156 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 157 = 157 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 158 = 158 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 159 = 159 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 160 = 160 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 161 = 161 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 162 = 162 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 163 = 163 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 164 = 164 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 165 = 165 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 166 = 166 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 167 = 167 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 168 = 168 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 169 = 169 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 170 = 170 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 171 = 171 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 172 = 172 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 173 = 173 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 174 = 174 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 175 = 175 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 176 = 176 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 177 = 177 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 178 = 178 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 179 = 179 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 180 = 180 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 181 = 181 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 182 = 182 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 183 = 183 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 184 = 184 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 185 = 185 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 186 = 186 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 187 = 187 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 188 = 188 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 189 = 189 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 190 = 190 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 191 = 191 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 192 = 192 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 193 = 193 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 194 = 194 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 195 = 195 GROUP BY  plan_type
SELECT country, COUNT(*) FROM Users  WHERE 196 = 196 GROUP BY  country
SELECT server_status, AVG(current_users) FROM VPN_Server  WHERE 197 = 197 GROUP BY  server_status
SELECT payment_status, SUM(amount) FROM Payment  WHERE 198 = 198 GROUP BY  payment_status
SELECT currency, MAX(amount) FROM Payment  WHERE 199 = 199 GROUP BY  currency
SELECT plan_type, MIN(price) FROM VPN_Plan  WHERE 200 = 200 GROUP BY  plan_type
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 201 = 201
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 202 = 202
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 203 = 203
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 204 = 204
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 205 = 205
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 206 = 206
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 207 = 207
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 208 = 208
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 209 = 209
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 210 = 210
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 211 = 211
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 212 = 212
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 213 = 213
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 214 = 214
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 215 = 215
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 216 = 216
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 217 = 217
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 218 = 218
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 219 = 219
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 220 = 220
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 221 = 221
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 222 = 222
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 223 = 223
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 224 = 224
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 225 = 225
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 226 = 226
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 227 = 227
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 228 = 228
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 229 = 229
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 230 = 230
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 231 = 231
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 232 = 232
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 233 = 233
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 234 = 234
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 235 = 235
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 236 = 236
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 237 = 237
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 238 = 238
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 239 = 239
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 240 = 240
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 241 = 241
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 242 = 242
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 243 = 243
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 244 = 244
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 245 = 245
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 246 = 246
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 247 = 247
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 248 = 248
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 249 = 249
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 250 = 250
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 251 = 251
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 252 = 252
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 253 = 253
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 254 = 254
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 255 = 255
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 256 = 256
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 257 = 257
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 258 = 258
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 259 = 259
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 260 = 260
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 261 = 261
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 262 = 262
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 263 = 263
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 264 = 264
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 265 = 265
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 266 = 266
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 267 = 267
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 268 = 268
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 269 = 269
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 270 = 270
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 271 = 271
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 272 = 272
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 273 = 273
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 274 = 274
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 275 = 275
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 276 = 276
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 277 = 277
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 278 = 278
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 279 = 279
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 280 = 280
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 281 = 281
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 282 = 282
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 283 = 283
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 284 = 284
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 285 = 285
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 286 = 286
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 287 = 287
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 288 = 288
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 289 = 289
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 290 = 290
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 291 = 291
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 292 = 292
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 293 = 293
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 294 = 294
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 295 = 295
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 296 = 296
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 297 = 297
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 298 = 298
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 299 = 299
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 300 = 300
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 301 = 301
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 302 = 302
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 303 = 303
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 304 = 304
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 305 = 305
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 306 = 306
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 307 = 307
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 308 = 308
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 309 = 309
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 310 = 310
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 311 = 311
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 312 = 312
SELECT u.first_name, up.username FROM Users u INNER JOIN User_Profile up ON u.user_id = up.user_id WHERE 313 = 313
SELECT s.server_name, sl.location_name FROM VPN_Server s INNER JOIN Server_Location sl ON s.location_id = sl.location_id WHERE 314 = 314
SELECT s.server_name, st.server_type_name FROM VPN_Server s INNER JOIN Server_Type st ON s.server_type_id = st.server_type_id WHERE 315 = 315
SELECT sub.subscription_id, p.transaction_id FROM Subscription sub INNER JOIN Payment p ON sub.subscription_id = p.subscription_id WHERE 316 = 316
SELECT d.device_name, u.first_name FROM Device d INNER JOIN Users u ON d.user_id = u.user_id WHERE 317 = 317
SELECT vs.session_id, s.server_name FROM VPN_Session vs INNER JOIN VPN_Server s ON vs.server_id = s.server_id WHERE 318 = 318
SELECT cl.log_id, vs.ip_address FROM Connection_Log cl INNER JOIN VPN_Session vs ON cl.session_id = vs.session_id WHERE 319 = 319
SELECT ur.usage_id, vs.session_status FROM Usage_Record ur INNER JOIN VPN_Session vs ON ur.session_id = vs.session_id WHERE 320 = 320
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 321 = 321
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 322 = 322
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 323 = 323
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 324 = 324
SELECT first_name FROM Users WHERE 325=325 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 326 = 326
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 327 = 327
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 328 = 328
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 329 = 329
SELECT first_name FROM Users WHERE 330=330 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 331 = 331
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 332 = 332
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 333 = 333
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 334 = 334
SELECT first_name FROM Users WHERE 335=335 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 336 = 336
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 337 = 337
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 338 = 338
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 339 = 339
SELECT first_name FROM Users WHERE 340=340 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 341 = 341
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 342 = 342
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 343 = 343
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 344 = 344
SELECT first_name FROM Users WHERE 345=345 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 346 = 346
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 347 = 347
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 348 = 348
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 349 = 349
SELECT first_name FROM Users WHERE 350=350 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 351 = 351
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 352 = 352
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 353 = 353
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 354 = 354
SELECT first_name FROM Users WHERE 355=355 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 356 = 356
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 357 = 357
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 358 = 358
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 359 = 359
SELECT first_name FROM Users WHERE 360=360 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 361 = 361
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 362 = 362
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 363 = 363
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 364 = 364
SELECT first_name FROM Users WHERE 365=365 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 366 = 366
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 367 = 367
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 368 = 368
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 369 = 369
SELECT first_name FROM Users WHERE 370=370 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 371 = 371
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 372 = 372
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 373 = 373
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 374 = 374
SELECT first_name FROM Users WHERE 375=375 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 376 = 376
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 377 = 377
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 378 = 378
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 379 = 379
SELECT first_name FROM Users WHERE 380=380 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 381 = 381
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 382 = 382
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 383 = 383
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 384 = 384
SELECT first_name FROM Users WHERE 385=385 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 386 = 386
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 387 = 387
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 388 = 388
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 389 = 389
SELECT first_name FROM Users WHERE 390=390 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 391 = 391
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 392 = 392
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 393 = 393
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 394 = 394
SELECT first_name FROM Users WHERE 395=395 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE user_id IN (SELECT user_id FROM User_Profile WHERE failed_login_attempts > 2) AND 396 = 396
SELECT * FROM VPN_Server WHERE location_id IN (SELECT location_id FROM Server_Location WHERE country = 'India') AND 397 = 397
SELECT * FROM Subscription WHERE plan_id IN (SELECT plan_id FROM VPN_Plan WHERE price > 1000) AND 398 = 398
SELECT * FROM Payment WHERE subscription_id IN (SELECT subscription_id FROM Subscription WHERE subscription_status = 'active') AND 399 = 399
SELECT first_name FROM Users WHERE 400=400 UNION SELECT first_name FROM Admin
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 401 = 401
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 402 = 402
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 403 = 403
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 404 = 404
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 405 = 405
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 406 = 406
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 407 = 407
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 408 = 408
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 409 = 409
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 410 = 410
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 411 = 411
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 412 = 412
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 413 = 413
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 414 = 414
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 415 = 415
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 416 = 416
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 417 = 417
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 418 = 418
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 419 = 419
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 420 = 420
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 421 = 421
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 422 = 422
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 423 = 423
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 424 = 424
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 425 = 425
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 426 = 426
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 427 = 427
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 428 = 428
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 429 = 429
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 430 = 430
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 431 = 431
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 432 = 432
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 433 = 433
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 434 = 434
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 435 = 435
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 436 = 436
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 437 = 437
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 438 = 438
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 439 = 439
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 440 = 440
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 441 = 441
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 442 = 442
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 443 = 443
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 444 = 444
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 445 = 445
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 446 = 446
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 447 = 447
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 448 = 448
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 449 = 449
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 450 = 450
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 451 = 451
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 452 = 452
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 453 = 453
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 454 = 454
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 455 = 455
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 456 = 456
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 457 = 457
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 458 = 458
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 459 = 459
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 460 = 460
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 461 = 461
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 462 = 462
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 463 = 463
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 464 = 464
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 465 = 465
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 466 = 466
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 467 = 467
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 468 = 468
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 469 = 469
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 470 = 470
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 471 = 471
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 472 = 472
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 473 = 473
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 474 = 474
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 475 = 475
SELECT * FROM Users WHERE registration_date BETWEEN '2026-01-01' AND '2026-01-31' AND 476 = 476
SELECT * FROM Payment WHERE payment_date > '2026-02-01' AND 477 = 477
SELECT * FROM VPN_Session WHERE start_time >= '2026-01-10 00:00:00' AND 478 = 478
SELECT * FROM Server_Maintenance WHERE maintenance_date < '2026-03-01' AND 479 = 479
SELECT * FROM Support_Ticket WHERE created_date = '2026-02-01' AND 480 = 480
SELECT * FROM Security_Log WHERE severity = 'high' AND 481 = 481
SELECT * FROM Feedback WHERE rating = 5 AND 482 = 482
SELECT * FROM Ticket_Response WHERE is_internal_note = 1 AND 483 = 483
SELECT * FROM User_Device WHERE assignment_status = 'active' AND 484 = 484
SELECT * FROM Server_Maintenance WHERE maintenance_status = 'completed' AND 485 = 485
SELECT * FROM Security_Log WHERE severity = 'high' AND 486 = 486
SELECT * FROM Feedback WHERE rating = 5 AND 487 = 487
SELECT * FROM Ticket_Response WHERE is_internal_note = 1 AND 488 = 488
SELECT * FROM User_Device WHERE assignment_status = 'active' AND 489 = 489
SELECT * FROM Server_Maintenance WHERE maintenance_status = 'completed' AND 490 = 490
SELECT * FROM Security_Log WHERE severity = 'high' AND 491 = 491
SELECT * FROM Feedback WHERE rating = 5 AND 492 = 492
SELECT * FROM Ticket_Response WHERE is_internal_note = 1 AND 493 = 493
SELECT * FROM User_Device WHERE assignment_status = 'active' AND 494 = 494
SELECT * FROM Server_Maintenance WHERE maintenance_status = 'completed' AND 495 = 495
SELECT * FROM Security_Log WHERE severity = 'high' AND 496 = 496
SELECT * FROM Feedback WHERE rating = 5 AND 497 = 497
SELECT * FROM Ticket_Response WHERE is_internal_note = 1 AND 498 = 498
SELECT * FROM User_Device WHERE assignment_status = 'active' AND 499 = 499
SELECT * FROM Server_Maintenance WHERE maintenance_status = 'completed' AND 500 = 500