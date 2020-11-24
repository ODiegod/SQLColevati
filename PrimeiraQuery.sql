CREATE DATABASE inst_financeira 

GO
USE inst_financeira	--Ativa a database inst_financeira
USE master -- Ativa a database master
--DROP DATABASE inst_financeira -- Descarta a database

-- CTRL + R abre e fecha as mensagens
--Comandos DDL (CREATE, ALTER, DROP)

-- Criar uma tabela
/*
CREATE TABLE nome (
atr1 tipo nulidade (Obrigatório not null/opicional null),
atr2 tipo nulidade,
...
atrN tipo nulidade
PRIMARY KEY (atr1,atr2)
)
*/
CREATE TABLE cliente (
cpf INT NOT NULL,
nome VARCHAR(100) NOT NULL,
logradouro VARCHAR(200) NOT NULL,
numero INT NOT NULL,
cep CHAR(8) NOT NULL,
complemento VARCHAR(255) NULL,
dt_nasc DATE NOT NULL
primary key (cpf)
)

--Informações da Tabela
--exec sp_help nome_tabela
exec sp_help cliente

CREATE TABLE Cliente_Tel(
cliente_cpf int not null,
telefone char(9) not null
primary key (cliente_cpf, telefone)
foreign key (cliente_cpf) references cliente(cpf)
)

create table conta (
saldo decimal(9,2)
)

--alter table nome
--add,alter column, drop column, add pk, add fk
alter table conta
add numero_conta int not null

alter table conta
drop column numero_conta


alter table conta
alter column saldo decimal(7,2) not null

alter table conta
add data_conta date not null

alter table conta 
add primary key (numero_conta)

exec sp_rename 'dbo.conta.saldo', 'saldo_conta', 'column'
exec sp_rename 'dbo.cliente_tel', 'cliente_telefone'

drop table conta