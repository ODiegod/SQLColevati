create database palestra_diegod
go
use palestra_diegod
create table curso(
codigo_curso int not null,
nome varchar(70) not null,
sigla varchar(10) not null
primary key (codigo_curso)
)
go
create table alunos(
ra char(7) not null,
nome varchar(250) not null,
codigo_curso int not null,
foreign key (codigo_curso) references curso(codigo_curso),
primary key (ra)
)
go
create table palestrante(
codigo_palestrante int identity,
nome varchar(250) not null,
empresa varchar(100) not null,
primary key (codigo_palestrante)
)
go
create table palestra(
codigo_palestra int identity,
titulo varchar(max) not null,
carga_horaria int not null,
data_palestra datetime not null,
codigo_palestrante int not null,
foreign key (codigo_palestrante) references palestrante(codigo_palestrante),
primary key (codigo_palestra)
)
go
create table alunos_inscritos(
ra char(7) not null,
codigo_palestra int not null,
foreign key (ra) references alunos(ra),
foreign key (codigo_palestra) references palestra(codigo_palestra)
)
go
create table nao_alunos(
rg varchar(9) not null,
orgao_exp char(5) not null,
nome varchar(250) not null,
primary key(rg, orgao_exp)
)
go
create table nao_alunos_inscritos(
codigo_palestra int not null,
rg varchar(9) not null,
orgao_exp char(5) not null,
foreign key (codigo_palestra) references palestra(codigo_palestra),
foreign key (rg, orgao_exp) references nao_alunos(rg, orgao_exp)
)

create view v_palestra
as
select al.nome as nome_pessoa,
concat ('RA: ',al.ra) as num_documento,
pa.titulo as titulo_palestra,
pal.nome as nome_palestrante,
pa.carga_horaria as carga_horaria,
pa.data_palestra as data_palestra
from alunos al inner join alunos_inscritos ai
on al.ra = ai.ra inner join palestra pa
on ai.codigo_palestra = pa.codigo_palestra inner join palestrante pal
on pal.codigo_palestrante = pa.codigo_palestrante
union
select naoa.nome as nome_pessoa,
concat('Nº RG: ',naoa.rg, ', Orgao exp :',naoai.orgao_exp) as num_documento,
pa.titulo as titulo_palestra,
pal.nome as nome_palestrante,
pa.carga_horaria as carga_horaria,
pa.data_palestra as data_palestra
from nao_alunos naoa inner join nao_alunos_inscritos naoai
on naoa.rg = naoai.rg inner join palestra pa
on naoai.codigo_palestra = pa.codigo_palestra inner join palestrante pal
on pal.codigo_palestrante = pa.codigo_palestrante

select * from  v_palestra