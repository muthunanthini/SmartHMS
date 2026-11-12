-- ==============================================================
-- SMART HOSPITAL MANAGEMENT SYSTEM (SmartHMS) - Seed Data
-- Seed accounts with password: Password@123
-- ==============================================================

USE `smarthms_db`;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. USERS
-- Password is 'Password@123'
TRUNCATE TABLE `users`;
INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `role`, `phone`, `active`) VALUES
(1, 'admin@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'Dr. Alexander Vance (Chief Admin)', 'ADMIN', '+1-555-0100', TRUE),
(2, 'doctor@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'Dr. Sarah Jenkins', 'DOCTOR', '+1-555-0101', TRUE),
(3, 'doctor2@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'Dr. Robert Chen', 'DOCTOR', '+1-555-0102', TRUE),
(4, 'receptionist@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'Emma Watson', 'RECEPTIONIST', '+1-555-0103', TRUE),
(5, 'lab@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'David Miller', 'LAB_STAFF', '+1-555-0104', TRUE),
(6, 'pharmacy@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'Lisa Ray', 'PHARMACIST', '+1-555-0105', TRUE),
(7, 'patient@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'John Doe', 'PATIENT', '+1-555-0106', TRUE),
(8, 'patient2@smarthms.com', '$2a$10$sHLFVwiGCtTB4B8Gg3wkceUGO3SaQ6Xd7A607.LeMTJ.za877uaJW', 'Maria Garcia', 'PATIENT', '+1-555-0107', TRUE);

-- 2. DEPARTMENTS
TRUNCATE TABLE `departments`;
INSERT INTO `departments` (`id`, `name`, `code`, `description`, `head_of_department`, `phone`, `status`) VALUES
(1, 'Cardiology', 'CARD', 'Comprehensive cardiac diagnosis, interventional cardiology, and heart care.', 'Dr. Sarah Jenkins', '+1-555-1001', 'ACTIVE'),
(2, 'Neurology', 'NEUR', 'Advanced neurological assessment, stroke care, and neuro-rehabilitation.', 'Dr. Robert Chen', '+1-555-1002', 'ACTIVE'),
(3, 'Pediatrics', 'PED', 'Compassionate pediatric healthcare, child immunizations, and wellness.', 'Dr. Emily Watson', '+1-555-1003', 'ACTIVE'),
(4, 'Orthopedics', 'ORTH', 'Bone and joint care, sports injuries, and orthopedic surgery.', 'Dr. Marcus Brody', '+1-555-1004', 'ACTIVE'),
(5, 'General Medicine', 'GENM', 'Primary healthcare, internal medicine, preventive care, and triage.', 'Dr. Thomas Wayne', '+1-555-1005', 'ACTIVE');

-- 3. DOCTORS
TRUNCATE TABLE `doctors`;
INSERT INTO `doctors` (`id`, `user_id`, `doctor_code`, `department_id`, `specialization`, `qualification`, `experience_years`, `consultation_fee`, `availability_schedule`, `room_number`, `active`) VALUES
(1, 2, 'DOC-1001', 1, 'Cardiologist', 'MD, FACC - Harvard Medical', 14, 150.00, 'Mon-Fri 09:00 AM - 04:00 PM', 'Room 204', TRUE),
(2, 3, 'DOC-1002', 2, 'Neurologist', 'MD, DM Neurology - Johns Hopkins', 11, 180.00, 'Mon-Thu 10:00 AM - 05:00 PM', 'Room 308', TRUE);

-- 4. PATIENTS
TRUNCATE TABLE `patients`;
INSERT INTO `patients` (`id`, `user_id`, `patient_id_code`, `full_name`, `dob`, `gender`, `blood_group`, `phone`, `email`, `address`, `emergency_contact`, `emergency_phone`, `allergies`, `chronic_conditions`, `registration_date`, `active`) VALUES
(1, 7, 'PAT-2026-001', 'John Doe', '1988-06-15', 'MALE', 'O+', '+1-555-0106', 'patient@smarthms.com', '742 Evergreen Terrace, Springfield', 'Jane Doe (Spouse)', '+1-555-0999', 'Penicillin', 'Hypertension, Mild Asthma', '2026-01-10', TRUE),
(2, 8, 'PAT-2026-002', 'Maria Garcia', '1992-11-23', 'FEMALE', 'A+', '+1-555-0107', 'patient2@smarthms.com', '124 Conch Street, Pacific Bay', 'Carlos Garcia (Brother)', '+1-555-0888', 'Sulfa drugs', 'Type 2 Diabetes', '2026-02-14', TRUE),
(3, NULL, 'PAT-2026-003', 'William Sterling', '1965-03-30', 'MALE', 'B+', '+1-555-0211', 'william.sterling@gmail.com', '45 Baker Street, Metro City', 'Eleanor Sterling', '+1-555-0212', 'None', 'Coronary Artery Disease', '2026-03-01', TRUE);

-- 5. APPOINTMENTS
TRUNCATE TABLE `appointments`;
INSERT INTO `appointments` (`id`, `appointment_number`, `patient_id`, `doctor_id`, `department_id`, `appointment_date`, `appointment_time`, `token_number`, `reason`, `status`, `notes`) VALUES
(1, 'APT-2026-101', 1, 1, 1, CURRENT_DATE(), '10:00 AM', 1, 'Routine cardiology follow-up & chest tightness review', 'CONFIRMED', 'Patient reports occasional shortness of breath'),
(2, 'APT-2026-102', 2, 2, 2, CURRENT_DATE(), '11:30 AM', 2, 'Severe recurrent migraine and dizziness', 'BOOKED', 'First time visit'),
(3, 'APT-2026-103', 3, 1, 1, CURRENT_DATE(), '02:00 PM', 3, 'Post-angioplasty annual evaluation', 'CONFIRMED', 'Review ECG and lipid panel'),
(4, 'APT-2026-104', 1, 1, 1, DATE_SUB(CURRENT_DATE(), INTERVAL 14 DAY), '09:30 AM', 1, 'Initial cardiology consultation', 'COMPLETED', 'Prescribed antihypertensives');

-- 6. MEDICAL RECORDS
TRUNCATE TABLE `medical_records`;
INSERT INTO `medical_records` (`id`, `record_number`, `patient_id`, `doctor_id`, `appointment_id`, `visit_date`, `symptoms`, `diagnosis`, `clinical_notes`, `treatment_plan`, `vital_signs`, `follow_up_date`) VALUES
(1, 'MR-2026-001', 1, 1, 4, DATE_SUB(CURRENT_DATE(), INTERVAL 14 DAY), 'Elevated blood pressure, mild exertion fatigue', 'Stage 1 Essential Hypertension', 'Patient is overweight, reported high sodium diet and sedentary desk job. Heart sounds normal.', 'Lifestyle modification, reduce sodium intake, start Amlodipine 5mg daily.', 'BP: 142/92, HR: 76 bpm, SpO2: 98%, Temp: 98.4 F', CURRENT_DATE());

-- 7. PRESCRIPTIONS & PRESCRIPTION ITEMS
TRUNCATE TABLE `prescriptions`;
INSERT INTO `prescriptions` (`id`, `prescription_number`, `patient_id`, `doctor_id`, `appointment_id`, `prescription_date`, `diagnosis`, `instructions`, `status`) VALUES
(1, 'RX-2026-001', 1, 1, 4, DATE_SUB(CURRENT_DATE(), INTERVAL 14 DAY), 'Stage 1 Essential Hypertension', 'Take morning medication consistently after breakfast. Keep hydration adequate.', 'DISPENSED');

-- 8. MEDICINES
TRUNCATE TABLE `medicines`;
INSERT INTO `medicines` (`id`, `code`, `name`, `generic_name`, `category`, `manufacturer`, `unit_price`, `requires_prescription`, `description`, `status`) VALUES
(1, 'MED-101', 'Amlodipine 5mg', 'Amlodipine Besylate', 'Antihypertensive', 'Pfizer Pharma', 12.50, TRUE, 'Calcium channel blocker for hypertension management.', 'ACTIVE'),
(2, 'MED-102', 'Atorvastatin 20mg', 'Atorvastatin Calcium', 'Cardiovascular', 'Sun Pharma', 18.00, TRUE, 'HMG-CoA reductase inhibitor for lowering LDL cholesterol.', 'ACTIVE'),
(3, 'MED-103', 'Metformin 500mg', 'Metformin Hydrochloride', 'Antidiabetic', 'Cipla Health', 8.50, TRUE, 'First-line medication for type 2 diabetes management.', 'ACTIVE'),
(4, 'MED-104', 'Paracetamol 650mg', 'Acetaminophen', 'Analgesic / Antipyretic', 'GlaxoSmithKline', 4.00, FALSE, 'Pain relief and fever reduction tablet.', 'ACTIVE'),
(5, 'MED-105', 'Amoxicillin 500mg', 'Amoxicillin Trihydrate', 'Antibiotic', 'Novartis', 15.00, TRUE, 'Broad spectrum penicillin-class antibiotic for infections.', 'ACTIVE'),
(6, 'MED-106', 'Pantoprazole 40mg', 'Pantoprazole Sodium', 'Gastrointestinal', 'Alkem Labs', 10.00, FALSE, 'Proton pump inhibitor for acid reflux and GERD.', 'ACTIVE'),
(7, 'MED-107', 'Sumatriptan 50mg', 'Sumatriptan Succinate', 'Neurology', 'AstraZeneca', 25.00, TRUE, 'Triptan medication for acute migraine headaches.', 'ACTIVE');

-- 9. MEDICINE STOCK
TRUNCATE TABLE `medicine_stock`;
INSERT INTO `medicine_stock` (`id`, `medicine_id`, `batch_number`, `quantity`, `min_reorder_level`, `expiry_date`, `unit_cost`, `supplier`, `status`) VALUES
(1, 1, 'BATCH-AML-2026A', 250, 30, '2027-08-31', 7.50, 'MediSupply Global', 'AVAILABLE'),
(2, 2, 'BATCH-ATO-2026B', 180, 25, '2027-11-30', 11.00, 'HeartCare Logistics', 'AVAILABLE'),
(3, 3, 'BATCH-MET-2026C', 320, 40, '2028-01-31', 4.50, 'DiabeticCare Inc.', 'AVAILABLE'),
(4, 4, 'BATCH-PCM-2026D', 600, 50, '2028-06-30', 2.00, 'Apex Pharma Dist.', 'AVAILABLE'),
(5, 5, 'BATCH-AMX-2026E', 15, 25, '2026-12-31', 9.00, 'BioCare Solutions', 'LOW_STOCK'), -- Low stock demonstration
(6, 6, 'BATCH-PAN-2026F', 210, 30, '2027-09-30', 6.00, 'Apex Pharma Dist.', 'AVAILABLE'),
(7, 7, 'BATCH-SUM-2026G', 10, 15, '2026-11-15', 16.00, 'NeuroMeds Direct', 'LOW_STOCK');

-- 10. PRESCRIPTION ITEMS
TRUNCATE TABLE `prescription_items`;
INSERT INTO `prescription_items` (`id`, `prescription_id`, `medicine_id`, `dosage`, `frequency`, `duration`, `instructions`, `quantity`, `dispensed`, `dispensed_at`) VALUES
(1, 1, 1, '5mg', 'Once daily (Morning)', '30 days', 'Take after breakfast with water', 30, TRUE, DATE_SUB(CURRENT_DATE(), INTERVAL 14 DAY)),
(2, 1, 2, '20mg', 'Once daily (Night)', '30 days', 'Take at bedtime', 30, TRUE, DATE_SUB(CURRENT_DATE(), INTERVAL 14 DAY));

-- 11. LAB TESTS
TRUNCATE TABLE `lab_tests`;
INSERT INTO `lab_tests` (`id`, `test_code`, `test_name`, `category`, `description`, `price`, `normal_range`, `sample_type`, `turnaround_hours`, `status`) VALUES
(1, 'LAB-CBC', 'Complete Blood Count (CBC)', 'Hematology', 'Measures RBC, WBC, Hemoglobin, Platelets and differential indices.', 45.00, 'Hb: 13.5-17.5 g/dL, WBC: 4,500-11,000/uL', 'Whole Blood (EDTA)', 6, 'ACTIVE'),
(2, 'LAB-LIPID', 'Comprehensive Lipid Profile', 'Biochemistry', 'Measures Total Cholesterol, Triglycerides, HDL, LDL, VLDL.', 65.00, 'Total Chol: <200 mg/dL, LDL: <100 mg/dL', 'Serum (Fasting)', 12, 'ACTIVE'),
(3, 'LAB-HBA1C', 'Glycated Hemoglobin (HbA1c)', 'Biochemistry', 'Estimates 3-month average plasma glucose concentration.', 50.00, 'Normal: <5.7%, Pre-diabetic: 5.7-6.4%', 'Whole Blood (EDTA)', 8, 'ACTIVE'),
(4, 'LAB-ECG', '12-Lead Electrocardiogram', 'Cardiology', 'Records electrical activity of the heart over time.', 80.00, 'Normal Sinus Rhythm, HR 60-100 bpm', 'Electrode Placement', 2, 'ACTIVE'),
(5, 'LAB-LFT', 'Liver Function Test (LFT)', 'Biochemistry', 'Evaluates ALT, AST, Bilirubin, Albumin, and Alkaline Phosphatase.', 60.00, 'ALT: 7-56 U/L, AST: 10-40 U/L', 'Serum', 12, 'ACTIVE'),
(6, 'LAB-KFT', 'Kidney Function Test (KFT)', 'Biochemistry', 'Evaluates Serum Creatinine, Blood Urea Nitrogen, and Electrolytes.', 55.00, 'Creatinine: 0.7-1.3 mg/dL, BUN: 7-20 mg/dL', 'Serum', 8, 'ACTIVE');

-- 12. LAB REPORTS
TRUNCATE TABLE `lab_reports`;
INSERT INTO `lab_reports` (`id`, `report_number`, `patient_id`, `doctor_id`, `test_id`, `appointment_id`, `status`, `sample_collected_at`, `result_value`, `reference_range`, `remarks`, `performed_by_user_id`, `completed_at`) VALUES
(1, 'REP-2026-001', 1, 1, 2, 4, 'COMPLETED', DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 13 DAY), 'Total Chol: 218 mg/dL, LDL: 138 mg/dL, HDL: 46 mg/dL, Triglycerides: 170 mg/dL', 'Total: <200, LDL: <100, HDL: >40', 'Borderline elevated LDL and Total Cholesterol. Managed with Atorvastatin.', 5, DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 12 DAY)),
(2, 'REP-2026-002', 1, 1, 4, 1, 'SAMPLE_COLLECTED', CURRENT_TIMESTAMP(), NULL, 'Normal Sinus Rhythm', '12-lead ECG completed, awaiting technician trace validation.', 5, NULL),
(3, 'REP-2026-003', 2, 2, 1, 2, 'REQUESTED', NULL, NULL, 'Hb: 12.0-15.5 g/dL, WBC: 4,500-11,000/uL', 'Pre-consultation workup for severe recurrent headache.', NULL, NULL);

-- 13. BEDS
TRUNCATE TABLE `beds`;
INSERT INTO `beds` (`id`, `bed_number`, `ward_name`, `room_number`, `bed_type`, `daily_rate`, `status`, `notes`) VALUES
(1, 'BED-ICU-01', 'Intensive Care Unit (ICU)', 'ICU-101', 'ICU', 2500.00, 'OCCUPIED', 'Cardiac telemetry monitor active'),
(2, 'BED-ICU-02', 'Intensive Care Unit (ICU)', 'ICU-102', 'ICU', 2500.00, 'AVAILABLE', 'Cleaned & sanitized'),
(3, 'BED-GEN-01', 'General Medical Ward A', 'GEN-201', 'GENERAL', 500.00, 'AVAILABLE', 'Standard hospital bed'),
(4, 'BED-GEN-02', 'General Medical Ward A', 'GEN-202', 'GENERAL', 500.00, 'AVAILABLE', 'Standard hospital bed'),
(5, 'BED-GEN-03', 'General Medical Ward A', 'GEN-203', 'GENERAL', 500.00, 'AVAILABLE', 'Standard hospital bed'),
(6, 'BED-PVT-01', 'Private Deluxe Wing', 'PVT-301', 'PRIVATE', 1800.00, 'AVAILABLE', 'En-suite bath, TV, guest sofa'),
(7, 'BED-EMG-01', 'Emergency Triage', 'EMG-01', 'EMERGENCY', 1200.00, 'AVAILABLE', 'Crash cart adjacent'),
(8, 'BED-EMG-02', 'Emergency Triage', 'EMG-02', 'EMERGENCY', 1200.00, 'MAINTENANCE', 'Hydraulic lift inspection');

-- 14. ADMISSIONS
TRUNCATE TABLE `admissions`;
INSERT INTO `admissions` (`id`, `admission_number`, `patient_id`, `bed_id`, `doctor_id`, `admission_date`, `discharge_date`, `admission_reason`, `discharge_summary`, `status`) VALUES
(1, 'ADM-2026-001', 3, 1, 1, DATE_SUB(CURRENT_TIMESTAMP(), INTERVAL 2 DAY), NULL, 'Acute coronary syndrome observation and post-catheterization monitoring.', NULL, 'ADMITTED');

-- 15. BILLS & BILL ITEMS
TRUNCATE TABLE `bills`;
INSERT INTO `bills` (`id`, `bill_number`, `patient_id`, `appointment_id`, `admission_id`, `subtotal`, `tax_amount`, `discount_amount`, `total_amount`, `paid_amount`, `payment_status`, `payment_method`, `billing_date`, `due_date`, `notes`) VALUES
(1, 'INV-2026-001', 1, 4, NULL, 215.00, 10.75, 0.00, 225.75, 225.75, 'PAID', 'CARD', DATE_SUB(CURRENT_DATE(), INTERVAL 14 DAY), DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY), 'Consultation and Lipid Profile test bill. Settled in full.'),
(2, 'INV-2026-002', 1, 1, NULL, 230.00, 11.50, 0.00, 241.50, 0.00, 'PENDING', NULL, CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 7 DAY), 'Follow-up consultation fee and ECG test order.'),
(3, 'INV-2026-003', 2, 2, NULL, 225.00, 11.25, 0.00, 236.25, 100.00, 'PARTIAL', 'UPI', CURRENT_DATE(), DATE_ADD(CURRENT_DATE(), INTERVAL 5 DAY), 'Neurology initial consultation & CBC order.');

TRUNCATE TABLE `bill_items`;
INSERT INTO `bill_items` (`id`, `bill_id`, `item_category`, `item_name`, `quantity`, `unit_price`, `total_price`) VALUES
(1, 1, 'Consultation', 'Dr. Sarah Jenkins - Cardiology Consultation', 1, 150.00, 150.00),
(2, 1, 'Laboratory', 'Comprehensive Lipid Profile', 1, 65.00, 65.00),
(3, 2, 'Consultation', 'Dr. Sarah Jenkins - Follow-up Consultation', 1, 150.00, 150.00),
(4, 2, 'Laboratory', '12-Lead Electrocardiogram', 1, 80.00, 80.00),
(5, 3, 'Consultation', 'Dr. Robert Chen - Neurology Consultation', 1, 180.00, 180.00),
(6, 3, 'Laboratory', 'Complete Blood Count (CBC)', 1, 45.00, 45.00);

-- 16. NOTIFICATIONS
TRUNCATE TABLE `notifications`;
INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`) VALUES
(1, 7, 'Appointment Confirmed', 'Your appointment with Dr. Sarah Jenkins is scheduled for today at 10:00 AM.', 'APPOINTMENT', FALSE),
(2, 2, 'New Lab Result Ready', 'Lipid profile results for John Doe (PAT-2026-001) are now ready for review.', 'ALERT', FALSE),
(3, 6, 'Low Stock Alert', 'Amoxicillin 500mg has fallen below minimum reorder level (15 remaining).', 'ALERT', FALSE),
(4, 1, 'New Admission', 'William Sterling has been admitted to ICU Bed-01 under Dr. Sarah Jenkins.', 'INFO', FALSE);

SET FOREIGN_KEY_CHECKS = 1;
