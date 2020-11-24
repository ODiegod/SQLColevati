create database livraria
go 
use livraria

create table livro(
codigo_livro int			not null,
nome varchar(100)			null,
lingua varchar(100)			null,
ano  int					null,
primary key(codigo_livro)
)

CREATE TABLE livro_autor (
livrocodigo_livro INT		NOT NULL,
autorcodigo_autor INT		NOT NULL
PRIMARY KEY(livrocodigo_livro, AutorCodigo_Autor)
FOREIGN KEY (autorcodigo_autor) REFERENCES autor(Codigo_Autor),
FOREIGN KEY (livrocodigo_livro) REFERENCES livro(Codigo_Livro)
)

create table autor(
codigo_autor int			not null,
nome varchar (100)			null,
nascimento date				null,
pais varchar(50)			null,
biografia varchar(max)		null
primary key(codigo_autor)
)

create table edicoes(
isbn int					not null,
preco decimal(7,2)			null,
ano int						null,
num_paginas int				null,
qtd_estoque int				null
primary key(isbn)
)

create table editora(
codigo_editora int			not null,
nome varchar(50)			null,
logradouro varchar(255)		null,
numero int					null,
cep char(8)					null,
telefone char(11)			null
primary key(codigo_editora)
)

create table livro_edicoes_editoras(
isbn int				not null,
codigo_editora int		not null,
codigo_livro int		not null 
primary key(isbn, codigo_editora,codigo_livro)
foreign key (isbn) references edicoes(isbn),
foreign key (codigo_editora) references editora(codigo_editora),
foreign key (codigo_livro) references livro(codigo_livro)
)

/*
Modificar nome de tablea e coluna
exec sp_rename tabela, novo_nome 'column' 
*/
exec sp_rename 'dbo.edicoes.ano', 'anoedicao', 'column'

--Alterar nome da coluna
alter table editora
alter column nome varchar(30) not null

--Trocar nascimento para ano e deixar int
alter table autor
drop column nascimento

alter table autor
add ano int not null

--Inserir dados

insert into autor(codigo_autor,nome,ano,pais,biografia)
values
(10001,'Inácio da Silva', 1975,'Brasil','Programador WEB desde 1995'),
(10002,'Andrew Tannenbaum',1994,'EUA', 'Chefe do Depertamento de Sistemas de Computação na Universiadade de Vrij'),
(10003,'Luis Roccha',1967,'Brasil','Programador Mobile desde 2000'),
(10004,'David Halliday',1916,'EUA','Fisico PH.D desde 1941')


insert into livro(codigo_livro,nome,lingua,ano)
values(
1001,'CCNA 4.1','pt-br',2015),
(1002,'HTML5','pt-br',2017),
(1003,'Redes de Computadores','en',2010),
(1004,'Android em Ação','pt-br',2018)

insert into livro_autor
values
(1001,10001),
(1002,10002),
(1003,10003),
(1004,10004)

insert into edicoes(isbn,preco,anoedicao,num_paginas,qtd_estoque)
values (0130661023,189.99,2018,653,10)

update autor
set biografia=('Chefe do Depertamento de Sistemas de Computação na Universiadade de Vrije')
where codigo_autor = 10002

update edicoes
set qtd_estoque= qtd_estoque-2
where isbn = 0130661023


delete autor 
where nome = 'David Halliday'