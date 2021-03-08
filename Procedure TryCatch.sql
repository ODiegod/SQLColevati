create database empresa
go
use empresa

create table produto(
Codigo int,
Nome varchar(80), 
Valor decimal(7,2)
primary key(codigo)
)

create table entrada(
Codigo_Transacao int ,
Codigo_Produto int,
Quantidade int,
Valor_total decimal(7,2)
primary key(Codigo_Transacao)
)

create table saida(
Codigo_Transacao int ,
Codigo_Produto int,
Quantidade int,
Valor_total decimal(7,2)
primary key(Codigo_Transacao)
)



create procedure sp_transacao(@codigo char(1), @codigo_transacao int, @codigo_produto int, @quantidade int, @valor_total decimal(7,2))
AS
declare @tabela varchar(8)
declare @query varchar(max)
declare @erro varchar(max)
    if (@codigo = 'e')
        begin
            set @tabela = 'entrada'
        end
    else
        begin
        if (@codigo = 's')
           begin
                set @tabela = 'saida'
            end
        else
            begin
                raiserror('Codigo de transacao invalido', 16, 1)
            end
        end
    set @query = 'insert into '+@tabela+' values ('+cast(+@codigo_transacao as varchar(5))+','+cast(+@codigo_produto as varchar(5))+','+cast(+@quantidade as varchar(5))+','+cast(+@valor_total as varchar(7))+')'
    begin try
        exec (@query)
    end try
    begin catch
        set @erro = ERROR_MESSAGE()
        if (@erro LIKE '%primary%')
            begin
                raiserror('Chave primaria duplicada', 16, 1)
            end
        else
            begin
                raiserror('Erro de processamento', 16, 1) 
            end
    end catch

	exec sp_transacao 's',85,64,4,420.69

	select * from entrada
	select * from saida







