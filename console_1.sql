-- ----------------------------------------------------------------------------------------------------------------
    -- Tworzenie użytkownikow
-- ----------------------------------------------------------------------------------------------------------------

-- Tworzenie użytkowników w MySQL
-- create user 'username'@'host' identified by 'password'
-- 'host' oznacze z którego adresu IP lub domeny użytkownik może się logować ('%' - oznacz dowolny host)
create user 'userb'@'localhost' identified by 'userb1234';

-- Podgląd wszystkich utworzonych userów
select * from mysql.user;
-- Podgląd wybranych kolumn
select Host, User from mysql.user;
select Host, User, authentication_string from mysql.user;

/*
-> MySQL NIE przechowuje hasel wprost (plain text).
-> Zamiast tego zapisuje w tabeli mysql.user zaszyfrowany skrot (hash) hasla.
-> Od wersji MySQL 5.7 i wyzej domyslnym mechanizmem uwierzytelniania jest:
    - caching_sha2_password w MySQL 8.0+ (domyslny od 8.0).
    - mysql_native_password w MySQL 5.7 i nizej.

mysql_native_password:
-> Haslo jest najpierw haszowane funkcja SHA1, potem wynik jest jeszcze raz haszowany SHA1.
-> W skrocie: SHA1(SHA1(password))

caching_sha2_password:
-> Uzywa SHA-256 do wygenerowania hasha.
*/

-- Jeżeli potrzebujesz podać inny plugin do szyfrowania hasła
create user 'userc'@'localhost' identified with caching_sha2_password by 'userc1234';

-- ----------------------------------------------------------------------------------------------------------------
    -- Nadawanie uprawnień
-- ----------------------------------------------------------------------------------------------------------------
-- grant typ_uprawnienien on baza_danych.tabela to 'username'@'host'
-- Typowe uprawnienia:
-- ALL PRIVILEGES – wszystkie możliwe prawa.
-- SELECT, INSERT, UPDATE, DELETE – operacje na danych.
-- CREATE, ALTER, DROP – operacje na strukturze bazy danych.
-- GRANT OPTION – pozwala nadawać uprawnienia innym.
grant select, insert on db.* to 'usera'@'localhost';

-- Jak sprawdzić nadane uprawnienia
show grants for 'usera'@'localhost';

-- Uprawienia usera w kontakcie konkretych baz danych zobaczysz w innej tabeli
select * from mysql.db;

-- ----------------------------------------------------------------------------------------------------------------
    -- Modyfikowanie danych użytkownika
-- ----------------------------------------------------------------------------------------------------------------
-- Dodawanie kolejnych uprawnień
grant update on db.* to 'usera'@'localhost';

-- Usuwanie uprawnień
revoke insert on db.* from 'usera'@'localhost';

-- Zmiana hasła
alter user 'usera'@'localhost' identified by 'usera1234';

-- ----------------------------------------------------------------------------------------------------------------
    -- Usuwanie użytkownika
-- ----------------------------------------------------------------------------------------------------------------
drop user 'userc'@'localhost';
-- Usunąć użytkownika niezależnie od bazy '%
drop user 'userc'@'%';

-- Globalne ustawienia dla usera
grant insert on *.* to 'usera'@'localhost';
revoke insert on *.* from 'usera'@'localhost';
grant insert on *.* to 'user'@'%';

-- Ustawienie jeszcze innych parametrów dla usera
create user 'userd'@'%' identified by 'userd1234';

-- Możesz dla usera ustawić limity
alter user 'userd'@'%'
with
    MAX_QUERIES_PER_HOUR 100
    MAX_CONNECTIONS_PER_HOUR 100
    MAX_UPDATES_PER_HOUR  200
    MAX_USER_CONNECTIONS 10;

-- MAX_QUERIES_PER_HOUR - Ile zapytań użytkownik może wykonać na godzinę
-- MAX_CONNECTIONS_PER_HOUR - Ile połączeń może otworzyć na godzinę
-- MAX_UPDATES_PER_HOUR - Ile operacji modyfikacji (INSERT, UPDATE, DELETE)
-- MAX_USER_CONNECTIONS - Ile aktywnych połączeń na raz

-- ----------------------------------------------------------------------------------------------------------------
    -- Ustawianie parametrów serwera
-- ----------------------------------------------------------------------------------------------------------------
show variables;
show global variables;
show session variables;
show global variables like 'sql_mode';
show session variables like 'sql_mode';

-- Mozesz ustawiac zmienne w ramach sesji lub globalnie
-- Globalnie – czyli dla całego serwera (dotyczy wszystkich sesji).
-- W ramach sesji – tylko dla aktualnie połączonego klienta.

set session sql_mode = 'STRICT_ALL_TABLES';
set global sql_mode = 'STRICT_TRANS_TABLES';