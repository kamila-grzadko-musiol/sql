-- ------------------------------------------------------------------------------------------------------------------
-- ZARzĄDZANIE TABELA
-- ------------------------------------------------------------------------------------------------------------

-- CHECK pozwala ustawic warunek, ktory musi byc spelniony dla kazdej nowej lub aktualizowanej wartosci w kolumnie.

create table users (
    id int primary key auto_increment,
    name varchar(100) not null,
    surname varchar(100) not null,
    email varchar(100) not null,
    birth_year year check (birth_year <= 2000)
);

alter table users modify name varchar(100) check ( char_length(name) > 3 );

insert into users (name, surname, email, birth_year)
values ('A', 'A', 'A', 1999);

insert into users (name, surname, email, birth_year)
values ('A', 'A', 'A', 2020);

update users set birth_year= 2020 where id = 1;

-- mozesz nazywac constraints

create table users (
    id int primary key auto_increment,
    name varchar(100) not null,
    surname varchar(100) not null,
    email varchar(100) not null,
    birth_year year,
    constraint birth_year check (birth_year <= 2000),
    constraint name_check check (char_length(name) > 3)
);

-- możesz o zadbanie unikalności kombinacji wartości w kilku kolumnach

create table users (
    id int primary key auto_increment,
    name varchar(100) not null,
    surname varchar(100) not null,
    email varchar(100) not null,
    birth_year year,
    constraint birth_year check (birth_year <= 2000),
    constraint name_check check (char_length(name) > 3),
    constraint unique_name_surname unique (name, surname)
);

insert into users (name, surname, email, birth_year)
values ('Kama', 'Nowak', 'a', 1990);

insert into users (name, surname, email, birth_year)
values ('Kama', 'Kowal', 'a', 1990);

-- mozesz zmienic nazwe kolumny, ale dane i struktura pozostaja takie same

alter table users rename column surname to last_name;

-- jak dodac / usunac constraints do istniejacej tabeli
alter table users drop constraint name_check;
alter table users drop index unique_name_surname;

alter table users add constraint name_check check (char_length(name) > 3);
alter table users add constraint unique_name_surname unique (name, last_name);