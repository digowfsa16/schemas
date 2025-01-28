Qual o departamento com maior número de pessoas?


SELECT departamento_id, COUNT(*) AS total_pessoas
FROM empregados
GROUP BY departamento_id
ORDER BY total_pessoas DESC
LIMIT 1;


Quais são os departamentos por cidade?

  SELECT d.departamento_id, d.nome AS nome_departamento, c.nome AS cidade
FROM departamentos d
JOIN cidades c ON d.cidade_id = c.cidade_id;



Relação de empregados por departamento

SELECT d.departamento_id, d.nome AS nome_departamento, e.nome AS nome_empregado
FROM departamentos d
JOIN empregados e ON d.departamento_id = e.departamento_id
ORDER BY d.departamento_id;

CRIANDO INDICES:

  
Tabela empregados

CREATE INDEX index_departamento_id ON empregados(departamento_id);
Motivo: O índice no campo departamento_id será útil para acelerar o agrupamento e filtragem relacionados aos departamentos.

  
Tabela departamentos

CREATE INDEX index_departamento_cidade_id ON departamentos(cidade_id);
CREATE INDEX index_departamento_id ON departamentos(departamento_id);

Motivo:
O índice em cidade_id será útil para o join com a tabela cidades.
O índice em departamento_id otimiza o join com a tabela empregados.

  
Tabela cidades

CREATE INDEX index_cidade_id ON cidades(cidade_id);
Motivo: O índice em cidade_id acelera o acesso às informações de cidades ao fazer o join.

PROCEDURA ( FUNCIONA COMO SE FOSSE UMA FUNÇÃO ) 

  DELIMITER //

CREATE PROCEDURE ManipulaDados(
    IN acao INT, -- Variável de controle: 1 (INSERT), 2 (UPDATE), 3 (DELETE)
    IN tabela VARCHAR(50), -- Nome da tabela
    IN id INT, -- ID do registro (para UPDATE e DELETE)
    IN campo1 VARCHAR(100), -- Dados do primeiro campo (exemplo)
    IN campo2 VARCHAR(100)  -- Dados do segundo campo (exemplo)
)
BEGIN
    CASE acao
        WHEN 1 THEN -- Inserção de dados
            IF tabela = 'empregados' THEN
                INSERT INTO empregados (nome, departamento_id) VALUES (campo1, campo2);
            ELSEIF tabela = 'departamentos' THEN
                INSERT INTO departamentos (nome, cidade_id) VALUES (campo1, campo2);
            END IF;

        WHEN 2 THEN -- Atualização de dados
            IF tabela = 'empregados' THEN
                UPDATE empregados SET nome = campo1, departamento_id = campo2 WHERE empregado_id = id;
            ELSEIF tabela = 'departamentos' THEN
                UPDATE departamentos SET nome = campo1, cidade_id = campo2 WHERE departamento_id = id;
            END IF;

        WHEN 3 THEN -- Remoção de dados
            IF tabela = 'empregados' THEN
                DELETE FROM empregados WHERE empregado_id = id;
            ELSEIF tabela = 'departamentos' THEN
                DELETE FROM departamentos WHERE departamento_id = id;
            END IF;
    END CASE;
END;
//

DELIMITER ;


ExemploS de chamada da  PROCEDURE

  
Inserir um novo empregado:
CALL ManipulaDados(1, 'empregados', NULL, 'João Silva', '3');


Atualizar um departamento:
CALL ManipulaDados(2, 'departamentos', 1, 'Recursos Humanos', '2');

Remover um empregado:
CALL ManipulaDados(3, 'empregados', 5, NULL, NULL);



  
