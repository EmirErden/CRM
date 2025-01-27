--Veri tabanında bazı sütünlar için ENUM değerleri
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

CREATE TYPE ticket_priority AS ENUM (
    'Low',
    'Medium',
    'High',
    'Critical'
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


CREATE TABLE Employees --Şirketemizde olan bütün çalışanları kapsar CRM kullananları ve kullanmayanları
(
    employee_id SERIAL PRIMARY KEY, -- Benzersiz çalışan ID'si
    first_name VARCHAR(50) NOT NULL,            -- Ad
    last_name VARCHAR(50) NOT NULL,             -- Soyad
    department VARCHAR(50),                    -- Departman
    job_title VARCHAR(50),                      -- Görev unvanı
    email VARCHAR(100) UNIQUE,                 -- İş e-postası
    status employee_status DEFAULT 'Active' -- Çalışan durumu
);

CREATE TABLE CRMUsers --Burası CRM kullanan çalışanların olduğu tablodur
(
    crm_user_id SERIAL PRIMARY KEY, -- Benzersiz CRM kullanıcı ID'si
    employee_id INT UNIQUE,                    -- Çalışanla ilişki
    username VARCHAR(50) UNIQUE NOT NULL,     -- CRM kullanıcı adı
    password_hash VARCHAR(60) NOT NULL,       -- Şifre (hashlenmiş)
    role user_roles NOT NULL, -- CRM uygulamasındaki rolü
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) -- Çalışan ilişkisi
);

 --!!!!!!!!!!!!!!!!!!!!!!!!!!!Şahıs şirketi ve normal şirket farkını eklememiz gerekebilir.
CREATE TABLE Companies
(
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    website VARCHAR(50),
    linkedin_url VARCHAR(50), -- Hesabın (varsa) linkedin hesabının linki
    instagram_url VARCHAR(50), -- Hesabın (varsa) instagram hesabının linki
    facebook_url VARCHAR(50), -- Hesabın (varsa) facebook hesabının linki
    twitter_url VARCHAR(50), -- Hesabın (varsa) twitter hesabının linki
    city VARCHAR(30),
    company_type VARCHAR(50),
    relation VARCHAR(50),
    industry VARCHAR(50),
    annual_revenue INT,
    no_of_employees INT,
    description TEXT, -- Hesap hakkında açıklama yapılması gerekiliyorsa doldurulur
    address TEXT,
    billing_address TEXT,
    owner_id INT NOT NULL,
    created_by INT NOT NULL, -- Hesabın yapan CRM Kullanıcısının
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesabın yaratıldığı tarih
    modified_by INT NOT NULL, -- Hesapta en son değişiklik yapan CRM kullanıcısı
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesap hakkında en son değişiklik yapıldığı tarih
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (created_by) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (modified_by) REFERENCES CRMUsers(crm_user_id)
);


CREATE TABLE Contacts --Şirket müşterilerimiz ile bağlantımız olan insanların bilgilerinin bulunduğu tablo
(
    contact_id SERIAL PRIMARY KEY, --Bağlantıya özel Id
    company_id INT NOT NULL, --Bağlantının şirketinin Id'si
    name VARCHAR(100) NOT NULL, -- Bğlantının ismi
    phone VARCHAR(15), --Bağlantının telefon numarası
    email VARCHAR(50), --Bağlantının email adresi
    position VARCHAR(50), --Bağlantının şirketteki pozisyonu
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

CREATE TABLE Individuals
(
    individual_id SERIAL PRIMARY KEY,
    individual_name VARCHAR(100) NOT NULL,
    email VARCHAR(50),
    phone VARCHAR(15),
    relation VARCHAR(50),
    website VARCHAR(50),
    linkedin_url VARCHAR(50), -- Hesabın (varsa) linkedin hesabının linki
    instagram_url VARCHAR(50), -- Hesabın (varsa) instagram hesabının linki
    facebook_url VARCHAR(50), -- Hesabın (varsa) facebook hesabının linki
    twitter_url VARCHAR(50), -- Hesabın (varsa) twitter hesabının linki
    city VARCHAR(30),
    date_of_birth DATE, -- Doğum tarihi (müşteriler için geçerli)
    gender VARCHAR(20), -- Cinsiyet (kişiler için geçerli)
    martial_status BOOLEAN DEFAULT FALSE, -- Medeni durum (kişiler için geçerli)
    have_kids BOOLEAN DEFAULT FALSE, -- Çocuk sahibi olma durumu (kişiler için geçerli)
    industry VARCHAR(50), -- Şirketin endüstrisi (şirketler için geçerli)
    annual_revenue INT,
    description TEXT, -- Hesap hakkında açıklama yapılması gerekiliyorsa doldurulur
    owner_id INT NOT NULL, -- Bu hesabı hesap yapan CRM kullanıcısının ID'si
    address TEXT,
    billing_address TEXT,
    created_by INT NOT NULL, -- Hesabın yapan CRM Kullanıcısının
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesabın yaratıldığı tarih
    modified_by INT NOT NULL, -- Hesapta en son değişiklik yapan CRM kullanıcısı
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesap hakkında en son değişiklik yapıldığı tarih
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (created_by) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (modified_by) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE Customers
(
    customer_id SERIAL PRIMARY KEY,
    company_id INT,
    individual_id INT,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id),
    FOREIGN KEY (individual_id) REFERENCES Individuals(individual_id)
);

CREATE TABLE Accounts -- Müşteriler ve şirketlerin bilgilerini içeren tablo. Müşteri ve şirketleri hesap adı altında birleştiriyoruz.
(
    account_id SERIAL PRIMARY KEY, -- Hesaba özel Id
    is_company BOOLEAN,  --Bu müşterinin şirket olup olmadığını anlamamızı sağlayan boolean
    account_type VARCHAR(20) NOT NULL, -- Müşteri Türü
    company_type VARCHAR(30), -- Eğer müşteri şirketse onun ne tip şirket olduğunu açıklıyor (a.ş. ltd şti vb.)
    contact_name VARCHAR(30), -- Eğer şirketse şirketle iletişime geçtiğimizde konuşacağımız kişinin ismi
    relation VARCHAR(50), -- Hesabın bizimle ilşkisini anlatan değişken (Partner, Müşteri vb.)
    name VARCHAR(100) NOT NULL, -- İsim veya Şirket Adı
    email VARCHAR(50) NOT NULL, -- E-mail
    phone VARCHAR(15) NOT NULL, -- Telefon Numarası
    address VARCHAR(255) NOT NULL, -- Adres
    billing_address VARCHAR(255), -- Faturada yazılan adres
    city VARCHAR(50) NOT NULL, -- Şehir
    country VARCHAR(50) NOT NULL, -- Ülke
    date_of_birth DATE, -- Doğum tarihi (müşteriler için geçerli)
    gender VARCHAR(20), -- Cinsiyet (kişiler için geçerli)
    martial_status BOOLEAN DEFAULT FALSE, -- Medeni durum (kişiler için geçerli)
    have_kids BOOLEAN DEFAULT FALSE, -- Çocuk sahibi olma durumu (kişiler için geçerli)
    industry VARCHAR(50), -- Şirketin endüstrisi (şirketler için geçerli)
    website VARCHAR(50), -- Web sitesi (şirketler için geçerli)
    linkedin_url VARCHAR(50), -- Hesabın (varsa) linkedin hesabının linki
    instagram_url VARCHAR(50), -- Hesabın (varsa) instagram hesabının linki
    facebook_url VARCHAR(50), -- Hesabın (varsa) facebook hesabının linki
    twitter_url VARCHAR(50), -- Hesabın (varsa) twitter hesabının linki
    no_of_employees INT, -- Çalışan sayısı (şirketler için geçerli)
    owner_id INT NOT NULL, -- Bu hesabı hesap yapan CRM kullanıcısının ID'si
    description TEXT, -- Hesap hakkında açıklama yapılması gerekiliyorsa doldurulur
    created_by INT NOT NULL, -- Hesabın yapan CRM Kullanıcısının
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesabın yaratıldığı tarih
    modified_by INT NOT NULL, -- Hesapta en son değişiklik yapan CRM kullanıcısı
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Hesap hakkında en son değişiklik yapıldığı tarih
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (created_by) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (modified_by) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE SupportTickets --Kullanıcıların destek biletlerinin tutulduğu yer
(
    ticket_id SERIAL PRIMARY KEY, --Biletlere özel Id
    account_id INT, --Bileti yapan Hesabın Id'si. Burası foreign key olacak.
    priority ticket_priority DEFAULT 'Low', --Biletin öncelik düzeyi
    status ticket_status DEFAULT 'Open', --Biletin durumu
    issue_type VARCHAR(30), -- Biletin ne tipinin ne olduğunu anlatan değişken (Hata,
    case_origin VARCHAR(20) NOT NULL, --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Bu ne bilmiyorum yukarıdaki variable ile aynı olabilir.
    issue_title TEXT NOT NULL, --Biletin ne hakkında olduğunu açıklayan kısa bir başlık
    issue_description TEXT NOT NULL, --Bilette anlatılan sorun
    solution_description TEXT, --Eğer çözüldüyse sorunun çözümü
    solution_date TIMESTAMP, --Eğer çözüldüyse çözülme zamanı
    created_by INT NOT NULL, --Bileti yaratan hesabın ID'si
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Biletin yaratıldığı zaman
    modified_by INT NOT NULL, --Bilet hakkında en son işlem yapan kullanıcının ID'si
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Bilet hakkında en son değişiklik yapılan tarih
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (created_by) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (modified_by) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE Interactions --Müşteriler ile olan etkileşimlerin bulunduğu masa
(
    interaction_id BIGSERIAL PRIMARY KEY, --Etkileşime özel Id
    account_id INT, --İnteraksiyonu yapan müşterinin Id'si
    support_ticket_id INT, -- Eğer iletişim Bilet yoluyla olduysa biletin Id'si
    interacted_by INT NOT NULL, --Müşteri ile iletişime geçen CRM kullanıcısının Id'si
    interaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Etkileşimin yapıldığı zaman
    interaction_type VARCHAR(50), --Etkileşimin ne için yapıldığı yazılır (hata, satın alım, vb.)
    interaction_channel VARCHAR(50), --Etkileşimin hangi metodla yapıldığı yazılır (telefon, email, bilet vb.)
    notes TEXT NOT NULL, --Etkileşimden alınabilecek notlar.
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (support_ticket_id) REFERENCES SupportTickets(ticket_id),
    FOREIGN KEY (interacted_by) REFERENCES CRMUsers(crm_user_id)
);

CREATE TABLE Opportunities --Fırsat tablosu. Bu tabloda hesaplarımız(müşterilerimiz) ile olabilecek fırsatlarda hangi aşamada olduğumuz ve bu fırsatın potansiyel getirisi gibi değerler tutulur.
(
    opportunity_id SERIAL PRIMARY KEY, --Fırsat'a özel Id
    opportunity_name VARCHAR(50) NOT NULL, --Fırsatın adı
    account_id INT NOT NULL, --Fırsatın yapıldığı müşterinin Hesap Id'si
    owner_id INT NOT NULL, --Bu fırsatı yapan CRM kullanıcısının adı
    amount INT, --Bu fırsatın bize potansiyel getirisi
    close_date DATE, --Bu fırsatın sonuçlanması beklenen tahmini tarih
    status opportunity_status DEFAULT 'Qualification', --Bu fırsatın hangi aşamada olduğunu gösteriyor
    probability INT CHECK ( probability <= 100 ), --Bu fırsatın kazanılma yüzdesi
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Leads --Potansiyel müşterilerin bilgilerinin bulunduğu tablo
(
    lead_id SERIAL PRIMARY KEY, --Potansiyel müşteriye özel Id
    name VARCHAR(50) NOT NULL, --İsmi
    email VARCHAR(50) NOT NULL, --E-mail'i
    phone VARCHAR(15) NOT NULL, --Telefon Numarası
    city VARCHAR(50) NOT NULL, --Potansiyel müşterinin şehri
    address VARCHAR(255), --Adresi
    website VARCHAR(50), --varsa websitesi
    leadStatus lead_status DEFAULT 'New', --Bizim müşterimiz olmada hangi aşamada olduğunu gösterir
    source VARCHAR(50) NOT NULL, --Potansiyel müşterinin bulunduğu kaynak
    notes TEXT, --Potansiyel müşteri hakkında (varsa) notlar
    owner_id INT NOT NULL, --Potansiyel müşteriyi bulan CRM kullanıcısı
    follow_up BOOLEAN DEFAULT FALSE, --Potansiyel müşteriye geri dönüş yapılmasının gerekip gerekmediğini gösteren bir değişken
    annual_revenue INT, --Potansiyel müşterinin yıllık geliri
    no_of_employees INT, --Şirketse çalışan sayısının olduğu değişken
    industry VARCHAR(50), --Potansiyel müşterinin Endüstrisi
    created_by INT NOT NULL, --Bu potansiyel müşteriyi yapan CRM kullanıcısının Id'si
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Potansiyel müşteri olduğu tarih
    modified_by INT NOT NULL, --Potansiyel müşteride en son değişiklik yapan CRM kullanıcısının Id'si
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --En son değişiklik yapılan zaman
    FOREIGN KEY (owner_id) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (created_by) REFERENCES CRMUsers(crm_user_id),
    FOREIGN KEY (modified_by) REFERENCES CRMUsers(crm_user_id)
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
    quantity INT NOT NULL, --Siparişte kaç tane ürün olduğunun değeri
    product_id INT NOT NULL, --Satın alınan ürünün Id'si
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Sipariş tarihi
    status VARCHAR(50) NOT NULL, --Sipariş durumu
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);


CREATE TABLE Tasks --Kullancılıarın oluşturduğu görevlerin saklandığı tablo
(
    task_id SERIAL PRIMARY KEY, --Göreve özel Id
    subject TEXT NOT NULL, --Görevin konusu
    assigned_to INT NOT NULL, -- Görevi hangi CRM kullanıcısının yapacağını belirten değişken
    is_external BOOLEAN, --Bu görevin şirketin içinde bir görev mi yoksa şirket dışındaki hesaplarla ilgili bir görev olduğunu belirtiyor
    related_external_id INT, --Eğer görev dışarıdaki hesap ile ilgiliyse hesabın Id'si
    related_internal_id INT, --Eğer görev içerideki kullanıcılar ile ilgiliyse CRM kullanıcısının Id'si
    description TEXT NOT NULL, -- Gçrev hakkında açıklama yapılması gerekiyorsa açıklama burada tutulur
    priority task_priority DEFAULT 'Medium', --Görevin öncelik düzeyi
    status task_status DEFAULT 'Not Started', --Görevin hangi aşamada olduğunu gösterir
    due_date TIMESTAMP NOT NULL, --Görevin son bitiş tarihini gçsterir
    created_by VARCHAR(50) NOT NULL, --Görevin kimin tarafından oluşturulduğunu gösterir.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Görevin oluşturulduğu tarih
    modified_by VARCHAR(50) NOT NULL, --Görev hakkında en son değişikliği yapan CRM kullanıcısının Id'si
    last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Görev hakkında en son ne zaman değişiklik yapıldığını gösterir
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

CREATE TABLE LastActivities --Kullanıcının yaptığı son aktiviteleri tutan tablo
(
    activity_id SERIAL PRIMARY KEY, --Aktiviteye özel Id
    activity_description VARCHAR(255) NOT NULL, --Aktivetede ne yapıldığını kısa bir şekilde anlatan değişken
    done_by INT NOT NULL, -- Aktivitenin kimin tarafından yapıldığını gösteren değişken
    FOREIGN KEY (done_by) REFERENCES CRMUsers(crm_user_id)
);





