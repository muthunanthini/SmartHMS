-- ==============================================================
-- SMART HOSPITAL MANAGEMENT SYSTEM (SmartHMS) - MediCore AI
-- Database Schema (Normalized 3NF)
-- MySQL 8.x
-- ==============================================================

CREATE DATABASE IF NOT EXISTS `smarthms_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `smarthms_db`;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. USERS TABLE
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `full_name` VARCHAR(150) NOT NULL,
    `role` ENUM('ADMIN', 'DOCTOR', 'RECEPTIONIST', 'LAB_STAFF', 'PHARMACIST', 'PATIENT') NOT NULL,
    `phone` VARCHAR(25),
    `avatar_url` VARCHAR(255),
    `active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_users_email` (`email`),
    INDEX `idx_users_role` (`role`)
) ENGINE=InnoDB;

-- 2. DEPARTMENTS TABLE
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL UNIQUE,
    `code` VARCHAR(20) NOT NULL UNIQUE,
    `description` TEXT,
    `head_of_department` VARCHAR(150),
    `phone` VARCHAR(25),
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. DOCTORS TABLE
DROP TABLE IF EXISTS `doctors`;
CREATE TABLE `doctors` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    `doctor_code` VARCHAR(30) NOT NULL UNIQUE,
    `department_id` BIGINT NOT NULL,
    `specialization` VARCHAR(100) NOT NULL,
    `qualification` VARCHAR(150) NOT NULL,
    `experience_years` INT NOT NULL DEFAULT 0,
    `consultation_fee` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `availability_schedule` VARCHAR(255) DEFAULT 'Mon-Fri 09:00 AM - 05:00 PM',
    `room_number` VARCHAR(50),
    `active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doctor_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
    INDEX `idx_doctor_specialization` (`specialization`)
) ENGINE=InnoDB;

-- 4. PATIENTS TABLE
DROP TABLE IF EXISTS `patients`;
CREATE TABLE `patients` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT UNIQUE,
    `patient_id_code` VARCHAR(30) NOT NULL UNIQUE,
    `full_name` VARCHAR(150) NOT NULL,
    `dob` DATE NOT NULL,
    `gender` ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    `blood_group` VARCHAR(10),
    `phone` VARCHAR(25) NOT NULL,
    `email` VARCHAR(150),
    `address` TEXT,
    `emergency_contact` VARCHAR(150),
    `emergency_phone` VARCHAR(25),
    `allergies` TEXT,
    `chronic_conditions` TEXT,
    `registration_date` DATE NOT NULL,
    `active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_patient_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
    INDEX `idx_patient_code` (`patient_id_code`),
    INDEX `idx_patient_phone` (`phone`)
) ENGINE=InnoDB;

-- 5. APPOINTMENTS TABLE
DROP TABLE IF EXISTS `appointments`;
CREATE TABLE `appointments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `appointment_number` VARCHAR(30) NOT NULL UNIQUE,
    `patient_id` BIGINT NOT NULL,
    `doctor_id` BIGINT NOT NULL,
    `department_id` BIGINT,
    `appointment_date` DATE NOT NULL,
    `appointment_time` VARCHAR(20) NOT NULL,
    `token_number` INT NOT NULL DEFAULT 1,
    `reason` TEXT NOT NULL,
    `status` ENUM('BOOKED', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'NO_SHOW') NOT NULL DEFAULT 'BOOKED',
    `cancellation_reason` VARCHAR(255),
    `notes` TEXT,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_apt_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_apt_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_apt_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
    CONSTRAINT `uq_doctor_datetime` UNIQUE (`doctor_id`, `appointment_date`, `appointment_time`),
    INDEX `idx_apt_date` (`appointment_date`),
    INDEX `idx_apt_status` (`status`)
) ENGINE=InnoDB;

-- 6. MEDICAL RECORDS TABLE
DROP TABLE IF EXISTS `medical_records`;
CREATE TABLE `medical_records` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `record_number` VARCHAR(30) NOT NULL UNIQUE,
    `patient_id` BIGINT NOT NULL,
    `doctor_id` BIGINT NOT NULL,
    `appointment_id` BIGINT UNIQUE,
    `visit_date` DATE NOT NULL,
    `symptoms` TEXT NOT NULL,
    `diagnosis` TEXT NOT NULL,
    `clinical_notes` TEXT,
    `treatment_plan` TEXT,
    `vital_signs` VARCHAR(255), -- e.g. "BP: 120/80, HR: 72, Temp: 98.6F"
    `follow_up_date` DATE,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_mr_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_mr_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_mr_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL,
    INDEX `idx_mr_patient` (`patient_id`)
) ENGINE=InnoDB;

-- 7. PRESCRIPTIONS TABLE
DROP TABLE IF EXISTS `prescriptions`;
CREATE TABLE `prescriptions` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `prescription_number` VARCHAR(30) NOT NULL UNIQUE,
    `patient_id` BIGINT NOT NULL,
    `doctor_id` BIGINT NOT NULL,
    `appointment_id` BIGINT,
    `prescription_date` DATE NOT NULL,
    `diagnosis` VARCHAR(255),
    `instructions` TEXT,
    `status` ENUM('ACTIVE', 'DISPENSED', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_pres_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_pres_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_pres_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 8. MEDICINES TABLE
DROP TABLE IF EXISTS `medicines`;
CREATE TABLE `medicines` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(30) NOT NULL UNIQUE,
    `name` VARCHAR(150) NOT NULL,
    `generic_name` VARCHAR(150),
    `category` VARCHAR(100) NOT NULL, -- e.g., Antibiotic, Analgesic, Antihypertensive
    `manufacturer` VARCHAR(150),
    `unit_price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `requires_prescription` BOOLEAN NOT NULL DEFAULT TRUE,
    `description` TEXT,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_med_name` (`name`),
    INDEX `idx_med_category` (`category`)
) ENGINE=InnoDB;

-- 9. MEDICINE STOCK TABLE
DROP TABLE IF EXISTS `medicine_stock`;
CREATE TABLE `medicine_stock` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `medicine_id` BIGINT NOT NULL,
    `batch_number` VARCHAR(50) NOT NULL UNIQUE,
    `quantity` INT NOT NULL DEFAULT 0,
    `min_reorder_level` INT NOT NULL DEFAULT 20,
    `expiry_date` DATE NOT NULL,
    `unit_cost` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `supplier` VARCHAR(150),
    `status` VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_stock_medicine` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE RESTRICT,
    INDEX `idx_stock_expiry` (`expiry_date`)
) ENGINE=InnoDB;

-- 10. PRESCRIPTION ITEMS TABLE
DROP TABLE IF EXISTS `prescription_items`;
CREATE TABLE `prescription_items` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `prescription_id` BIGINT NOT NULL,
    `medicine_id` BIGINT NOT NULL,
    `dosage` VARCHAR(50) NOT NULL, -- e.g. "500mg"
    `frequency` VARCHAR(50) NOT NULL, -- e.g. "2 times/day (Morning, Night)"
    `duration` VARCHAR(50) NOT NULL, -- e.g. "5 days"
    `instructions` VARCHAR(255), -- e.g. "After food"
    `quantity` INT NOT NULL DEFAULT 1,
    `dispensed` BOOLEAN NOT NULL DEFAULT FALSE,
    `dispensed_at` DATETIME,
    CONSTRAINT `fk_pi_prescription` FOREIGN KEY (`prescription_id`) REFERENCES `prescriptions` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_pi_medicine` FOREIGN KEY (`medicine_id`) REFERENCES `medicines` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 11. LAB TESTS MASTER TABLE
DROP TABLE IF EXISTS `lab_tests`;
CREATE TABLE `lab_tests` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `test_code` VARCHAR(30) NOT NULL UNIQUE,
    `test_name` VARCHAR(150) NOT NULL,
    `category` VARCHAR(100) NOT NULL, -- Hematology, Biochemistry, Radiology, etc.
    `description` TEXT,
    `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `normal_range` VARCHAR(150),
    `sample_type` VARCHAR(80), -- Blood, Urine, Serum, Swab, etc.
    `turnaround_hours` INT NOT NULL DEFAULT 24,
    `status` VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 12. LAB REPORTS / ORDERS TABLE
DROP TABLE IF EXISTS `lab_reports`;
CREATE TABLE `lab_reports` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `report_number` VARCHAR(30) NOT NULL UNIQUE,
    `patient_id` BIGINT NOT NULL,
    `doctor_id` BIGINT NOT NULL,
    `test_id` BIGINT NOT NULL,
    `appointment_id` BIGINT,
    `status` ENUM('REQUESTED', 'SAMPLE_COLLECTED', 'PROCESSING', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'REQUESTED',
    `sample_collected_at` DATETIME,
    `result_value` TEXT,
    `reference_range` VARCHAR(150),
    `remarks` TEXT,
    `performed_by_user_id` BIGINT,
    `completed_at` DATETIME,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_lr_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_lr_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_lr_test` FOREIGN KEY (`test_id`) REFERENCES `lab_tests` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_lr_staff` FOREIGN KEY (`performed_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
    INDEX `idx_lr_status` (`status`)
) ENGINE=InnoDB;

-- 13. BEDS TABLE
DROP TABLE IF EXISTS `beds`;
CREATE TABLE `beds` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `bed_number` VARCHAR(30) NOT NULL UNIQUE,
    `ward_name` VARCHAR(100) NOT NULL,
    `room_number` VARCHAR(50) NOT NULL,
    `bed_type` ENUM('GENERAL', 'ICU', 'EMERGENCY', 'SEMI_PRIVATE', 'PRIVATE') NOT NULL DEFAULT 'GENERAL',
    `daily_rate` DECIMAL(10,2) NOT NULL DEFAULT 500.00,
    `status` ENUM('AVAILABLE', 'OCCUPIED', 'RESERVED', 'MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE',
    `notes` VARCHAR(255),
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_bed_status` (`status`),
    INDEX `idx_bed_ward` (`ward_name`)
) ENGINE=InnoDB;

-- 14. ADMISSIONS TABLE
DROP TABLE IF EXISTS `admissions`;
CREATE TABLE `admissions` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `admission_number` VARCHAR(30) NOT NULL UNIQUE,
    `patient_id` BIGINT NOT NULL,
    `bed_id` BIGINT NOT NULL,
    `doctor_id` BIGINT NOT NULL,
    `admission_date` DATETIME NOT NULL,
    `discharge_date` DATETIME,
    `admission_reason` TEXT NOT NULL,
    `discharge_summary` TEXT,
    `status` ENUM('ADMITTED', 'DISCHARGED', 'TRANSFERRED') NOT NULL DEFAULT 'ADMITTED',
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_adm_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_adm_bed` FOREIGN KEY (`bed_id`) REFERENCES `beds` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_adm_doctor` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`id`) ON DELETE RESTRICT,
    INDEX `idx_adm_status` (`status`)
) ENGINE=InnoDB;

-- 15. BILLS TABLE
DROP TABLE IF EXISTS `bills`;
CREATE TABLE `bills` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `bill_number` VARCHAR(30) NOT NULL UNIQUE,
    `patient_id` BIGINT NOT NULL,
    `appointment_id` BIGINT,
    `admission_id` BIGINT,
    `subtotal` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `tax_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `discount_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `total_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `paid_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `payment_status` ENUM('PENDING', 'PARTIAL', 'PAID', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    `payment_method` VARCHAR(50), -- CASH, CARD, UPI, INSURANCE
    `billing_date` DATE NOT NULL,
    `due_date` DATE,
    `notes` TEXT,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_bill_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_bill_apt` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_bill_adm` FOREIGN KEY (`admission_id`) REFERENCES `admissions` (`id`) ON DELETE SET NULL,
    INDEX `idx_bill_status` (`payment_status`)
) ENGINE=InnoDB;

-- 16. BILL ITEMS TABLE
DROP TABLE IF EXISTS `bill_items`;
CREATE TABLE `bill_items` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `bill_id` BIGINT NOT NULL,
    `item_category` ENUM('Consultation', 'Laboratory', 'Pharmacy', 'Room/Bed', 'Other services') NOT NULL,
    `item_name` VARCHAR(150) NOT NULL,
    `quantity` INT NOT NULL DEFAULT 1,
    `unit_price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    `total_price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT `fk_bi_bill` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 17. NOTIFICATIONS TABLE
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `title` VARCHAR(150) NOT NULL,
    `message` TEXT NOT NULL,
    `type` VARCHAR(50) NOT NULL DEFAULT 'INFO', -- INFO, ALERT, APPOINTMENT, REMINDER
    `is_read` BOOLEAN NOT NULL DEFAULT FALSE,
    `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
