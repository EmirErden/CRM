--Test datası ekleme queryleri

INSERT INTO employees(name) Values('Emir Erden');
INSERT INTO employees(name) Values('Ergin Sefer');

INSERT INTO crmusers(username, password_hash, role, employee_id) VALUES ('emirerden', '12345', 'User', 1);
INSERT INTO crmusers(username, password_hash, role, employee_id) VALUES ('erginsefer', '12345', 'Admin', 2);

INSERT INTO Accounts (is_company, company_type, name, email, phone, address, billing_address, city, country, industry, website, linkedin_url, instagram_url, facebook_url, twitter_url, no_of_employees, owner_id, description, created_by, modified_by)
VALUES (TRUE, 'Ltd. Şti.', 'Örnek Şirket', 'info@orneksirket.com', '+901234567890', 'Örnek Sokak No:1, İzmir', 'Örnek Fatura Adresi No:1, İzmir', 'İzmir', 'Türkiye', 'Teknoloji', 'www.orneksirket.com', 'https://linkedin.com/company/orneksirket', 'https://instagram.com/orneksirket', 'https://facebook.com/orneksirket', 'https://twitter.com/orneksirket', 50, 1, 'Örnek Şirket açıklaması', 1, 1);
INSERT INTO Accounts (is_company, company_type, name, email, phone, address, billing_address, city, country, industry, website, linkedin_url, instagram_url, facebook_url, twitter_url, no_of_employees, owner_id, description, created_by, modified_by)
VALUES (TRUE, 'A.Ş.', 'Başka Örnek Şirket', 'contact@baskaorneksirket.com', '+909876543210', 'Başka Sokak No:2, İstanbul', 'Başka Fatura Adresi No:2, İstanbul', 'İstanbul', 'Türkiye', 'Finans', 'www.baskaorneksirket.com', 'https://linkedin.com/company/baskaorneksirket', 'https://instagram.com/baskaorneksirket', 'https://facebook.com/baskaorneksirket', 'https://twitter.com/baskaorneksirket', 200, 2, '2. Örnek Şirket açıklaması', 2, 2);

INSERT INTO Accounts (is_company, name, email, phone, address, billing_address, city, country, date_of_birth, gender, marital_status, have_kids, owner_id, description, created_by, modified_by)
VALUES (FALSE, 'John Doe', 'john.doe@example.com', '+905555555555', 'Müşteri Sokak No:3, Ankara', 'Müşteri Fatura Adresi No:3, Ankara', 'Ankara', 'Türkiye', '1980-01-01', 'Erkek', TRUE, TRUE, 2, 'John Doe hakkında açıklama', 2, 2);



