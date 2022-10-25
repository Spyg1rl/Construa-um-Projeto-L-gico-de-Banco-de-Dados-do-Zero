create database oficina_mecanica;
use oficina_mecanica;

-- criando tabelas e inserindo dados

drop table Clientes;
create table Clientes(
idCliente varchar(10),
Nome_cliente varchar (100) not null,
Endereço varchar (200) not null,
Bairro varchar (20),
Contato int,
idPlaca_carro char(7),
primary key(idCliente, idPlaca_carro));

insert into Clientes (idCliente, Nome_cliente, Endereço, Bairro, Contato, idPlaca_carro) values
('C1', 'José Antonio', 'Rua Bonifacio, 220', 'Lapa', 123456666, 'abc1015'),
('C2', 'Romeu Tuma', 'Av Jaqueline, 569', 'Santa Cecilia', 123457777, 'qwe1569'),
('C3', 'Maria Conceição', 'Alameda Santos, 599', 'Paulista', 123458888, 'pep1020'),
('C4', 'Fabia Lima', 'Rua Morango, 9877', 'Grajaú', 123459999, 'pwe5132'),
('C5', 'Marcelo Augusto', 'Av Pucarona, 1265', 'Limão', 123450000, 'rty9889');

drop table oficina;
create table Oficina (
idServ_Realizado_oficina char(10) not null,
idMecanico_oficina char(5),
idOS_oficina char(10),
constraint fk_oficina_idServ_Realizado_oficina foreign key (idOS_oficina) references Servico_realizado (idOS_serviço),
constraint fk_equipe_mecanico foreign key (idMecanico_oficina) references Mecanico (idMecanico),
constraint fk_equipe_idOS foreign key (idOS_oficina) references Ordem_servico (idOS));

-- insert into Oficina (idOficina, idPlaca_carro

create table Mecanico (
idMecanico char (5) primary key,
Nome_mecanico varchar(20),
Endereco_mecanico varchar(200));

insert into Mecanico (idMecanico, Nome_mecanico, Endereco_mecanico) values
('M1', 'Lucas Barbosa', 'Rua Pratriarca, 520'),
('M2', 'Rodolfo Rodrigues', 'Rua Belchior, 987'),
('M3', 'João Raimundo', 'Rua Silveira, 252');

drop table Ordem_servico;
create table Ordem_servico (
idOS char(10) primary key,
Conserta_carro enum ('S', 'N') not null,
Revisao_periodica enum ('S', 'N') not null,
data_emissao date not null,
data_entrega date not null,
Status_servico enum ('Em andamento', 'Finalizado', 'Atrasado') default 'Atrasado',
idEstoque_OS char(4),
idtab_referencia_OS int default 0,
idMecanico_OS char(3),
idPlaca_OS varchar(20),
constraint fk_ordem_idEstoque foreign key (idEstoque_OS) references Estoque (idEstoque),
constraint fk_ordem_idtab_referencia foreign key (idtab_referencia_OS) references Tabela_referencia (idtab_referencia),
constraint fk_ordem_idMecanico foreign key (idMecanico_OS) references Mecanico (idMecanico));

alter table Ordem_servico add constraint fk_ordem_idPlaca foreign key (idPlaca_OS) references Clientes (idPlaca_carro);

insert into Ordem_servico (idOS, Conserta_carro, Revisao_periodica, data_emissao, data_entrega, Status_servico,
 idEstoque_OS, idtab_referencia_OS, idMecanico_OS, idPlaca_OS) values
 ('OS1', 'S', 'N', '2022-04-05', '2022-08-01', 'Finalizado', 'E2', 2, 'M3', 'rty9889'),
 ('OS2', 'S', 'N', '2022-03-10', '2022-05-06', 'Finalizado', 'E6', 3, 'M3', 'pwe5132'),
 ('OS3', 'N', 'S', '2022-03-20', '2022-05-07', 'Em andamento', default, 5, 'M1', 'pep1020'),
 ('OS4', 'S', 'N', '2022-09-01', '2022-11-12', default, 'E3', 4, 'M2', 'qwe1569'),
 ('OS5', 'N', 'S', '2022-10-05', '2022-12-01', default, default, 5, 'M3', 'abc1015');
   

create table Tabela_referencia (
idtab_referencia int primary key,
Valor_mao_de_obra decimal not null);

insert into Tabela_referencia (idtab_referencia, Valor_mao_de_obra) values
(1, 220.00),
(2, 3300.00),
(3, 550.50),
(4, 1100.20),
(5, 100.00);

create table Estoque (
idEstoque char(4) primary key,
Quantidade int not null,
Valor_peca decimal(10,2) not null);

alter table Estoque modify Valor_peca decimal(10,2) default '0';

insert into Estoque (idEstoque, Quantidade, Valor_peca) values
('E1', 1000, 120.00),
('E2', 36, 32.00),
('E3', 550, 80.00),
('E4', 10, 930.00),
('E5', 51, 300.00),
('E6', 2000, 25.00),
('E7', 220, 61.00);

create table Servico_realizado (
idOS_servico char (10) not null,
Servico_aprovado enum ('Sim', 'Não') not null,
idClientes_servico varchar(20) not null,
constraint fk_Servico_realizado_OS foreign key (idOS_serviço) references Ordem_servico (idOS),
constraint fk_Servico_idClientes foreign key (idClientes_servico) references Clientes (idCliente));

insert into Servico_realizado (idOS_servico, Servico_aprovado, idClientes_servico) values
('OS1', 'Sim', 'C2'),
('OS2', 'Não', 'C4'),
('OS5', 'Sim', 'C1'),
('OS3', 'Sim', 'C5'),
('OS4', 'Sim', 'C3');

-- mostrar tabelas

desc Clientes;
select *from Clientes;
select *from Oficina;
desc Mecanico;
select *from Mecanico;
select *from Ordem_servico;
select *from Tabela_referencia;
select *from Estoque;
select *from Servico_realizado;

-- recuperando informações simples

select * from Clientes, Ordem_servico where idPlaca_carro = idPlaca_OS;

-- Andamento de cada serviço realizado
select Nome_mecanico, Endereco_mecanico, o.data_entrega, o.Status_servico from Mecanico as m, Ordem_servico o 
where idMecanico = idMecanico_OS;

-- Servico foi realizado?

select *from Servico_realizado, Clientes where idClientes_servico = idCliente;

-- Soma dos serviços de revisão periódica

select Revisao_periodica, sum(Valor_mao_de_obra) as valor_total  from Ordem_servico as o, Tabela_referencia as t 
where idtab_referencia_OS = idtab_referencia and Revisao_periodica = 'S';

-- Soma dos serviços de conserto

select Conserta_carro, sum(Valor_mao_de_obra) as valor_total  from Ordem_servico as o, Tabela_referencia as t 
where idtab_referencia_OS = idtab_referencia and Conserta_carro = 'S';

select Conserta_carro, Valor_mao_de_obra from Ordem_servico as o, Tabela_referencia as t 
where idtab_referencia_OS = idtab_referencia and Conserta_carro = 'S';

-- Serificando os carros que foram feitas apenas revisão

select Revisao_periodica, Status_servico,  idPlaca_OS, Valor_mao_de_obra from Ordem_servico as o, Tabela_referencia as t 
where idtab_referencia_OS = idtab_referencia and Revisao_periodica = 'S';

-- Verificando quantos serviços foram feitos por cada mecânico

select count(*) as total_servicos, idMecanico_OS, sum(Valor_mao_de_obra) as valor_total from Ordem_servico as o, Tabela_referencia as t 
where idtab_referencia_OS = idtab_referencia 
group by idMecanico_OS;

-- Recuperando o nome de cada mecânico por serviço e valor

select count(*) as total_servicos, idMecanico_OS, sum(Valor_mao_de_obra) as valor_total,  Nome_mecanico from Mecanico as m, Ordem_servico as o, Tabela_referencia as t 
where idtab_referencia_OS = idtab_referencia and idMecanico = idMecanico_OS
group by idMecanico_OS;

-- Aplicando aumento na revisão periódica e peças

update Tabela_referencia set Valor_mao_de_obra = 
case 
when idtab_referencia = 1 then Valor_mao_de_obra + 60.00
when idtab_referencia = 5 then Valor_mao_de_obra + 30.00
else Valor_mao_de_obra + 0
end;

select idtab_referencia, round(Valor_mao_de_obra, 2) from Tabela_referencia;

-- Verificando cliente que aprovaram o serviço

select Nome_cliente, Contato, idPlaca_carro,  Servico_aprovado from Clientes c
inner join Servico_realizado s on idCliente = idClientes_servico;

-- Verificando cliente que aprovaram o serviço

select Nome_cliente, Contato, idPlaca_carro,  Servico_aprovado from Clientes c
inner join Servico_realizado s on idCliente = idClientes_servico
inner join Ordem_servico o on idPlaca_carro = idPlaca_OS
order by Nome_cliente;

-- Verificando Status de serviço po carro

select idPlaca_OS, Status_servico from Ordem_servico os
inner join Tabela_referencia t on  idtab_referencia = idtab_referencia_OS;

--
select * from Servico_realizado
inner join Ordem_servico on idOS_serviço = idOS
inner join Clientes on idCliente = idClientes_servico;

-- verificando estoque e tabela de referência utilizada

select c.Nome_cliente, c.idPlaca_carro, sr.Servico_aprovado, os.Status_servico, os.idEstoque_OS, os.idtab_referencia_OS  from  Servico_realizado sr
inner join Ordem_servico os on idOS_serviço = os.idOS
inner join Clientes c on c.idCliente = sr.idClientes_servico;

-- verificar quanto cada cliente irá pagar

select o.idPlaca_OS, e.Valor_peca, tr.Valor_mao_de_obra from Ordem_servico o
left outer join Estoque e on o.idEstoque_OS = e.idEstoque
inner join Tabela_referencia tr on o.idtab_referencia_OS = tr.idtab_referencia;



