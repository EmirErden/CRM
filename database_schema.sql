CREATE TYPE opportunity_status AS ENUM (
    'Qualification',
    'Proposal/Price Quote',
    'Negotiation/Review',
    'Closed Won',
    'Closed Lost'
    );

CREATE TYPE lead_status AS ENUM (
    'New',
    'Contacted',
    'Working',
    'Unqualified',
    'Converted'
    );

CREATE TYPE task_priority AS ENUM (
    'Low',
    'Medium',
    'High'
    );

CREATE TYPE task_status AS ENUM (
    'Not Started',
    'In Progress',
    'Completed',
    'On Hold',
    'Canceled',
    'Failed'
    );

CREATE TYPE ticket_status AS ENUM (
    'Open',
    'In Progress',
    'Closed'
    );

CREATE TYPE employee_status AS ENUM (
    'Active',
    'Inactive'
    );

CREATE TYPE user_roles AS ENUM (
    'Admin',
    'Manager',
    'User'
    );

CREATE TABLE Accounts -- Müşteriler ve şirketlerin bilgilerini içeren tablo
(
    account_id SERIAL PRIMARY KEY, -- Hesaba özel Id
    is_company BOOLEAN,
    account_type VARCHAR(20) NOT NULL, -- Müşteri Türü
    company_type VARCHAR(30),
    contact_name VARCHAR(30),
    relation VARCHAR(50),
    name VARCHAR(100) NOT NULL, -- İsim veya Şirket Adı
    email VARCHAR(50) NOT NULL, -- E-mail
    phone VARCHAR(15) NOT NULL, -- Telefon Numarası
    address VARCHAR(255) NOT NULL, -- Adres
    billing_address VARCHAR(255),
    city VARCHAR(50) NOT NULL, -- Şehir
    country VARCHAR(50) NOT NULL, -- Ülke
    date_of_birth DATE, -- Doğum tarihi (kişiler için geçerli)
    gender VARCHAR(20), -- Cinsiyet (kişiler için geçerli)
    martial_status BOOLEAN DEFAULT FALSE, -- Medeni durum (kişiler için geçerli)
    have_kids BOOLEAN DEFAULT FALSE, -- Çocuk sahibi olma durumu (kişiler için geçerli)
    industry VARCHAR(50), -- Şirketin endüstrisi (şirketler için geçerli)
    website VARCHAR(50), -- Web sitesi (şirketler için geçerli)
    linkedin_url VARCHAR(50), -- LinkedIn URL (şirketler için geçerli)
    instagram_url VARCHAR(50), -- Instagram URL (şirketler için geçerli)
    facebook_url VARCHAR(50), -- Facebook URL (şirketler için geçerli)
    twitter_url VARCHAR(50),
    no_of_employees INT, -- Çalışan sayısı (şirketler için geçerli)
    owner_id INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Potansiyel müşteri olduğu tarih
    created_by VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE SupportTickets --Kullanıcıların destek biletlerinin tutulduğu yer
(
    ticket_id SERIAL PRIMARY KEY, --Biletlere özel Id
    account_id INT, --Bileti yapan Müşterinin Id'si. Burası foreign key olacak.
    priority VARCHAR(20) NOT NULL, --Biletin öncelik düzeyi
    status ticket_status DEFAULT 'Open', --Biletin durumu
    issue_type VARCHAR(30),
    case_origin VARCHAR(20) NOT NULL,
    issue_title TEXT NOT NULL,
    issue_description TEXT NOT NULL, --Bilette anlatılan sorun
    solution_description TEXT, --Eğer çözüldüyse sorunun çözümü
    solution_date TIMESTAMP, --Eğer çözüldüyse çözülme zamanı
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Potansiyel müşteri olduğu tarih
    created_by VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY, -- Benzersiz çalışan ID'si
    first_name VARCHAR(50) NOT NULL,            -- Ad
    last_name VARCHAR(50) NOT NULL,             -- Soyad
    department VARCHAR(50),                    -- Departman
    job_title VARCHAR(50),                      -- Görev unvanı
    email VARCHAR(100) UNIQUE,                 -- İş e-postası
    status employee_status DEFAULT 'Active' -- Çalışan durumu
);

CREATE TABLE CRMUsers (
    crm_user_id SERIAL PRIMARY KEY, -- Benzersiz CRM kullanıcı ID'si
    employee_id INT UNIQUE,                    -- Çalışanla ilişki
    username VARCHAR(50) UNIQUE NOT NULL,     -- CRM kullanıcı adı
    password_hash VARCHAR(60) NOT NULL,       -- Şifre (hashlenmiş)
    role user_roles NOT NULL, -- CRM rolü
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) -- Çalışan ilişkisi
);

CREATE TABLE Interactions --Müşteriler ile olan etkileşimlerin bulunduğu masa
(
    interaction_id BIGSERIAL PRIMARY KEY, --Etkileşime özel Id
    interacted_by INT NOT NULL,
    account_id INT, --Müşterilerin Id'si. Burası Foreign Key olacak.
    support_ticket_id INT,
    interaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Etkileşimin yapıldığı zaman
    interaction_type VARCHAR(50), --Etkileşimin çeşidi(servis, bug vb.)
    interaction_channel VARCHAR(50), --Etkileşimin hangi metodla yapıldığı yazılır
    notes TEXT NOT NULL, --Etkileşimden alınabilecek notlar.
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (support_ticket_id) REFERENCES SupportTickets(ticket_id),
    FOREIGN KEY (interacted_by) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE Opportunities
(
    opportunity_id SERIAL PRIMARY KEY,
    opportunity_name VARCHAR(50) NOT NULL,
    account_name VARCHAR(50) NOT NULL,
    owner_id INT NOT NULL,
    amount INT,
    close_date DATE,
    status opportunity_status DEFAULT 'Qualification',
    probability INT CHECK ( probability <= 100 ),
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE Leads --Potansiyel müşterilerin bilgilerinin bulunduğu tablo
(
    lead_id SERIAL PRIMARY KEY, --Potansiyel müşteriye özel Id
    name VARCHAR(50) NOT NULL, --İsmi
    email VARCHAR(50) NOT NULL, --E-mail'i
    phone VARCHAR(15) NOT NULL, --Telefon Numarası
    city VARCHAR(50) NOT NULL,
    address VARCHAR(255),
    website VARCHAR(50),
    leadStatus lead_status DEFAULT 'New',
    source VARCHAR(50) NOT NULL, --Potansiyel müşterinin bulunduğu kaynak
    notes TEXT,
    owner_id INT NOT NULL,
    follow_up BOOLEAN DEFAULT FALSE,
    annual_revenue INT,
    no_of_employees INT,
    industry VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Potansiyel müşteri olduğu tarih
    created_by VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE Products --Ürünlerin bulunduğu tablo
(
    product_id SERIAL PRIMARY KEY, --Ürünün kendine özel Id'si
    product_name VARCHAR(100) NOT NULL, --İsmi
    description TEXT NOT NULL, --Ürün açıklaması
    category VARCHAR(50) NOT NULL, --Kategorisi
    price DECIMAL(10,2) NOT NULL, -- Fiyatı
    stockQuantity INT --Stockta kalan miktarı
);

CREATE TABLE Orders --Siparişlerin bulunduğu tablo
(
    order_id SERIAL PRIMARY KEY, --Siparişe özel Id
    account_id INT NOT NULL, --Sipariş yapan müşterinin Id'si. Burası customer tablosunun customer_id alanına foreign key olacak
    quantity INT NOT NULL,
    product_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Sipariş tarihi
    total_amount DECIMAL(10,2) NOT NULL, --Sipariş miktarı
    status VARCHAR(50) NOT NULL, --Sipariş durumu
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


CREATE TABLE Tasks
(
    task_id SERIAL PRIMARY KEY,
    subject TEXT NOT NULL,
    assigned_to INT NOT NULL,
    is_external BOOLEAN,
    related_external_id INT,
    related_internal_id INT,
    comments TEXT NOT NULL,
    priority task_priority DEFAULT 'Medium',
    status task_status DEFAULT 'Not Started',
    due_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Potansiyel müşteri olduğu tarih
    created_by VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR(50) NOT NULL,
    FOREIGN KEY (assigned_to) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (related_external_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (related_internal_id) REFERENCES Employees(employee_id)
);

CREATE TABLE Feedbacks --Müşterilerin(şirketlerin ve insanların) geri dönüşlerinin tutulduğu tablo
(
    feedback_id SERIAL PRIMARY KEY, --Feedback'e özel Id
    account_id INT, --Bileti yapan Müşterinin Id'si. Burası foreign key olacak.
    feedback_type VARCHAR(50) NOT NULL, --Şirketimizin hangi kısmına geri dönüş yapıyor (Servis, hizmet vb.)
    rating INT NOT NULL, --1 ile 5 arasında puan
    comment TEXT, --Yapmak isterse yorum sekmesi
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Geri dönüşün yapıldığı zaman
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);




