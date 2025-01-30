CREATE TABLE Tenant --Bu tablo database'de tenant
(
    tenant_id SERIAL PRIMARY KEY,
    tenant_name VARCHAR(50),
    created_at DATE DEFAULT NOW()
);

-- ENUM türleri yerine kullanılacak state tabloları
CREATE TABLE OpportunityStatus (
    id SERIAL PRIMARY KEY,
    status VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE LeadStatus (
    id SERIAL PRIMARY KEY,
    status VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE TaskPriority (
    id SERIAL PRIMARY KEY,
    priority VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE TaskStatus (
    id SERIAL PRIMARY KEY,
    status VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE TicketStatus (
    id SERIAL PRIMARY KEY,
    status VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE TicketPriority (
    id SERIAL PRIMARY KEY,
    priority VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE EmployeeStatus (
    id SERIAL PRIMARY KEY,
    status VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE UserRoles (
    id SERIAL PRIMARY KEY,
    role VARCHAR(50) UNIQUE NOT NULL
);

-- ENUM verilerini state tablolarına ekleme
INSERT INTO OpportunityStatus (status)
VALUES ('Qualification'), ('Proposal/Price Quote'), ('Negotiation/Review'), ('Closed Won'), ('Closed Lost');

INSERT INTO LeadStatus (status)
VALUES ('New'), ('Contacted'), ('Working'), ('Unqualified'), ('Converted');

INSERT INTO TaskPriority (priority) VALUES ('Low'), ('Medium'), ('High');

INSERT INTO TaskStatus (status)
VALUES ('Not Started'), ('In Progress'), ('Completed'), ('On Hold'), ('Canceled'), ('Failed');

INSERT INTO TicketStatus (status) VALUES ('Open'), ('In Progress'), ('Closed');

INSERT INTO TicketPriority (priority) VALUES ('Low'), ('Medium'), ('High'), ('Critical');

INSERT INTO EmployeeStatus (status) VALUES ('Active'), ('Inactive');

INSERT INTO UserRoles (role) VALUES ('Admin'), ('Manager'), ('User');

CREATE TABLE Employee --Şirketemizde olan bütün çalışanları kapsar CRM kullananları ve kullanmayanları
(
    employee_id SERIAL PRIMARY KEY, -- Benzersiz çalışan ID'si
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),                    -- Departman
    job_title VARCHAR(50),                    -- Görev unvanı
    email VARCHAR(100) UNIQUE,                 -- İş e-postası
    phone VARCHAR(15),
    address TEXT,
    is_crm_user BOOLEAN DEFAULT FALSE,
    status_id INT DEFAULT 1,  -- Varsayılan 'Active'
    role_id INT NOT NULL, -- CRM uygulamasındaki rolü(Admin, geliştirici, vb.)
    status INT DEFAULT '1', -- Çalışan durumu
    username VARCHAR(50) UNIQUE NOT NULL,     -- CRM kullanıcı adı
    password_hash VARCHAR(60) NOT NULL,       -- Şifre (hashlenmiş)
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (status_id) REFERENCES EmployeeStatus(id) ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES UserRoles(id) ON UPDATE CASCADE
);

CREATE TABLE Contact --Şirket müşterilerimiz ile bağlantımız olan insanların bilgilerinin bulunduğu tablo
(
    contact_id SERIAL PRIMARY KEY, --Bağlantıya özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    customer_id INT NOT NULL, --Bağlantının şirketinin Id'si
    name VARCHAR(100) NOT NULL, -- Bğlantının ismi
    phone VARCHAR(15), --Bağlantının telefon numarası
    email VARCHAR(50), --Bağlantının email adresi
    address TEXT, --Bağlantının adresi
    position VARCHAR(50), --Bağlantının şirketteki pozisyonu
    owner_id INT, --Bağlantı ile sorumlu olan CRM kullanıcısının Id'si
    created_by INT NOT NULL, --Bileti yaratan hesabın ID'si
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Biletin yaratıldığı zaman
    modified_by INT NOT NULL, --Bilet hakkında en son işlem yapan kullanıcının ID'si
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Bilet hakkında en son değişiklik yapılan tarih
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Customer
(
    customer_id SERIAL PRIMARY KEY, -- Hesaba özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesini sağlayan satır
    is_lead BOOLEAN DEFAULT FALSE,
    is_company BOOLEAN DEFAULT FALSE,  --Bu müşterinin şirket olup olmadığını anlamamızı sağlayan boolean
    relation VARCHAR(50), -- Hesabın bizimle ilşkisini anlatan değişken (Partner, Müşteri vb.)
    parent_company_id INT, --Eğer bu şirketin üst şirketi varsa bizim veritabanındaki üst şirketin Id'si yazılır
    company_type VARCHAR(30), -- Eğer müşteri şirketse onun ne tip şirket olduğunu açıklıyor (a.ş. ltd şti vb.)
    industry VARCHAR(50), -- Şirketin endüstrisi (şirketler için geçerli)
    name VARCHAR(100) NOT NULL, -- İsim veya Şirket Adı
    email VARCHAR(50) NOT NULL, -- E-mail
    phone VARCHAR(15) NOT NULL, -- Telefon Numarası
    city VARCHAR(50) NOT NULL, -- Şehir
    country VARCHAR(50) NOT NULL, -- Ülke
    address VARCHAR(255) NOT NULL, -- Adres
    billing_address VARCHAR(255), -- Faturada yazılan adres
    website VARCHAR(50), -- Web sitesi (şirketler için geçerli)
    source VARCHAR(50) NOT NULL, --Potansiyel müşterinin bulunduğu kaynak
    lead_status_id INT DEFAULT 1, -- Varsayılan 'New'
    description TEXT, -- Hesap hakkında açıklama yapılması gerekiliyorsa doldurulur
    linkedin_url VARCHAR(50), -- Hesabın (varsa) linkedin hesabının linki
    instagram_url VARCHAR(50), -- Hesabın (varsa) instagram hesabının linki
    facebook_url VARCHAR(50), -- Hesabın (varsa) facebook hesabının linki
    twitter_url VARCHAR(50), -- Hesabın (varsa) twitter hesabının linki
    no_of_employees INT, -- Çalışan sayısı (şirketler için geçerli)
    annual_revenue INT, --Account'ın yıllık geliri
    date_of_birth DATE, -- Doğum tarihi (müşteriler için geçerli)
    gender VARCHAR(20), -- Cinsiyet (kişiler için geçerli)
    marital_status BOOLEAN DEFAULT FALSE, -- Medeni durum (kişiler için geçerli)
    have_kids BOOLEAN DEFAULT FALSE, -- Çocuk sahibi olma durumu (kişiler için geçerli)
    follow_up BOOLEAN DEFAULT FALSE, --Potansiyel müşteriye geri dönüş yapılmasının gerekip gerekmediğini gösteren bir değişken
    owner_id INT NOT NULL, -- Bu hesabı hesap yapan CRM kullanıcısının ID'si
    created_by INT NOT NULL, -- Hesabın yapan CRM Kullanıcısının
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesabın yaratıldığı tarih
    modified_by INT NOT NULL, -- Hesapta en son değişiklik yapan CRM kullanıcısı
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesap hakkında en son değişiklik yapıldığı tarih
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (parent_company_id) REFERENCES Customer (customer_id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (owner_id) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (created_by) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (modified_by) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE SupportTicket --Kullanıcıların destek biletlerinin tutulduğu yer
(
    ticket_id SERIAL PRIMARY KEY, --Biletlere özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    customer_id INT, --Bileti yapan Hesabın Id'si. Burası foreign key olacak.
    priority_id INT DEFAULT 1, -- Varsayılan 'Low'
    status_id INT DEFAULT 1, -- Varsayılan 'Open'
    issue_type VARCHAR(30), -- Biletin tipinin ne olduğunu anlatan değişken (Hata,
    case_origin VARCHAR(20) NOT NULL, --Biletin hangi kanal üzerinden yapıldığını açıklıyor (telefon, email)
    issue_title TEXT NOT NULL, --Biletin ne hakkında olduğunu açıklayan kısa bir başlık
    issue_description TEXT NOT NULL, --Bilette anlatılan sorun
    solution_description TEXT, --Eğer çözüldüyse sorunun çözümü
    solution_date TIMESTAMP, --Eğer çözüldüyse çözülme zamanı
    created_by INT NOT NULL, --Bileti yaratan hesabın ID'si
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Biletin yaratıldığı zaman
    modified_by INT NOT NULL, --Bilet hakkında en son işlem yapan kullanıcının ID'si
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Bilet hakkında en son değişiklik yapılan tarih
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (priority_id) REFERENCES TicketPriority(id) ON UPDATE CASCADE,
    FOREIGN KEY (status_id) REFERENCES TicketStatus(id)  ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT ,
    FOREIGN KEY (modified_by) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT
);



CREATE TABLE Interaction --Müşteriler ile olan etkileşimlerin bulunduğu masa
(
    interaction_id BIGSERIAL PRIMARY KEY, --Etkileşime özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    customer_id INT, --İnteraksiyonu yapan müşterinin Id'si
    support_ticket_id INT, -- Eğer iletişim Bilet yoluyla olduysa biletin Id'si
    interaction_title VARCHAR(75) NOT NULL,
    interacted_by INT NOT NULL, --Müşteri ile iletişime geçen CRM kullanıcısının Id'si
    interaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Etkileşimin yapıldığı zaman
    interaction_type VARCHAR(50), --Etkileşimin ne için yapıldığı yazılır (hata, satın alım, vb.)
    interaction_channel VARCHAR(50), --Etkileşimin hangi metodla yapıldığı yazılır (telefon, email, bilet vb.)
    notes TEXT NOT NULL, --Etkileşimden alınabilecek notlar.
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (support_ticket_id) REFERENCES SupportTicket(ticket_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (interacted_by) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Opportunity --Fırsat tablosu. Bu tabloda hesaplarımız(müşterilerimiz) ile olabilecek fırsatlarda hangi aşamada olduğumuz ve bu fırsatın potansiyel getirisi gibi değerler tutulur.
(
    opportunity_id SERIAL PRIMARY KEY, --Fırsat'a özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    opportunity_name VARCHAR(50) NOT NULL, --Fırsatın adı
    customer_id INT NOT NULL, --Fırsatın yapıldığı müşterinin Hesap Id'si
    owner_id INT NOT NULL, --Bu fırsatı yapan CRM kullanıcısının adı
    amount INT, --Bu fırsatın bize potansiyel getirisi
    close_date DATE, --Bu fırsatın sonuçlanması beklenen tahmini tarih
    status_id INT DEFAULT 1,  -- Varsayılan 'Qualification'
    probability INT CHECK ( probability <= 100 ), --Bu fırsatın kazanılma yüzdesi
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (status_id) REFERENCES OpportunityStatus(id) ON UPDATE CASCADE,
    FOREIGN KEY (owner_id) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Product --Ürünlerin bulunduğu tablo
(
    product_id SERIAL PRIMARY KEY, --Ürünün kendine özel Id'si
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    product_name VARCHAR(100) NOT NULL, --İsmi
    description TEXT NOT NULL, --Ürün açıklaması
    category VARCHAR(50) NOT NULL, --Kategorisi
    price DECIMAL(10,2) NOT NULL, -- Fiyatı
    stockQuantity INT, --Stockta kalan miktarı
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE OrderRecord --Siparişlerin bulunduğu tablo
(
    order_id SERIAL PRIMARY KEY, --Siparişe özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    customer_id INT NOT NULL, --Sipariş yapan müşterinin Id'si. Burası customer tablosunun customer_id alanına foreign key olacak
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Sipariş tarihi
    status VARCHAR(50) NOT NULL, --Sipariş durumu
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE OrderItem
(
    order_item_id SERIAL PRIMARY KEY,
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL,
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (order_id) REFERENCES OrderRecord (order_id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (product_id) REFERENCES Product (product_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Task --Kullancılıarın oluşturduğu görevlerin saklandığı tablo
(
    task_id SERIAL PRIMARY KEY, --Göreve özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    subject TEXT NOT NULL, --Görevin konusu
    assigned_to INT NOT NULL, -- Görevi hangi CRM kullanıcısının yapacağını belirten değişken
    is_external BOOLEAN DEFAULT FALSE, --Bu görevin şirketin içinde bir görev mi yoksa şirket dışındaki hesaplarla ilgili bir görev olduğunu belirtiyor
    related_external_id INT, --Eğer görev dışarıdaki hesap ile ilgiliyse hesabın Id'si
    related_internal_id INT, --Eğer görev içerideki kullanıcılar ile ilgiliyse CRM kullanıcısının Id'si
    description TEXT NOT NULL, -- Görev hakkında açıklama yapılması gerekiyorsa açıklama burada tutulur
    priority_id INT DEFAULT 2, -- Varsayılan 'Medium'
    status_id INT DEFAULT 1, -- Varsayılan 'Not Started'
    due_date TIMESTAMP NOT NULL, --Görevin son bitiş tarihini gçsterir
    created_by VARCHAR(50) NOT NULL, --Görevin kimin tarafından oluşturulduğunu gösterir.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Görevin oluşturulduğu tarih
    modified_by VARCHAR(50) NOT NULL, --Görev hakkında en son değişikliği yapan CRM kullanıcısının Id'si
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Görev hakkında en son ne zaman değişiklik yapıldığını gösterir
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (priority_id) REFERENCES TaskPriority(id) ON UPDATE CASCADE,
    FOREIGN KEY (status_id) REFERENCES TaskStatus(id) ON UPDATE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (related_external_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (related_internal_id) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Feedback --Müşterilerin(şirketlerin ve insanların) geri dönüşlerinin tutulduğu tablo
(
    feedback_id SERIAL PRIMARY KEY, --Feedback'e özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    customer_id INT, --Bileti yapan Müşterinin Id'si. Burası foreign key olacak.
    feedback_type VARCHAR(50) NOT NULL, --Şirketimizin hangi kısmına geri dönüş yapıyor (Servis, hizmet vb.)
    rating INT NOT NULL, --1 ile 5 arasında puan
    comment TEXT, --Yapmak isterse yorum sekmesi
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Geri dönüşün yapıldığı zaman
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE LastActivities --Kullanıcının yaptığı son aktiviteleri tutan tablo
(
    activity_id SERIAL PRIMARY KEY, --Aktiviteye özel Id
    tenant_id INT, --Bulut sisteminde farklı şirketlerin farklı tablolar görmesinin sağlayan satır
    activity_description VARCHAR(255) NOT NULL, --Aktivetede ne yapıldığını kısa bir şekilde anlatan değişken
    done_by INT NOT NULL, -- Aktivitenin kimin tarafından yapıldığını gösteren değişken
    FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (done_by) REFERENCES Employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
