use db;

-- --------------------------------------------------------------------------------------------------------------------
-- ONE TO ONE
-- --------------------------------------------------------------------------------------------------------------------

-- Relacja one-to-one (1:1) polega na tym, że jeden rekord w jednej tabeli odpowiada dokładnie jednemu rekordowi
-- w drugiej tabeli — i odwrotnie.
-- Tabela users (użytkownicy) i tabela user_profiles (profile użytkowników):
-- Każdy użytkownik ma dokładnie jeden profil, a każdy profil należy do jednego użytkownika.


 -- WERSJA 1 -> PRIMARY KEY = FOREIGN KEY
create table users (
    id int primary key auto_increment,
    username varchar(100) not null
);

create table user_profile (
    id int primary key,
    full_name varchar(100),
    bio text,
    foreign key (id) references users(id) on delete cascade on update cascade
);

-- user_profiles.id musi istnieć w users.id (klucz obcy).
-- Jednocześnie user_profiles.id musi być unikalny (klucz główny).
-- Nie da się dodać więcej niż jednego profilu dla jednego użytkownika – relacja ściśle 1:1.

insert into users (username)
values ('u'),
       ('a');

insert into user_profile (id, full_name, bio)
values (1, 'user', 'user bio'),
       (2, 'admin', 'admin bio');

insert into user_profile (id, full_name, bio)
values
       (2, 'admin', 'admin 2 bio');

delete from users where id = 2;

 -- WERSJA 2 -> Osobny PRIMARY KEY + FOREIGN KEY z UNIQUE

 create table customers (
     id int primary key auto_increment,
     name varchar(100) not null,
     email varchar(100) not null
 );

create table customer_cards (
    id int primary key auto_increment,
    card_number int not null unique,
    expiry_date date not null,
    customer_id int not null unique,
    foreign key (customer_id) references customers(id) on delete cascade on update cascade
);

insert into customers (name, email)
values ('c1', 'c1@example.com'),
       ('c2', 'c2@example.com');

insert into customer_cards (card_number, expiry_date, customer_id)
values (111, '2025-01-08', 1),
       (111, '2025-01-08', 2);

delete from customers where id = 2;


/*
    Czym są parent table i child table?

    Parent table (tabela nadrzędna):
    To tabela, która zawiera klucz główny (PRIMARY KEY), do którego odnosi się klucz obcy w innej tabeli.
    Inaczej: tabela, do której "wskazuje" inna tabela.

    Child table (tabela podrzędna):
    To tabela, która zawiera klucz obcy (FOREIGN KEY) – czyli zależy od danych w tabeli nadrzędnej.
    Inaczej: tabela, która „odwołuje się” do innej tabeli.

    Relacja między nimi:
    Parent = dostarcza danych
    Child = zależy od nich i nie może istnieć niezależnie (w sensie logicznym lub technicznym)

    Przykład: players i teams
    Jeden zespół (teams) może mieć wielu graczy (players)
    Każdy gracz należy do jednej drużyny
    teams – parent table: zawiera id, do którego odnosi się players.team_id
    players – child table: zawiera klucz obcy team_id, który zależy od teams

    Przykład: users i user_profiles
    Każdy użytkownik ma dokładnie jeden profil
    users – parent table: posiada id (klucz główny)
    user_profiles – child table: jej id jest kluczem obcym wskazującym na users.id

    Przykład: customers i customer_cards
    Każdy klient ma dokładnie jedną kartę płatniczą
    customers – parent table: posiada id (klucz główny)
    customer_cards – child table: posiada customer_id jako klucz obcy wskazujący na customers.id
    i objęty ograniczeniem UNIQUE (dla wymuszenia relacji 1:1)

*/