--Şirketlerle bağlantılı olan kişilerin gösterildiği tablonun verilerini getirildiği sorgu
SELECT contacts.name, accounts.name, contacts.position, contacts.phone, contacts.email, employees.name FROM  contacts JOIN accounts ON contacts.account_id = accounts.account_id JOIN crmusers ON crmusers.crm_user_id = contacts.owner_id JOIN employees ON employees.employee_id = crmusers.crm_user_id;

--Contact'in etkileşimlerini almak için query
SELECT accounts.name, position, interacted_by, interaction_date, interaction_type, interaction_channel, notes FROM interactions JOIN accounts ON interactions.account_id = accounts.account_id JOIN contacts ON accounts.account_id = contacts.account_id WHERE contacts.contact_id = 1;

--Kişilerin bütün bilgilerinin gözüktüğü sayfanın sorgusu
SELECT contacts.name, accounts.name, contacts.position, employees.name, contacts.email, contacts.phone, contacts.address, contacts.created_by, contacts.created_at, contacts.modified_by, contacts.last_modified FROM contacts JOIN accounts ON contacts.account_id = accounts.account_id JOIN crmusers ON crmusers.crm_user_id = contacts.owner_id JOIN employees ON employees.employee_id = crmusers.crm_user_id;