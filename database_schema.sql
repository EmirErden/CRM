CREATE TABLE Accounts -- Müşteriler ve şirketlerin bilgilerini içeren tablo
(
    account_id SERIAL PRIMARY KEY, -- Hesaba özel Id
    is_company BOOLEAN,
    account_type VARCHAR(20) NOT NULL, -- Müşteri Türü
    company_type VARCHAR(30),
    contact_name VARCHAR(30),
    name VARCHAR(100) NOT NULL, -- İsim veya Şirket Adı
    email VARCHAR(50) NOT NULL, -- E-mail
    phone VARCHAR(15) NOT NULL, -- Telefon Numarası
    address VARCHAR(255) NOT NULL, -- Adres
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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Potansiyel müşteri olduğu tarih
    created_by VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR(50) NOT NULL
);


CREATE TABLE Interactions --Müşteriler ile olan etkileşimlerin bulunduğu masa
(
    interaction_id BIGSERIAL PRIMARY KEY, --Etkileşime özel Id
    account_id INT, --Müşterilerin Id'si. Burası Foreign Key olacak.
    interaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Etkileşimin yapıldığı zaman
    interaction_type VARCHAR(50), --Etkileşimin çeşidi(servis, bug vb.)
    interaction_channel VARCHAR(50), --Etkileşimin hangi metodla yapıldığı yazılır
    notes TEXT NOT NULL, --Etkileşimden alınabilecek notlar.
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Opportunities
(
    opportunity_id SERIAL PRIMARY KEY,
    opportunity_name VARCHAR(50) NOT NULL,
    account_name VARCHAR(50) NOT NULL,
    owner_full_name VARCHAR(50) NOT NULL,
    amount INT,
    close_date DATE,
    status VARCHAR(20) DEFAULT 'Qualification',
    probability INT CHECK ( probability <= 100 )
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
    leadStatus VARCHAR(20) DEFAULT 'New',
    source VARCHAR(50) NOT NULL, --Potansiyel müşterinin bulunduğu kaynak
    notes TEXT,
    owner VARCHAR(50),
    follow_up BOOLEAN DEFAULT FALSE,
    annual_revenue INT,
    no_of_employees INT,
    industry VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Potansiyel müşteri olduğu tarih
    created_by VARCHAR(50) NOT NULL,
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR(50) NOT NULL
);

CREATE TABLE Products --Ürünlerin bulunduğu tablo
(
    product_id SERIAL PRIMARY KEY, --Ürünün kendine özel Id'si
    product_name VARCHAR(100) NOT NULL, --İsmi
    description TEXT NOT NULL, --Ürün açıklaması
    category VARCHAR(50) NOT NULL, --Kategorisi
    price DECIMAL(10,2) NOT NULL, -- Fiyatı
    stockQuantity INT NOT NULL --Stockta kalan miktarı
);

CREATE TABLE Orders --Siparişlerin bulunduğu tablo
(
    order_id SERIAL PRIMARY KEY, --Siparişe özel Id
    account_id INT NOT NULL, --Sipariş yapan müşterinin Id'si. Burası customer tablosunun customer_id alanına foreign key olacak
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Sipariş tarihi
    total_amount DECIMAL(10,2) NOT NULL, --Sipariş miktarı
    status VARCHAR(50) NOT NULL, --Sipariş durumu
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE OrderDetails --Siparişlerin daha detaylı bilgilernin olduğu tablo
(
    order_detail_id SERIAL PRIMARY KEY, --Sipariş detayına özel ID
    order_id INT NOT NULL, --Burası Orders tablosundaki order_id'nin foreign key'i olacak
    product_id INT NOT NULL, --Burası Products tablosundaki product_id'nin foreign key'i olacak
    quantity INT NOT NULL, --siparişin miktarı
    unit_price DECIMAL(10, 2) NOT NULL, --siparişteki öğelerin tane fiyatı
    total_price DECIMAL(10,2) NOT NULL --siparişin toplam fiyatı
);

--OrderDetails tablosuna order_id foreign key'ini ekleme sorgusu
ALTER TABLE OrderDetails ADD CONSTRAINT fk_order_id FOREIGN KEY (order_id) REFERENCES Orders(order_id);

--OrderDetails tablosuna product_id foreign key'ini ekleme sorgusu
ALTER TABLE OrderDetails ADD CONSTRAINT fk_product_id FOREIGN KEY (product_id) REFERENCES Products(product_id);

CREATE TABLE Users --Kullanıcıların bulunduğu tablo
(
    user_id SERIAL PRIMARY KEY, --Kullanıcıya özel Id
    email VARCHAR(50) NOT NULL, --Email
    hashed_password CHAR(60) NOT NULL, --Kullanıcının şifrelenmiş şifresi
    role VARCHAR(30) NOT NULL, --Kullanıcının şirketteki rolü
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP --Kullanıcının yaratıldığı zaman
);

CREATE TABLE SupportTickets --Kullanıcıların destek biletlerinin tutulduğu yer
(
    ticket_id SERIAL PRIMARY KEY, --Biletlere özel Id
    account_id INT, --Bileti yapan Müşterinin Id'si. Burası foreign key olacak.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Biletin yapılma zamanı
    priority VARCHAR(20) NOT NULL, --Biletin öncelik düzeyi
    status VARCHAR(20) NOT NULL DEFAULT 'Open', --Biletin durumu
    issue_description TEXT NOT NULL, --Bilette anlatılan sorun
    solution_description TEXT, --Eğer çözüldüyse sorunun çözümü
    solution_date TIMESTAMP, --Eğer çözüldüyse çözülme zamanı
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);


CREATE TABLE Feedbacks --Müşterilerin(şirketlerin ve insanların) geri dönüşlerinin tutulduğu tablo
(
    feedback_id SERIAL PRIMARY KEY, --Feedback'e özel Id
    account_id INT, --Bileti yapan Müşterinin Id'si. Burası foreign key olacak.
    feedback_type VARCHAR(50) NOT NULL, --Şirketimizin hangi kısmına geri dönüş yapıyor (Servis, hizmet vb.)
    rating INT NOT NULL, --1 ile 5 arasında puan
    comment TEXT, --Yapmal isterse yorum sekmesi
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Geri dönüşün yapıldığı zaman
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);




