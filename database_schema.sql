
CREATE TABLE CustomerPeople -- Müşterilerin bilgilerinin bulunduğu tablo
(
    customer_id SERIAL PRIMARY KEY, --Müşteriye özel Id'si
    name VARCHAR(50) NOT NULL, --İsmi
    email VARCHAR(50) NOT NULL, --E-mail'i
    phone VARCHAR(15) NOT NULL, --Telefon Numarası
    address VARCHAR(255) NOT NULL, --Adresi
    city VARCHAR(50) NOT NULL, --Şehri
    country VARCHAR(50) NOT NULL, --Ülkesi
    date_of_birth DATE NOT NULL, --Doğum tarihi
    gender VARCHAR(20) NOT NULL, --Cinsiyeti
    martial_status BOOLEAN DEFAULT FALSE,
    have_kids BOOLEAN DEFAULT FALSE,
    registration_date DATE DEFAULT CURRENT_DATE --Kayıt olma tarihi
);

CREATE TABLE CustomerCompanies --Şirket ile anlaşan diğer şirketlerin bilgilerinin olduğu tablo
(
    company_id SERIAL PRIMARY KEY,      --Company'e özel ID
    company_name VARCHAR(100) NOT NULL, --İsmi
    industry VARCHAR(50) NOT NULL,      --Şirketin Endüstrisi
    website VARCHAR(50) NOT NULL,       --Websitesi
    email VARCHAR(50) NOT NULL ,        --E-mail adresi
    phone VARCHAR(15) NOT NULL,         --Telefon Numarası
    address VARCHAR(255) NOT NULL,      --Adresi
    city VARCHAR(50) NOT NULL,          --Bulunduğu il
    country VARCHAR(50) NOT NULL,       --Bulunduğu ülke
    linkedin_url VARCHAR(50),
    instagram_url VARCHAR(50),
    facebook_url VARCHAR(50),
    no_of_employees INT,
    registration_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Interactions --Müşteriler ile olan etkileşimlerin bulunduğu masa
(
    interaction_id BIGSERIAL PRIMARY KEY, --Etkileşime özel Id
    customer_id INT, --Müşteri ile etkileşime geçildiyse müsterinin Id'si yazılır. Burada Foreign Key kısıtlaması vardır.
    company_id INT, --Şirket ile etkileşime geçildiyse şirketin Id'si yazılır. Burada Foreign Key kısıtlaması vardır.
    interaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Etkileşimin yapıldığı zaman
    interaction_type VARCHAR(50), --Etkileşimin çeşidi(servis, bug vb.)
    interaction_channel VARCHAR(50), --Etkileşimin hangi metodla yapıldığı yazılır
    notes TEXT NOT NULL, --Etkileşimden alınabilecek notlar.
    FOREIGN KEY (customer_id) REFERENCES CustomerPeople(customer_id),
    FOREIGN KEY (company_id) REFERENCES CustomerCompanies (company_id)
);

CREATE TABLE Opportunities
(

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
    customer_id INT NOT NULL, --Sipariş yapan müşterinin Id'si. Burası customer tablosunun customer_id alanına foreign key olacak
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Sipariş tarihi
    total_amount DECIMAL(10,2) NOT NULL, --Sipariş miktarı
    status VARCHAR(50) NOT NULL --Sipariş durumu
);

--Orders tablosuna customer_id Foreign Key'inin ekleme sorgusu
ALTER TABLE Orders ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES CustomerPeople(customer_id);

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
    customer_id INT, --Bileti customer yaptıysa customer_id'si olacak
    company_id INT, --Bileti şirket yaptıysa company_id olacak
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Biletin yapılma zamanı
    priority VARCHAR(20) NOT NULL, --Biletin öncelik düzeyi
    status VARCHAR(20) NOT NULL DEFAULT 'Open', --Biletin durumu
    issue_description TEXT NOT NULL, --Bilette anlatılan sorun
    solution_description TEXT, --Eğer çözüldüyse sorunun çözümü
    solution_date TIMESTAMP --Eğer çözüldüyse çözülme zamanı
);

--SupportTicket tablosuna customer_id foreign Key'ini ekleme sorgusu
ALTER TABLE SupportTickets ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES CustomerPeople(customer_id);

--SupportTicket tablosuna company_id Foreign Key'ini ekleme sorgusu
ALTER TABLE SupportTickets ADD CONSTRAINT fk_company_id FOREIGN KEY (company_id) REFERENCES CustomerCompanies (company_id);

CREATE TABLE Feedbacks --Müşterilerin(şirketlerin ve insanların) geri dönüşlerinin tutulduğu tablo
(
    feedback_id SERIAL PRIMARY KEY, --Feedback'e özel Id
    customer_id INT, --Geri dönüşü müşteri yaptıysa customer_id doldurulacak (burası foreign key olacak)
    company_id INT, --Geri dönüşü şirket yaptıysa company_id doldurulacak (burası foreign key olacak)
    feedback_type VARCHAR(50) NOT NULL, --Şirketimizin hangi kısmına geri dönüş yapıyor (Servis, hizmet vb.)
    rating INT NOT NULL, --1 ile 5 arasında puan
    comment TEXT, --Yapmal isterse yorum sekmesi
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP --Geri dönüşün yapıldığı zaman
);

--Feedbacks tablosuna customer_id foreign key'ini ekleme sorgusu
ALTER TABLE Feedbacks ADD CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES CustomerPeople(customer_id);

--Feedbacks tablosuna company_id Foreign Key'ini ekleme sorgusu
ALTER TABLE Feedbacks ADD CONSTRAINT fk_company_id FOREIGN KEY (company_id) REFERENCES CustomerCompanies (company_id);




