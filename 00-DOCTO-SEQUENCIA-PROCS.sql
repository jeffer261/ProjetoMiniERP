--SEQUENCIA DE PROCUDURES
--PROCEDURE PARA PLANEJAR ORDEM DE PRODUCAO COM BASE EM PEDIDO DE VENDAS
--PARAMETROS @MES @NO
--TABELAS ORIGEM PED_VENDAS,PED_VENDAS_ITEM
--TABELA DESTINO ORDEM_PROD
EXEC PROC_PLAN_ORDEM 12,2017

--PROCEDURE PARA CRIAR PEDIDO DE COMPRAS COM BASE NECECISSIDADES
--PARAMETROS @MES @ANO
--TABELAS ORIGEM  ORDEM_PROD
--TABELAS NECESSARIAS, FICHA_TECNICA, MATERIAL, FORNECEDORES
--TABELAS DESTINO PED_COMPRAS, PED_COMPRAS_ITEM
EXEC PROC_GER_PED_COMPRAS 10,2017
--PROCEDURE ESTOQUE
--ORIGEM IMPUTS NF SAIDA, NF ENTRADA , APONT PRODUCAO
--DESTINO ESTOQUE, ESTOQUE_LOTE,ESTOQUE_MOV
--PARAMETROS
--@TIPO_MOV, @COD_MAT,@LOTE, @QTD_MOV,@DATA_MOVTO
EXEC PROC_GERA_ESTOQUE 

--PROC_GERA_NF
--TABELAS ORIGEM PED_VENDAS, PED_VENDAS_ITENS, PED_COMPRAS, PED_COMPRAS_ITENS
--TABELAS DESTINO NOTA_FISCAL, NOTA_FISCAL_ITENS
--PARAMETROS @TIP_MOV,@DOCTO,@CFOP,@DATA_EMIS,@DATA_ENTREGA
--EXEC PROC_GERA_NF 'E',8,'5.101','2017-01-30','2017-01-30'
EXEC PROC_GERA_NF 


--INTEGRA QTD NFES COM ESTOQUE
--PARAMETROS @NUM_NF,@DATA_MOVTO
--EXECUTE PROC_INTEGR_NF_ESTOQUE 8,'2017-01-30'
--LE TABELAS DE NOTA_FISCAL,NOTA_FISCAL_ITENS
--VERIFICA SALDOS ESTOQUE_LOTE X QTD DA NOTA ITENS
--REUTILIZA A PROCECEDURE PROC_GERA_ESTOQUE PARA ATUALIAR ESTOQUE
EXEC PROC_INTEGR_NF_ESTOQUE 

--PROCEDURE INTEGRA CAP E CRE
--ORIGEM NOTA_FISCAL ENTRADA SAIDA
--SE SAIDA DESTINO CONTAS A RECEBER
--SE ENTRADA DESTINO CONTAS A PAGAR
--SEM PARAMENTROS EXTEROS, APENAS INTERNOS
EXEC PROC_INTEGR_FIN

--PROCEDURE PRODUCAO
--GERA MOVIMENTA DE ENTRADA ESTOQUE DO PRODUTO APONTADO
--GERA MOVIMENTO DE SAIDA ESTOQUE DOS PRODUTOS CONSUMIDOS
--ALIMENTA TABELA CONSUMO PARA RASTREABILIDADE
--ALIMENTA TABELA APONTAMENTO PARA RASTREABILIDADE
--ATUALIZA TABELAS ORDEM_PROD QTD_PROD E SITUACAO=F FINALIZADO , QUANDO QTD_PLAN=QTD_PROD
--PARAMENTROS, ID_ORDEM,COD_MAT_PROD,QTD_APONT, LOTE
--CONSISTENCIAS DE ESTOQUE
EXEC PROC_APONTAMENTO 24,2,10,ABC
--TO AQUI
--PROCEDURE FOLHA PGTO
--GERA INFORMACOES PARA PAGAMENTO
--TABELAS ORIGEM SALARIO
--TAB PARAMENTROS, PARAM_INSS, PARAM_IRRF
--TABELAS DESTINO FOLHA PAGTO
--PARAMETROS, MES_REF, ANO_REF,DATA_PAGTO
EXEC PROC_FOLHA 1,2017,'2017-02-05'

--TRIGGER BLOQUEIA USUARIO DEMITIDO

TG_BLOQUEIA_USUARIO

--TRIGGER AUDITORIA SALARIO

TG_AUDIT_SAL


--VERIFICANDO TABELAS POPULADAS
 SELECT OBJECT_NAME(OBJECT_ID) TableName, st.row_count
 FROM sys.dm_db_partition_stats st
 WHERE index_id < 2
 ORDER BY st.row_count DESC


