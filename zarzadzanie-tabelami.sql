-- Na ten moment mamy serwer.
-- W ramach serwera możesz tworzyć bazy serwera
-- W bazie danych możesz tworzyć tabele, które reprezentują encje.
-- Tabela posiada kolumny, które pozwalają przechowywać dane jednego rodzaju.
-- Do tabeli możesz wstawiać dane - kolejne rekordy, które reprezentują konkretny byt.

-- --------------------------------------------------------------------------------------------------------------------
-- BAZA DANYCH
-- --------------------------------------------------------------------------------------------------------------------

-- Podgląd istniejącyh baz danych, z którym jesteśmy połączeni
show databases;
-- Możesz utworzyć nową baze danych
create database db2;
-- Możesz usunać baze danych
drop database db2;
-- Kiedy chcesz pracować z konkretną bazą danych i miec pewnośc, że komendy sql będą wdrażane do tej bazy danych,
-- należy się na niej ustawić
use db;
-- Możesz sprawdzić, która baze danych aktualnie używamy
select database();

-- --------------------------------------------------------------------------------------------------------------------
-- TABELA
-- --------------------------------------------------------------------------------------------------------------------
-- Tworzenie tabeli
-- Bardzo waznym elementem/kolumną tabeli jest klucz głowny (klucz podstawowy)
-- Jest to kolumna, która pozwala w JEDNOZNACZNY sposob zidentyfikować wiersz w tabeli.

-- Co to jest AUTO_INCREMENT?
-- To atrybut kolumny (zwykle typu liczbowego, np. INT), który sprawia, że przy każdym nowym wierszu
-- automatycznie przypisywana jest kolejna liczba całkowita.
-- Nie musisz ręcznie podawać wartości – baza sama zajmuje się nadawaniem unikalnych identyfikatorów.

create table products
(
    id    int primary key auto_increment,
    name  varchar(255),
    price int
);
-- Podejrzenie istniejących tabel
show tables;
-- Pokazywanie kolumn w tabeli
show columns from products;
-- Jeszcze inny sposób na uzyskanie informacji na temat tabeli
desc products;
-- Usuwanie tabeli
drop table products;

-- Możesz do utworzonej tabeli wstawiać dane za pomocą komendy insert.
-- Wstawianie jednego wiersza
insert into products (id, name, price) values (1,'Product a', 1000);
-- Kolumna która jest kluczem podstawowym nie może miec w sobie duplikatów, bo każda
-- wartość w tej kolumnie musi jednoznacznie identyfikować rekord.
insert into products (id, name, price) values (1,'Product d', 4000);

-- Kiedy masz auto_increment?
insert into products (name, price) values ('Product a', 1000);
insert into products (name, price) values ('Product e', 1000);
insert into products (name, price) values
        ('Product b', 2000),
        ('Product c', 3000),
        ('Product d', 4000);

-- Możesz wpłynąć na to od jakiej wartości zacznie liczyć auto_increment
alter table products auto_increment 1000;
/*
Jakie cechy ma kolumna, ktora jest kluczem glownym (podstawowym).

->  Unikalność
    Każda wartość w tej kolumnie musi być unikalna.
    Nie mogą istnieć dwa wiersze z tą samą wartością klucza głównego.

->  Nie może być NULL
    Każdy wiersz musi mieć wartość w kolumnie klucza głównego.
    NULL (brak wartości) jest niedozwolony.

->  Indeksowanie
    Automatycznie tworzy się unikalny indeks dla klucza głównego.
    Dzięki temu wyszukiwanie po kluczu głównym jest bardzo szybkie.

->  Identyfikacja rekordu
    Klucz główny jednoznacznie identyfikuje każdy wiersz w tabeli.
    Jest podstawą do budowania relacji między tabelami (np. klucze obce – FOREIGN KEY).

->  Stabilność
    Dobrą praktyką jest, by wartość klucza głównego nie zmieniała się po utworzeniu
    rekordu (choć technicznie MySQL na to pozwala).

->  Pojedynczy lub złożony
    Klucz główny może być:
    pojedynczy (jedna kolumna, np. id)
    złożony (wiele kolumn razem, np. (user_id, role_id))
*/
-- Wstawianie wiele wierszy
insert into db.products (id, name, price)
values (2, 'Product b', 2000),
       (3, 'Product c', 3000);
-- Pobranie danych z tabeli
-- Poniższa komenda pozwala pobrać wszystkie dane z tabeli
select * from products;
/*
Typy danych w SQL
Podczas tworzenia tabel i ich kolumn musimy wybrać odpowiedni typ danych:

Najczęściej używane:

=> Numeric Types (liczbowe):
INT, SMALLINT, BIGINT — liczby całkowite o różnym zakresie.
DECIMAL(p,s) — dokładne wartości dziesiętne (np. ceny).
FLOAT, DOUBLE — liczby zmiennoprzecinkowe.
BIT — wartości binarne (0/1).

=> String Types (teksty):
CHAR(n), VARCHAR(n) — napisy o stałej lub zmiennej długości.

CHAR(n) — stała długość
Przechowuje dokładnie n znaków.
Jeśli wpisany tekst jest krótszy niż n, zostanie automatycznie dopełniony spacjami na końcu.
Zajmuje stałą ilość miejsca (np. CHAR(10) zawsze 10 bajtów, niezależnie od długości wpisanego tekstu).
Lepszy wybór, jeśli wszystkie dane mają jednolitą długość (np. kody pocztowe, identyfikatory).

VARCHAR(n) — zmienna długość
Przechowuje do n znaków, ale nie więcej.
Zajmuje tyle miejsca, ile ma tekst + dodatkowy bajt(y) na długość.
Nie dopełnia spacjami — zapisuje tylko rzeczywiste znaki.
Lepszy wybór, gdy dane mają zmienną długość i chcesz oszczędzać miejsce.

TEXT, TINYTEXT, LONGTEXT — długie teksty.
TINYTEXT	255 znaków (255 B)	            1 bajt	    bardzo krótkie teksty
TEXT	    65 535 znaków (64 KB)	        2 bajty	    typowy tekst, np. komentarze
LONGTEXT	4 294 967 295 znaków (4 GB)	    4 bajty	    ogromne dane: książki, logi

ENUM('option1', 'option2', ...) — wartości wybrane ze zbioru.

=> Date Types (daty i czasy):
DATE — tylko data.
DATETIME — data i godzina.
TIMESTAMP — automatyczna data / czas.
TIME — tylko godzina.
YEAR — tylko rok.

https://dev.mysql.com/doc/refman/8.4/en/data-types.html
*/
-- price decimal(10, 2) not null default 0.00,
-- Nie możesz wpisać NULL.
-- Jeśli nic nie podasz — automatycznie wpisze się 0.00.

-- popularity FLOAT DEFAULT 0
-- Możesz wstawić NULL ręcznie.
-- Jeśli nie podasz żadnej wartości, system wstawi 0.

-- 12.3
-- float  -> 12.29999912837621738216738216 - 32bity - rozjeżdza się wcześniej
-- double -> 12.29999999999912983721897381 - 64bity - precyzja troche większa

-- TIMESTAMP to typ danych, który przechowuje datę i godzinę.
-- Jest dokładniejszy niż zwykłe DATE — bo zawiera pełny czas: rok, miesiąc,
-- dzień, godzina, minuta, sekunda.
-- Automatycznie może zapisywać czas utworzenia lub czas aktualizacji rekordu w bazie danych.

-- Czym TIMESTAMP rozni sie od DATETIME
-- DATETIME = przechowuje datę i czas dosłownie, tak jak wpiszesz. np. 2025-04-29 16:45:00
--  — zawsze dokładnie tak, bez zmiany!
-- TIMESTAMP = przechowuje liczbę sekund od 1970-01-01 UTC (ang. "epoka UNIX") i przelicza ją na
-- czas lokalny według ustawionej strefy czasowej serwera. Jeśli zmienisz strefę czasową serwera —
-- wartość TIMESTAMP będzie wyświetlać się inaczej!

/*
    Cecha	                            DATETIME	                                    TIMESTAMP
    Zakres wartości	                    1000-01-01 do 9999-12-31	                    1970-01-01 00:00:01 do 2038-01-19
    Uwzględnia strefę czasową           Nie                                             Tak
    Rozmiar na dysku	                8 bajtów	                                    4 bajty (do MySQL 5.6) / 7+ bajtów (nowsze wersje)
    Domyślna wartość	                Musisz ręcznie ustawić (np. CURRENT_TIMESTAMP)	Może automatycznie wstawiać CURRENT_TIMESTAMP
    Zachowanie przy aktualizacji        Musisz ręcznie ustawić	                        Może automatycznie się aktualizować (ON UPDATE)
    Precyzja (od wersji MySQL 5.6.4)    może mieć mikrosekundy (DATETIME(3))	        może mieć mikrosekundy (TIMESTAMP(3))
*/
-- updated_at timestamp default null on update current_timestamp,
-- DEFAULT NULL -> kiedy dodajesz nowy rekord i nie podasz wartości dla updated_at, to będzie NULL.
-- ON UPDATE CURRENT_TIMESTAMP -> za każdym razem, gdy aktualizujesz rekord (np. przez UPDATE), automatycznie wpisze
-- się aktualna data i czas (CURRENT_TIMESTAMP).

-- https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html

create table products_sales (
    product_id int not null auto_increment,
    name varchar(255) not null,
    product_code char(10) not null,
    short_description tinytext default null,
    description text,
    full_description longtext default null,
    price decimal(10, 2) not null default 0.00,
    stock_quantity int not null default 0,
    minimum_stock smallint not null default 1,
    maximum_stock bigint default 1000000,
    is_active bit not null default b'1',
    popularity float default 0,
    average_rating double default null,
    status enum('active', 'archived', 'pending') not null default 'active',
    -- added_date date not null default (current_date),
    added_date date not null default (current_date),
    -- added_date date not null default current_date(),
    last_modified datetime default null,
    delivery_time time default '00:24:00',
    production_year year default 2025,
    -- created_at timestamp not null default current_timestamp(),
    created_at timestamp not null default now(),
    -- updated_at timestamp default null on update current_timestamp,
    updated_at timestamp default null on update now(),
    primary key (product_id)  -- inny sposob ustawienia klucza glownego
);
select * from products_sales;

insert into products_sales(name, product_code, description)
values ('prod 1', 'xx-11', 'iosadusaiudsdioadusaiodusaiouusad');