use aulajoin10

select * from alunos
select * from materias
select * from avaliacoes
select * from notas ORDER by id_materia, id_avaliacao
select * from alunomateria

--Func�es
--CAST('12' AS INT), SUBSTRING, DATEDIFF, GETDATE...

--Fun��es de Agrega��o
--SUM()   Soma dos valores das linhas de uma coluna
--AVG()   M�dia dos valores das linhas de uma coluna
--COUNT() Quantidade de linhas de uma coluna
--MAX()   Valor m�ximo encontrado na coluna  // Se for char, ordena a coluna ASC e retorna ultimo resultado 
--MIN()   Valor minimo encontrado na coluna  // Se for char, ordena a coluna ASC e retorna primeiro resultado 


--GROUP BY  - Agrupar linhasd de um select por uma dada cl�usula 
--A func�o de agrega��o ser� aplicada nos grupos definidos pela cl�usula 

--HAVING - Tem a mesma func��o do WHERE para aplica��o de fun��es de agrega��o

--User Defined Functions (LabBD) 

--Consultar a m�dia das notas de cada avalia��o por mat�ria

--Consultar a m�dia das notas de cada avalia��o por mat�ria

SELECT m.nome, av.tipo, CAST(AVG(n.nota) AS DECIMAL(7,2)) AS M�dia
FROM materias m INNER JOIN notas n
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
GROUP BY m.nome, av.tipo
ORDER BY m.nome, av.tipo

SELECT m.nome, av.tipo, CAST(AVG(n.nota) AS DECIMAL(7,2)) AS M�dia
FROM materias m, notas n, avaliacoes av
WHERE m.id = n.id_materia
	AND av.id = n.id_avaliacao
GROUP BY m.nome, av.tipo
ORDER BY m.nome, av.tipo


--Consultar o RA do aluno (mascarado), a nota final dos alunos, 
--de alguma mat�ria e uma coluna conceito 
--(aprovado caso nota >= 6, reprovado, caso contr�rio)
SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra,
	a.nome,
	CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final, 
	CASE WHEN(SUM(av.peso * n.nota) >= 6.0)
		THEN
			'AP'
		ELSE
			'RN'
		END AS conceito
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
INNER JOIN materias m
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
WHERE m.nome = 'Banco de Dados'
--	AND a.ra LIKE '1520126%'
GROUP BY ra, a.nome
ORDER BY a.nome

SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra,
	a.nome,
	CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final,
	CASE WHEN(SUM(av.peso * n.nota) >= 6.0)
		THEN
			'AP'
		ELSE
			'RN'
		END AS conceito
FROM alunos a, notas n, materias m, avaliacoes av
WHERE a.ra = n.ra_aluno
	AND m.id = n.id_materia
	AND av.id = n.id_avaliacao
	AND m.nome = 'Banco de Dados'
	--AND a.ra LIKE '1520126%'
GROUP BY a.ra, a.nome
ORDER BY a.nome


--Consultar nome da mat�ria e quantos alunos est�o matriculados
SELECT m.nome, COUNT(a.nome) AS total_alunos
FROM alunos a, alunomateria am, materias m
WHERE a.ra = am.ra_aluno
	AND m.id = am.id_materia
GROUP BY m.nome
ORDER BY m.nome

SELECT m.nome, COUNT(a.nome) AS total_alunos
FROM alunos a INNER JOIN alunomateria am
ON a.ra = am.ra_aluno
INNER JOIN materias m
ON m.id = am.id_materia
GROUP BY m.nome
ORDER BY m.nome


--Consultar quantos alunos n�o est�o matriculados
SELECT COUNT(a.nome) AS nao_matriculados
FROM alunos a LEFT OUTER JOIN alunomateria am
ON a.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL

SELECT COUNT(a.nome) AS nao_matriculados
FROM alunomateria am RIGHT OUTER JOIN alunos a
ON a.ra = am.ra_aluno
WHERE am.ra_aluno IS NULL

--Consultar quais alunos est�o aprovados em alguma mat�ria 
--(nota final >= 6,0)
SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra,
	a.nome
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
INNER JOIN materias m
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
WHERE m.nome LIKE 'Arq%'
GROUP BY a.ra, a.nome
HAVING SUM(av.peso * n.nota) > 6.0
ORDER BY a.nome


--Consultar quantos alunos est�o reprovados em cada mat�rias 
--(nota final < 6,0)
SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra, a.nome
FROM alunos a
WHERE a.ra IN
(
SELECT a.ra
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
INNER JOIN materias m
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
WHERE m.nome LIKE 'Arq%'
GROUP BY a.ra, a.nome
HAVING SUM(av.peso * n.nota) < 6.0
)
ORDER BY nome

SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra, a.nome
FROM alunos a
WHERE a.ra NOT IN
(
SELECT a.ra
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
INNER JOIN materias m
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
WHERE m.nome LIKE 'Arq%'
GROUP BY a.ra, a.nome
HAVING SUM(av.peso * n.nota) >= 6.0
)
ORDER BY nome

SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra, a.nome
FROM alunos a
WHERE a.ra IN
(
SELECT a.ra
FROM alunos a, notas n, materias m, avaliacoes av 
WHERE a.ra = n.ra_aluno
	AND m.id = n.id_materia
	AND av.id = n.id_avaliacao
	AND m.nome LIKE 'Arq%'
GROUP BY a.ra, a.nome
HAVING SUM(av.peso * n.nota) < 6.0
)
ORDER BY nome

--Consultar a menor nota de alguma avalia��o de alguma mat�ria
SELECT MIN(n.nota) AS menor_nota
FROM materias m INNER JOIN notas n
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
WHERE av.tipo = 'P1' 
	AND m.nome = 'Banco de Dados'

SELECT MIN(n.nota) AS menor_nota
FROM materias m, notas n, avaliacoes av
WHERE m.id = n.id_materia
	AND av.id = n.id_avaliacao
	AND av.tipo = 'P1' 
	AND m.nome = 'Banco de Dados'
-- Montar a seguinte tabela de sa�da:
--(ra formatado, nome, nota)
--para os alunos que tem a maior e a menor 
--nota de uma disciplina e 
--uma avalia��o a definir na clausula WHERE.
SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra, 
	a.nome, n.nota
FROM notas n, alunos a
WHERE a.ra = n.ra_aluno
	AND (
	n.nota IN
(
SELECT MIN(n.nota)
FROM materias m, notas n, avaliacoes av, alunos a
WHERE m.id = n.id_materia
	AND av.id = n.id_avaliacao
	AND av.tipo = 'P1' 
	AND m.nome = 'Banco de Dados'
)
	OR n.nota IN
(
SELECT MAX(n.nota)
FROM materias m, notas n, avaliacoes av, alunos a
WHERE m.id = n.id_materia
	AND av.id = n.id_avaliacao
	AND av.tipo = 'P1' 
	AND m.nome = 'Banco de Dados'
)
)
ORDER BY n.nota, a.nome

--Montar a seguinte tabela de sa�da:
--(ra formatado, nome, nota_final, conceito, 
--faltante(quanto faltou para passar (null 
--para aprovados)), min_exame (quanto precisa 
--tirar no exame para passar (null para 
--alunos com notas maior que 6,0 e menor que
--3,0)))
--C�lculo do exame final:
--(nota_final + nota_exame) / 2 >= 6
SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra,
	a.nome,
	CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final, 
	CASE WHEN(SUM(av.peso * n.nota) >= 6.0)
		THEN
			'AP'
		ELSE
			'RN'
	END AS conceito,
	CASE WHEN(SUM(av.peso * n.nota) >= 6.0)
		THEN 
			NULL
		ELSE 
			CAST(6.0 - SUM(av.peso * n.nota) AS DECIMAL(7,1))
	END AS faltante,
	CASE WHEN (SUM(av.peso * n.nota) >= 6.0 OR SUM(av.peso * n.nota) < 3.0)
		THEN
			NULL
		ELSE
			CAST(12.0 - SUM(av.peso * n.nota) AS DECIMAL(7,1))
	END AS min_exame
FROM alunos a INNER JOIN notas n
ON a.ra = n.ra_aluno
INNER JOIN materias m
ON m.id = n.id_materia
INNER JOIN avaliacoes av
ON av.id = n.id_avaliacao
WHERE m.nome = 'Banco de Dados'
GROUP BY ra, a.nome
ORDER BY a.nome


SELECT SUBSTRING(a.ra,1,9)+'-'+SUBSTRING(a.ra,10,1) AS ra,
	a.nome,
	CAST(SUM(av.peso * n.nota) AS DECIMAL(7,1)) AS nota_final, 
	CASE WHEN(SUM(av.peso * n.nota) >= 6.0)
		THEN
			'AP'
		ELSE
			'RN'
	END AS conceito,
	CASE WHEN(SUM(av.peso * n.nota) >= 6.0)
		THEN 
			NULL
		ELSE 
			CAST(6.0 - SUM(av.peso * n.nota) AS DECIMAL(7,1))
	END AS faltante,
	CASE WHEN (SUM(av.peso * n.nota) >= 6.0 OR SUM(av.peso * n.nota) < 3.0)
		THEN
			NULL
		ELSE
			CAST(12.0 - SUM(av.peso * n.nota) AS DECIMAL(7,1))
	END AS min_exame
FROM alunos a, notas n, materias m, avaliacoes av
WHERE a.ra = n.ra_aluno
	AND m.id = n.id_materia
	AND av.id = n.id_avaliacao
	AND m.nome = 'Banco de Dados'
GROUP BY ra, a.nome
ORDER BY a.nome