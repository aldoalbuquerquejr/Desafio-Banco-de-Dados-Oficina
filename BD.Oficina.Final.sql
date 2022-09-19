-- Oficina

-- CRIANDO TABELAS E PERSISTINDO VALORES


use Oficina;
show tables;
drop table Cliente;

-- Criando e persistindo valores em Cliente
create table Cliente (
	idCliente int auto_increment primary key,
    Nome varchar(45),
    Sobrenome varchar(45),
    CPF char(11) not null,
    Endereço varchar(100),
    Contato char(11),
    constraint CPF_Unico unique (CPF)
);

insert into Cliente (idCliente, Nome, Sobrenome, CPF, Endereço, Contato)
			values (1, "João", "Silva", 09278654365, "Tal Rua, Nº 13", 99873465434),
                   (2, "Nadia", "Albuquerque", 98709854365, "Rua Krasnodar", 98786532432),
                   (3, "Alina", "Albuquerque", 78095647654, "Rua Moskow", 97879765435);

-- Criando e persistindo valores em Peças
create table Pecas (
	idPecas int auto_increment primary key,
    Nome varchar(45),
    Descrição varchar(45),
    Quantidade int not null,
    Valor float
);

insert into Pecas (idPecas, Nome, Descrição, Quantidade, Valor)
			values (1, "Correia", "Correia de Borracha", 7, 51.0),
                   (2, "Retrvisor", "Retrovisor Vision", 6, 150),
                   (3, "Limpador de Parabrisa", "Limpador de Parabrisa Landscape", 6, 100);

-- Criando e persistindo valores em Serviços
create table Servicos (
	idServicos int auto_increment primary key,
    Descrição varchar(100),
    Valor float
);

insert into Servicos (idServicos, Descrição, Valor)
			values (1, "Substituição de peça", 50.0),
                   (2, "Troca de óleo", 25.0),
                   (3, "Revisão geral", 200.0);

-- Criando e persistindo valores em Mecânico 
create table Mecanico (
	idMecanico int auto_increment primary key,
    Nome varchar(45),
    Sobrenome varchar(45),
    CPF char(11) not null,
    Endereço varchar(100),
    Contato char(11),
    Especialidade varchar(45),
    constraint CPF_Unico unique (CPF)
);

insert into Mecanico (idMecanico, Nome, Sobrenome, CPF, Endereço, Contato, Especialidade)
			values (1, "José", "Siqueira", 07986546543, "Rua Específica", 97865412122, "Revisão Geral"),
                   (2, "Antônio", "Nunes", 98076587921, "Rua Esquerda", 99893243454, "Troca de óleo"),
                   (3, "Carlos", "Augusto", 78904565643, "Rua Direita", 97890954543, "Substituiçao de peça");

-- Criando e persistindo valores em Ordem de Serviço 
create table Ordem_Servico (
	idOrdem_Servico int auto_increment primary key,
    idOrdem_Servico_Mecanico int,
    Data_Emissao varchar(100),
    Data_Entrega varchar(100),
    Valor float,
    Status_Ordem_Servico enum("A confirmar", "Confirmado","Em execução", "Finalizado"),
    constraint fk_Ord_Ser_Mec foreign key (idOrdem_Servico_Mecanico) references Mecanico(idMecanico)
);

insert into Ordem_Servico (idOrdem_Servico, idOrdem_Servico_Mecanico, Data_Emissao, Data_Entrega, Valor, Status_Ordem_Servico)
			values (1, 3, "18/08/2022", "22/08/2022", 50.0, "Em execução"),
                   (2, 2, "10/08/2022", "10/08/2022", 25.5, "Finalizado"),
                   (3, 1, "18/08/2022", "23/08/2022", 200.0, "Em execução");

-- Criando e persistindo valores em Veículo 
create table Veiculo (
	idVeiculo int auto_increment primary key,
    idVeiculo_Cliente int,
    idVeiculo_Mecanico int,
    idVeiculo_Ordem_Servico int,
    Modelo varchar(45) not null,
    Fabricante varchar(45),
    Ano_Lançamento int,
    constraint fk_Veiculo_Cliente foreign key (idVeiculo_Cliente) references Cliente(idCliente),
    constraint fk_Veiculo_Mecanico foreign key (idVeiculo_mecanico) references Mecanico(idMecanico),
    constraint fk_Veiculo_Ord_Ser foreign key (idVeiculo_Ordem_Servico) references Ordem_Servico(idOrdem_Servico)
);

insert into Veiculo (idVeiculo, idVeiculo_Cliente, idVeiculo_Mecanico, idVeiculo_Ordem_Servico, Modelo, Fabricante, Ano_Lançamento)
			values (1, 1, 1, 1, "Uno", "Fiat", 2012),
                   (2, 2, 2, 2, "Gol", "VolksWagen", 2010),
                   (3, 3, 3, 3, "Renegade", "Jeep", 2020);

-- Criando e persistindo valores em Demanda
create table Demanda (
    idDemanda_Ordem_Servico int,
    idDemanda_Servico int,
    primary key(idDemanda_Ordem_Servico, idDemanda_Servico),
    Quantidade int not null,
    constraint fk_Dem_Ord_Ser foreign key (idDemanda_Ordem_Servico) references Ordem_servico(idOrdem_Servico),
    constraint fk_Dem_Servico foreign key (idDemanda_Servico) references Servicos(idServicos)
);

insert into Demanda (idDemanda_Ordem_Servico, idDemanda_Servico, Quantidade)
			values (1, 1, 1),
                   (2, 2, 1),
                   (3, 3, 1);

-- Criando e persistindo valores em Necessita
create table Necessita (
	idNecessita_Ordem_Servico int,
    idNecessita_Pecas int,
    primary key (idNecessita_Ordem_Servico, idNecessita_Pecas),
    Quantidade int not null,
    constraint fk_Nec_Ord_Ser foreign key (idNecessita_Ordem_Servico) references Ordem_Servico(idOrdem_Servico),
    constraint fk_Nec_Pecas foreign key (idNecessita_Pecas) references Pecas(idPecas)
);

insert into Necessita (idNecessita_Ordem_Servico, idNecessita_Pecas, Quantidade)
			values (1, 1, 1),
                   (2, 2, 1),
                   (3, 3, 1);

-- ELABORANDO QUERIES SOBRE AS TABELAS

-- Clientes e seus respectivos veículos
select c.Nome, c.Sobrenome, v.Modelo, v.Fabricante
from Cliente as c, Veiculo as v
where idCliente = idVeiculo;

-- Mecânicos, serviços e datas de emissão/entrega
select m.Nome, m.Sobrenome, os.Data_Emissao, os.Data_Entrega, os.Valor
from Mecanico as m, Ordem_Servico as os
where idMecanico = idOrdem_Servico;

-- Veículo e respectivas ordens de serviço ordenadas por valor
select * from Veiculo
inner join Servicos
on idVeiculo = idServicos
order by Valor;

-- Acrescendo R$15,00 ao valor inicial dos respectivos serviços
select s.Descrição, os.Data_Emissao, os.Data_Entrega, os.Valor, os.Valor + 15.0 as Acréscimo_Serviço
from Servicos as s, Ordem_Servico as os
where idServicos = idOrdem_servico;

