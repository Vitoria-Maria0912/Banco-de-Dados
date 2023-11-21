/*Revisado pelo professor*/

-- CLIENTES

CREATE TABLE CLIENTE (
    CODCLI          INTEGER,
    CPF             CHAR(11),
    NOME            VARCHAR(60) NOT NULL,
    SOBRENOME       VARCHAR(60) NOT NULL,
    EMAIL           VARCHAR(160) NOT NULL,
    DATA_NASCIMENTO DATE NOT NULL,
    PONTOS          NUMBER DEFAULT 0,
    SEXO            VARCHAR(9),
    END_RUA         VARCHAR(50),
    END_NUM         CHAR(5),
    END_BAIRRO      CHAR(20),
    END_CIDADE      CHAR(30),
    END_CEP         CHAR(8),
    DATA_INDICACAO  DATE,
    CLIENTE_INDICA  INTEGER,
    CONSTRAINT CLIENTE_PK         PRIMARY KEY (CODCLI)
);

ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_INDICA_FK FOREIGN KEY (CLIENTE_INDICA) REFERENCES CLIENTE(CODCLI);

-- TELEFONES CLIENTE
CREATE TABLE TELEFONES_CLIENTE (
    COD_CLI  INTEGER,
    NUMERO   CHAR(12) NOT NULL,
    CONSTRAINT CLIENTE_TELEFONE_PK  PRIMARY KEY (COD_CLI, NUMERO), 
    CONSTRAINT CODIGO_CLIENTE_FK    FOREIGN KEY (COD_CLI) REFERENCES CLIENTE(CODCLI)
);

-- TRANSPORTADORA
CREATE TABLE TRANSPORTADORA (
  CODTRANS    INTEGER,
  NOME      VARCHAR(160) NOT NULL,
  EMAIL     VARCHAR(160),
  TELEFONE  CHAR(12),
  SITE      VARCHAR(160),
  END_RUA         VARCHAR(50),
  END_NUM         CHAR(5),
  END_BAIRRO      CHAR(20),
  END_CIDADE      CHAR(30),
  END_CEP         CHAR(8),
  CONSTRAINT TRANSPORTADORA_PK PRIMARY KEY (CODTRANS)
);

-- FORNECEDOR
CREATE TABLE FORNECEDOR (
  CODFORN          INTEGER,
  CNPJ            CHAR(15),
  NOME            VARCHAR(50) NOT NULL,
  HOME_PAGE       VARCHAR(50),
  EMAIL           VARCHAR(160),
  TELEFONE        CHAR(12),
  END_RUA         VARCHAR(50),
  END_NUM         CHAR(5),
  END_BAIRRO      CHAR(20),
  END_CIDADE      CHAR(30),
  END_CEP         CHAR(8),
  CONSTRAINT FORNECEDOR_PK PRIMARY KEY (CODFORN)
);

-- CATEGORIA
CREATE TABLE CATEGORIA (
  CODCAT  INTEGER,
  NOME    VARCHAR(50) NOT NULL,
  CONSTRAINT CATEGORIA_PK PRIMARY KEY (CODCAT)
);

-- PRODUTO
CREATE TABLE PRODUTO (
  CODPROD INTEGER,
  NOME VARCHAR2(200) NOT NULL,
  PRECO_COMPRA NUMBER(11,2) NOT NULL,
  PRECO_VENDA NUMBER(11,2) NOT NULL,
  DATA_FABRICACAO DATE NOT NULL,
  DESCRICAO VARCHAR(1000),
  ESPECIFICACAO VARCHAR(2000),
  DATA_VALIDADE DATE NOT NULL,
  COD_CATEGORIA INTEGER NOT NULL,
  QUANTIDADE INTEGER DEFAULT 0 NOT NULL,
  CONSTRAINT CODIGO_PRODUTO_PK PRIMARY KEY (CODPROD),
  CONSTRAINT CODIGO_CATEGORIA_PRODUTO_FK FOREIGN KEY (COD_CATEGORIA) REFERENCES CATEGORIA(CODCAT)
);

-- FORNECIMENTO
CREATE TABLE FORNECIMENTO (
  CODIGO_PRODUTO    INTEGER,
  CODIGO_FORNECEDOR INTEGER,
  CONSTRAINT FORNECEDOR_FORNECE_PRODUTO_PK  PRIMARY KEY (CODIGO_PRODUTO, CODIGO_FORNECEDOR),
  CONSTRAINT CODIGO_PRODUTO_FORNECE_FK      FOREIGN KEY (CODIGO_PRODUTO) REFERENCES PRODUTO(CODPROD),
  CONSTRAINT CODIGO_FORNECEDOR_FORNECE_FK   FOREIGN KEY (CODIGO_FORNECEDOR) REFERENCES FORNECEDOR(CODFORN)
);

-- ORDEM DE COMPRA
CREATE TABLE ORDEM_DE_COMPRA (
  CODORDEM                 INTEGER,
  DATA_COMPRA             DATE DEFAULT SYSDATE NOT NULL,
  STATUS                  VARCHAR(20) DEFAULT 'AGUARDANDO PAGAMENTO' NOT NULL,
  DESCONTO                NUMBER(6,2),
  VALOR_FRETE             NUMBER(10,2) NOT NULL, 
  END_RUA         VARCHAR(50),
  END_NUM         CHAR(5),
  END_BAIRRO      CHAR(20),
  END_CIDADE      CHAR(30),
  END_CEP         CHAR(8),
  CODIGO_CLIENTE          INTEGER NOT NULL,
  CODIGO_TRANSPORTADORA   INTEGER NOT NULL,
  CONSTRAINT ORDEM_DE_COMPRA_PK               PRIMARY KEY (CODORDEM),
  CONSTRAINT CODIGO_CLIENTE_COMPRA_FK         FOREIGN KEY (CODIGO_CLIENTE)        REFERENCES CLIENTE(CODCLI),
  CONSTRAINT CODIGO_TRANSPORTADORA_COMPRA_FK  FOREIGN KEY (CODIGO_TRANSPORTADORA) REFERENCES TRANSPORTADORA(CODTRANS),
  CONSTRAINT CHECK_STATUS  CHECK (STATUS IN ('AGUARDANDO PAGAMENTO', 'EM SEPARACAO', 'EM TRANSPORTE', 'FINALIZADA')) 
);

-- NOTA FISCAL
CREATE TABLE NOTA_FISCAL (
  CODNF             INTEGER,
  NUMERO              VARCHAR(50) NOT NULL,
  SERIE               VARCHAR(50) NOT NULL,
  INSCRICAO_ESTADUAL  VARCHAR(50) NOT NULL,
  CHAVE_ACESSO        VARCHAR(160) NOT NULL,
  DATA_NF             DATE NOT NULL,
  VALOR_TOTAL         NUMBER(11,2) NOT NULL,
  COD_ORDEM_COMPRA     INTEGER,
  CONSTRAINT NOTA_FISCAL_PK PRIMARY KEY(CODNF),
  CONSTRAINT CODIGO_ORDEM_DE_COMPRA_FK     FOREIGN KEY (COD_ORDEM_COMPRA)    REFERENCES ORDEM_DE_COMPRA(CODORDEM)
);

-- ORDEM DE COMPRA PRODUTO
CREATE TABLE COMPRA_PRODUTO (
  CODIGO_COMPRA   INTEGER,
  CODIGO_PRODUTO  INTEGER,
  QUANTIDADE      INTEGER DEFAULT 0 NOT NULL,
  VALOR_ATUAL     NUMBER(11,2) NOT NULL,
  CONSTRAINT COMPRA_PRODUTO_PK PRIMARY KEY(CODIGO_COMPRA, CODIGO_PRODUTO),
  CONSTRAINT COMPRA_PRODUTO_FK FOREIGN KEY(CODIGO_COMPRA)   REFERENCES ORDEM_DE_COMPRA(CODORDEM),
  CONSTRAINT PRODUTO_COMPRA_FK FOREIGN KEY(CODIGO_PRODUTO)  REFERENCES PRODUTO(CODPROD)
);

-- ORDEM DE COMPRA AVALIA PRODUTO
CREATE TABLE COMPRA_AVALIA_PRODUTO (
  CODIGO_COMPRA   INTEGER,
  CODIGO_PRODUTO  INTEGER,
  NOTA            NUMBER(1,0) DEFAULT 0 NOT NULL,
  DESCRICAO       VARCHAR2(2000),
  CONSTRAINT AVALIA_PRODUTO_PK PRIMARY KEY(CODIGO_COMPRA, CODIGO_PRODUTO),
  CONSTRAINT AVALIA_PRODUTO_FK FOREIGN KEY(CODIGO_COMPRA)   REFERENCES ORDEM_DE_COMPRA(CODORDEM),
  CONSTRAINT PRODUTO_AVALIA_FK FOREIGN KEY(CODIGO_PRODUTO)  REFERENCES PRODUTO(CODPROD)
);

-- CRIAR AS SEQUENCIAS :
CREATE SEQUENCE CLIENTE_SEQ MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCYCLE;
CREATE SEQUENCE TRANSPORTADORA_SEQ MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCYCLE;
CREATE SEQUENCE FORNECEDOR_SEQ MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCYCLE;
CREATE SEQUENCE CATEGORIA_SEQ MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCYCLE;
CREATE SEQUENCE NOTA_FISCAl_SEQ MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCYCLE;
CREATE SEQUENCE PRODUTO_SEQ MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCYCLE;
CREATE SEQUENCE ORDEM_DE_COMPRA_SEQ MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 NOCYCLE;