--Potansiyel müşteriler sayfasındaki tablo için
SELECT leads.name, leads.lead_status, leads.source, leads.phone, leads.email, employees.name AS Owner FROM leads JOIN crmusers ON leads.owner_id = crmusers.crm_user_id JOIN employees ON crmusers.employee_id = employees.employee_id;

--Potansiyel Müşterinin bilgilerini göstermek için sorgu
SELECT leads.name, leads.phone, leads.parent_company, employees.name, leads.website, leads.company_type, leads.industry, leads.no_of_employees, leads.annual_revenue, leads.source, leads.linkedin_url, leads.address, leads.billing_address, leads.description, leads.created_by, leads.created_at, leads.modified_by, leads.last_modified FROM leads JOIN crmusers ON leads.owner_id = crmusers.crm_user_id JOIN employees ON crmusers.employee_id = employees.employee_id;;

--Potansiyel Müşterininin etkileşimlerini almak için query
SELECT interactions.interaction_title, interactions.interaction_date FROM interactions WHERE lead_id = 1;

--Potansiyel müşterinin gelecekteki görevlerini almak için query
SELECT subject, created_at FROM tasks