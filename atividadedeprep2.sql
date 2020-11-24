create drop database atividadeprep2
use atividadeprep2

create table autores(
cod int not null,
nome varchar(100) null,
pais varchar(100) null,
biografia varchar(300) null 
primary key (cod)
)

create table clientes (
cod int not null,
nome varchar(100) null,
logradouro varchar(200) null,
numero int null,
telefone char(9) null
primary key (cod)
)


create table corredores(
cod int not null,
tipo varchar(100)
primary key (cod)
)

create table livros (
cod int not null,
cod_autor int not null,
cod_corredores int not null,
nome varchar(100) null,
pag int null,
idioma varchar(100) null
primary key (cod)
foreign key (cod_autor) references autores(cod),
foreign key (cod_corredores) references corredores(cod)
)

create table emprestimo( 
cod_cli int not null,
data datetime null,
cod_livro int not null,
primary key(cod_cli,cod_livro),
foreign key (cod_livro) references livros(cod),
foreign key (cod_cli) references clientes(cod)
)

-- Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)
select c.nome , convert(char(10), e.data, 103) as data_emprestimo
from clientes c, emprestimo e
where c.cod = e.cod_cli

-- Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor, ordenado pelo número de livros. Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.
select case when(len(a.nome)>25)
then
	substring(a.nome,1,13)

else
	a.nome
end as nome_autor, 
count(l.cod) as livros_publicados

from autores a, livros l
where a.cod = l.cod_autor
group by a.cod, a.nome
order by livros_publicados

-- Fazer uma consulta que retorne o nome do autor e o país de origem do livro com maior número de páginas cadastrados no sistema

SELECT a.cod, a.nome, a.pais
FROM livros l, autores a 
WHERE l.cod_autor = a.cod
    AND l.pag IN (
        SELECT MAX(l.pag)
        FROM livros l
    )

-- Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados

select distinct c.nome, concat(c.logradouro , ', nº', c.numero) as end_completo
from clientes c, emprestimo e
where c.cod = e.cod_cli
/*
Nome dos Clientes, sem repetir e, concatenados como
enderço_telefone, o logradouro, o numero e o telefone) dos
clientes que Não pegaram livros. Se o logradouro e o 
número forem nulos e o telefone não for nulo, mostrar só o telefone. Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. Se os três existirem, mostrar os três.
O telefone deve estar mascarado XXXXX-XXXX
*/

select distinct c.nome,

case when (((c.logradouro is null) and (c.numero is null) )and (c.telefone is not null))
then 
	substring(c.telefone,1,5) +'-'+ substring(c.telefone,6,9)
else
	case when(((c.logradouro is not null) and (c.numero is not null) )and (c.telefone is null))
	then
	concat(c.logradouro , ', nº', c.numero) 
	else
	concat(c.logradouro , ', nº', c.numero, +' TEL:'+substring(c.telefone,1,5) +'-'+ substring(c.telefone,6,9)) 
	end
end as endereco_telefone

from clientes c left outer join  emprestimo e
on c.cod = e.cod_cli
where e.cod_cli is null
-- Fazer uma consulta que retorne Quantos livros não foram emprestados

select count(l.cod) as livro_nao_emprestado
from livros l left outer join  emprestimo e
on l.cod = e.cod_livro
where e.cod_livro is null

-- Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro
select a.nome, c.tipo, count(l.cod) as qtd_livros
from autores a, corredores c, livros l
where a.cod = l.cod_autor
and l.cod_corredores = c.cod
group by c.cod,c.tipo,a.nome
order by qtd_livros
-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro, 
-- o total de dias que cada um está com o livro e, uma coluna que apresente, caso o número de dias seja superior a 4, 
-- apresente 'Atrasado', caso contrário, apresente 'No Prazo'
select c.nome, l.nome, datediff(day,e.data, '2012-05-18') as dias_emprestimo, 

case when((datediff(day, e.data, '2012-05-18')) > 4 )
then
  'Atrasado'
else
	'No Prazo'
end as status_emprestimo

from clientes c, livros l,  emprestimo e
where c.cod = e.cod_cli
and e.cod_livro = l.cod
and e.data<='2012-05-18'

-- Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor
select c.cod, c.tipo, count(l.cod) as qtd_livros
from corredores c, livros l
where c.cod = l.cod_corredores
group by c.cod,c.tipo
-- Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.
select a.nome
from autores a, livros l
where a.cod = l.cod_autor
group by a.cod, a.nome
having (count(l.cod)>=2)
-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais
select c.nome, l.nome
from clientes c, livros l,  emprestimo e
where c.cod = e.cod_cli
and e.cod_livro = l.cod
and e.data<='2012-05-18'
group by c.nome, l.nome, e.data
having datediff(day,e.data, '2012-05-18') >=7