-- Na ten moment mamy serwer.
-- W ramach serwera możesz tworzyć bazy serwera
-- W bazie danych, możesz tworzyć tabele, które reprezentują encje.
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
-- Kolumna, która jest kluczem podstawowym, nie może miec w sobie duplikatów, bo każda
-- wartość w tej kolumnie musi jednoznacznie identyfikować rekord.
insert into products (id, name, price) values (1,'Product d', 4000);

-- Kiedy masz auto_increment?
insert into products (name, price) values ('Product a', 1000);
insert into products (name, price) values ('Product e', 1000);
insert into products (name, price) values
        ('Product b', 2000),
        ('Product c', 3000),
        ('Product d', 4000);

-- Możesz wpłynąć na to, od jakiej wartości zacznie liczyć auto_increment
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

-- --------------------------------------------------------------------------------------------------------------------
-- MODYFIKOWANIE STRUKTURY TABELI
-- --------------------------------------------------------------------------------------------------------------------

create table products (
    id int primary key auto_increment,
    name varchar(255),
    price int
);

insert into products (name, price)
values ('A', 100);

-- Dodawanie nowej kolumny
alter table products add category varchar(50) not null default 'default category';
alter table products add producer varchar(50) not null;
-- Obecnie przy domyślnych ustawieniach, pomimo że wpisałem not null wstawiło nam domyślnie
-- do istniejących wierszy do kolumny producer

SET GLOBAL sql_mode = 'STRICT_ALL_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SET SESSION sql_mode = 'STRICT_ALL_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

alter table products add city varchar(50) not null;
-- alter table products add test_date date not null;

-- Usuwanie kolumny
alter table products drop city;

-- Zmiany w obrębie kolumny
alter table products modify price decimal(20,2);
alter table products change price new_price int;
alter table products change new_price price int;

-- Zmiana nazwy tabeli
rename table products to my_products;
rename table my_products to products;

-- Dla istniejącej kolumny dodajesz opcje, że wartości w niej nie moga się powtarzać
alter table products add unique(name);

-- Możesz stworzyć nową kolumnę ktora jest unique
alter table products add city varchar(55) not null unique;
insert into products(name, price, city)
values ('AA', 100, 'W');

-- Możesz usunąć i dodać primary key
alter table products add primary key (name);
alter table products drop primary key;

-- Możesz ustawiać bardziej ogólne właściwości tabel
/*
| Właściwość          | Co ustawia?                                                     | Przykład |
|-------------------- |--------------------------------------------------               |----------|
| **ENGINE**          | Typ silnika bazy danych (`InnoDB`, `MyISAM`, itp.)              | `ENGINE=InnoDB` |
| **DEFAULT CHARSET** | Domyślny zestaw znaków dla tabeli                               | `DEFAULT CHARSET=utf8mb4` |
| **COLLATE**         | Domyślne porównywanie znaków (sortowanie, itp.)                 | `COLLATE=utf8mb4_unicode_ci` |
| **AUTO_INCREMENT**  | Wartość początkowa dla AUTO_INCREMENT                           | `AUTO_INCREMENT=1000` |
| **COMMENT**         | Komentarz opisujący tabelę                                      | `COMMENT='Tabela użytkowników aplikacji'` |
| **ROW_FORMAT**      | Format przechowywania wierszy (`DYNAMIC`, `COMPRESSED`, itd.)   | `ROW_FORMAT=DYNAMIC` |
| **AVG_ROW_LENGTH**  | Średnia długość wiersza (do optymalizacji)                      | `AVG_ROW_LENGTH=100` |
| **CHECKSUM**        | Czy przechowywać sumę kontrolną tabeli                          | `CHECKSUM=1` |
| **DELAY_KEY_WRITE** | Opóźnione zapisywanie indeksów (`MyISAM`)                       | `DELAY_KEY_WRITE=1` |
*/

/*
Co daje nam ustawienie ENGINE?
ENGINE określa, w jaki sposób tabela jest przechowywana i zarządzana w MySQL.
Mówi, jakie funkcje będą dostępne dla tabeli (np. transakcje, klucze obce, blokowanie).
Każdy silnik ma inne zalety, wady i zastosowania.

InnoDB
-> Domyślny silnik w MySQL od wersji 5.5.
-> Obsługuje transakcje (COMMIT, ROLLBACK).
-> Obsługuje klucze obce (FOREIGN KEY) – możesz tworzyć relacje między tabelami.
-> Blokuje pojedyncze wiersze, a nie całą tabelę (wydajne przy wielu użytkownikach).
-> Odporny na awarie (np. przy utracie zasilania można odzyskać dane).
-> Idealny do aplikacji produkcyjnych, gdzie są zapisy i modyfikacje danych.

MyISAM
-> Starszy silnik tabeli (popularny w dawnych wersjach MySQL).
-> Nie obsługuje transakcji ani kluczy obcych.
-> Blokuje całą tabelę podczas zapisu (mniej wydajne przy dużym ruchu).
-> Bardzo szybki przy czytaniu danych (SELECT).
-> Dane są trzymane w trzech plikach .frm, .MYD, .MYI.
-> Używany głównie do czytania dużych ilości danych, archiwów lub statystyk.

MEMORY (czasami nazywany HEAP)
-> Dane przechowywane tylko w pamięci RAM.
-> Bardzo szybki dostęp do danych.
-> Dane znikają po restarcie serwera (są nietrwałe).
-> Idealny do tymczasowych tabel, sesji użytkownika lub szybkich obliczeń.

CSV
-> Dane zapisywane bezpośrednio jako pliki CSV (jedna tabela = jeden plik .csv).
-> Przydatny do łatwego importu i eksportu danych.
-> Bardzo ograniczone możliwości (np. brak indeksów).

ARCHIVE
-> Dane są kompresowane i przechowywane z minimalnym zużyciem miejsca.
-> Obsługuje tylko INSERT i SELECT (nie możesz kasować ani aktualizować danych).
-> Idealne do przechowywania starych logów, archiwów lub danych historycznych.

FEDERATED
-> Pozwala łączyć się z innymi serwerami MySQL (zdalne tabele).
-> Dane są fizycznie na innym serwerze, ale możesz czytać je lokalnie.
-> Mało używany i trudniejszy w konfiguracji.

Podsumowując:
Jeśli nie wiesz, co wybrać — używaj InnoDB.
Jeśli masz tylko czytanie danych i zależy Ci na szybkości — możesz rozważyć MyISAM.
Jeśli dane mają być tymczasowe i szybkie — MEMORY.
Jeśli archiwizujesz dane — ARCHIVE.
Jeśli importujesz/eksportujesz — CSV.
Jeśli chcesz czytać dane z innej bazy — FEDERATED.
*/

create table users (
    id int primary key auto_increment,
    user_name varchar(255) not null
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci
AUTO_INCREMENT=1000
COMMENT='Users table';

alter table users
    ENGINE=InnoDB
    DEFAULT CHARSET=utf8mb4
    COLLATE=utf8mb4_unicode_ci
    AUTO_INCREMENT=1000
    COMMENT='Users table';

-- Podgląd parametrów
show create table users;
show table status like 'users';
describe users;

-- Inne parametry tabeli

/*

=> ROW_FORMAT definiuje w jaki sposób dane wierszy są fizycznie przechowywane w tabeli na dysku.
Wpływa na:
-> wielkość tabeli,
-> szybkość odczytu/zapisu,
-> możliwość kompresji,
-> sposób zarządzania dużymi kolumnami (TEXT, BLOB).

Dostępne opcje:
DYNAMIC – domyślna w InnoDB; duże kolumny (TEXT, BLOB) są przechowywane osobno, a w wierszu trzymane
są tylko wskaźniki. Oszczędza miejsce, zmniejsza I/O.
COMPRESSED – dane wierszy są kompresowane; zmniejsza rozmiar tabeli na dysku, kosztem większego obciążenia
CPU (potrzeba rozpakowania danych podczas czytania).
REDUNDANT – stary format (sprzed InnoDB Plugin), mniej wydajny; używany tylko ze starymi bazami.
COMPACT – wydajny i "uporządkowany" format wierszy; lepszy od REDUNDANT.
FIXED – (dla MyISAM) — wszystkie wiersze mają stałą długość, nawet jeśli dane są krótsze (szybsze
przeszukiwanie, ale większe zużycie miejsca).

ALTER TABLE users ROW_FORMAT=DYNAMIC;

Kiedy używać?
DYNAMIC – prawie zawsze dla nowoczesnych aplikacji (najlepszy kompromis).
COMPRESSED – gdy masz ogromne ilości danych i zależy Ci na oszczędzaniu miejsca.

=> AVG_ROW_LENGTH to wskazówka dla MySQL, jaka będzie średnia długość pojedynczego
wiersza w tabeli. MySQL używa tej informacji, żeby:
-> dobrać rozmiar plików danych,
-> lepiej rozplanować alokację przestrzeni (szczególnie dla MyISAM).

Jak działa?
-> Jeśli MySQL wie, że wiersze będą długie, może z góry zarezerwować więcej miejsca.
-> W tabelach zmiennych (VARCHAR, TEXT) pomaga zoptymalizować strukturę plików.

Kiedy używać?
Gdy masz dużą tabelę o wierszach różnej długości (np. z polami tekstowymi).
Gdy MySQL źle szacuje i chcesz poprawić wydajność fizycznego rozmieszczenia danych.
Uwaga:
Nie wpływa bezpośrednio na szybkość zapytań, tylko na sposób alokowania pliku.
ALTER TABLE users AVG_ROW_LENGTH=500;

=> CHECKSUM oznacza, czy dla tabeli będzie obliczana suma kontrolna.

Po co to?
W celu wykrywania błędów w danych.
Można szybciej sprawdzić, czy dane w tabeli się zmieniły (bez czytania całej tabeli).

Jak działa?
Jeśli CHECKSUM=1, przy każdej modyfikacji wiersza MySQL oblicza nową sumę kontrolną.
Przy CHECKSUM TABLE nazwa_tabeli; możesz potem sprawdzić, czy dane są zgodne.

ALTER TABLE users CHECKSUM=1;

Kiedy używać?
Gdy chcesz monitorować integralność danych.
Gdy masz kopie tabel (np. w replikacji) i chcesz szybko wykryć różnice.

Uwaga:
Obliczanie sumy kontrolnej spowalnia zapisy do tabeli!
Zalecane raczej dla archiwów, kopii danych, systemów krytycznych.

=> DELAY_KEY_WRITE=1 ustawia, że indeksy tabeli są zapisywane na dysk z opóźnieniem.

Jak działa?
Dane w tabeli zapisywane są normalnie.
Ale klucze indeksów (np. dla PRIMARY KEY lub INDEX) są zapisywane dopiero, gdy:
plik zostanie zamknięty,
lub przy synchronizacji.
Dzięki temu przyspiesza zapis INSERT/UPDATE.

ALTER TABLE users DELAY_KEY_WRITE=1;

Kiedy używać?
Dla tabel, gdzie masz bardzo dużo operacji INSERT i zależy Ci na szybkości.
Dla tabel tymczasowych, logów, raportów — tam gdzie utrata danych przy awarii jest akceptowalna.

Uwaga:
Jeśli serwer MySQL padnie przed zapisaniem indeksu, możesz stracić dane indeksu!
Dlatego nie stosuje się tego dla danych krytycznych.
*/

-- ---------------------------------------------------------------------------------------------------
-- COMPOSITE KEY
-- ---------------------------------------------------------------------------------------------------
/*
Co to jest złożony klucz główny (composite key)
-> To klucz główny (PRIMARY KEY), który składa się z więcej niż jednej kolumny.
-> Kombinacja tych kolumn razem musi być unikalna — pojedyncza kolumna sama może się powtarzać, ale
    ich połączenie już nie.

Po co używać złożonych kluczy głównych?
-> Gdy żadna pojedyncza kolumna nie identyfikuje unikalnie rekordu.
-> Gdy chcesz wymusić unikalność kombinacji (np. użytkownik może głosować wiele razy, ale tylko raz na dany artykuł).
-> Gdy budujesz tabele relacyjne lub łącznikowe (np. wiele-do-wielu).
-> Gdy chcesz uniknąć dodatkowego ID (id jako AUTO_INCREMENT) i używać naturalnych kluczy.
*/

create table votes (
    user_id int not null,
    article_id int not null,
    vote_value int not null,
    vote_data datetime default now(),
    primary key (user_id, article_id)
);


insert into db.votes (user_id, article_id, vote_value)
values (2, 1, 10);

select * from votes;


/*
    W pierwszym nagraniu powiedzialem:
    Język Zapytań SQL (Structured Query Language): Baza danych powinna udostępniać standardowy język SQL do definiowania
    struktury danych (DDL - Data Definition Language), manipulowania danymi (DML - Data Manipulation Language) oraz kontroli
    dostępu (DCL - Data Control Language). SQL umożliwia wykonywanie zapytań, wstawianie, aktualizowanie i usuwanie danych.

    DDL – Data Definition Language
    Język Definiowania Danych
    Typowe komendy DDL:
    CREATE TABLE — tworzy nową tabelę.
    ALTER TABLE — zmienia strukturę istniejącej tabeli (dodaje/usuwa/modyfikuje kolumny).
    DROP TABLE — usuwa tabelę.
    CREATE INDEX, DROP INDEX — tworzy lub usuwa indeksy


    DML – Data Manipulation Language
    Język Manipulacji Danymi
    Typowe komendy DML:
    SELECT — pobiera dane.
    INSERT — wstawia nowe dane.
    UPDATE — zmienia istniejące dane.
    DELETE — usuwa dane.

    DCL – Data Control Language
    Język Kontroli Dostępu
    Typowe komendy DCL:
    GRANT — nadaje użytkownikowi uprawnienia (np. do odczytu, zapisu, administrowania).
    REVOKE — odbiera wcześniej nadane uprawnienia.

    Jak to wszystko razem działa w MySQL?
    DDL definiuje, jak wygląda Twoja baza (tabele, kolumny, indeksy).
    DML pozwala Ci pracować na danych (dodawać, zmieniać, czytać, usuwać).
    DCL zabezpiecza Twoją bazę danych (kto i co może zrobić).
    I wszystko to działa przez jeden wspólny język — SQL.

*/