--Müşteriler sayfasındaki tablo için
SELECT accounts.name, accounts.phone, accounts.email, relation, industry, employees.name AS owner FROM accounts JOIN crmusers ON owner_id = crmusers.crm_user_id JOIN employees ON crmusers.employee_id = employees.employee_id;

--Veri tabanına yeni bir rmüşteri ekleme sorgusu
INSERT INTO Accounts (
    is_company, company_type, parent_company_id, name, email, phone, address, billing_address, city, country, industry,
    website, linkedin_url, instagram_url, facebook_url, twitter_url, no_of_employees, owner_id,
    description, created_by, modified_by
)
VALUES (
           TRUE, 'A.Ş.', 1,  'Yeni Örnek Şirket', 'contact@yeniorneksirket.com', '+905555555555', 'Yeni Sokak No:2, Bursa',
           'Yeni Fatura Adresi No:2, Bursa', 'Bursa', 'Türkiye', 'İnşaat', 'www.yeniorneksirket.com',
           'https://linkedin.com/company/yeniorneksirket', 'https://instagram.com/yeniorneksirket',
           'https://facebook.com/yeniorneksirket', 'https://twitter.com/yeniorneksirket', 75, 2,
           'Yeni Örnek Şirket açıklaması', 2, 2
       );

--Müşteri bilgilerini almak için sorgu
SELECT accounts.name, accounts.phone, parent_company.name, accounts.website, accounts.company_type, accounts.industry, accounts.no_of_employees, accounts.annual_revenue, accounts.linkedin_url, accounts.billing_address, accounts.address, accounts.description, accounts.created_by, accounts.created_at, accounts.modified_by, accounts.last_modified FROM accounts JOIN accounts AS parent_company ON accounts.parent_company_id = parent_company.account_id;

--Müşterinin geçmiş etkileşimleri hakkında bilgi almak için bir tablo
SELECT interactions.interaction_title, interactions.interaction_date FROM interactions WHERE account_id = 1

--Müşteri ile olan gelecekteki görevleri gösteren sorgu
SELECT tasks.subject FROM tasks