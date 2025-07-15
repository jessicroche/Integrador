DROP DATABASE IF EXISTS cobblemon_db;

CREATE DATABASE cobblemon_db;

\c cobblemon_db

CREATE TABLE IF NOT EXISTS logar(
    username varchar(20) NOT NULL,
    senha_cripto varchar(20) NOT NULL,
    constraint pk_logar primary key (username)
);


CREATE TABLE IF NOT EXISTS jogador(
    UUID int NOT NULL,
    nickname varchar(20) NOT NULL,
    ipAddress varchar(25) NOT NULL,
    servidor int NOT NULL,
    safariZone boolean NOT NULL,
    Elite4 boolean NOT NULL,
    almas int NOT NULL,
    pokecoins int NOT NULL,
    pontos int NOT NULL,
    constraint pk_jogador primary key (UUID),
    constraint fk_logar_jogador foreign key (nickname) references logar(username)
);

CREATE TABLE IF NOT EXISTS pokemon(
    dexNum int NOT NULL,
    poke_name varchar(15) NOT NULL,
    constraint pk_pokemon primary key (dexNum)
);

CREATE TABLE IF NOT EXISTS item(
    itemNome varchar(20) NOT NULL,
    descricao varchar(100) NOT NULL,
    constraint pk_item primary key (itemNome)
);

CREATE TABLE IF NOT EXISTS evento(
    idEvento SERIAL NOT NULL,
    nomeEvento varchar(20) NOT NULL,
    tipoEvento varchar(20) NOT NULL,
    tier varchar(15),
    constraint pk_evento primary key (idEvento)
);

CREATE TABLE IF NOT EXISTS participacao(
    idParticipacao SERIAL NOT NULL,
    idEvento int NOT NULL,
    UUID int NOT NULL,
    colocacao int,
    constraint pk_participacao primary key (idParticipacao),
    constraint fk_evento_participacao foreign key (idEvento) references evento(idEvento),
    constraint fk_jogador_participacao foreign key (UUID) references jogador(UUID)
);

CREATE TABLE IF NOT EXISTS troca(
    idTroca SERIAL NOT NULL,
    origemUUID int NULL,
    destinoUUID int NOT NULL,
    pokemon1 int NOT NULL,
    pokemon2 int NOT NULL,
    constraint pk_troca primary key (idTroca),
    constraint fk_jogador_troca1 foreign key (origemUUID) references jogador(UUID),
    constraint fk_jogador_troca2 foreign key (destinoUUID) references jogador(UUID),
    constraint fk_pokemon_troca1 foreign key (pokemon1) references pokemon(dexNum),
    constraint fk_pokemon_troca2 foreign key (pokemon2) references pokemon(dexNum) 
);

CREATE TABLE IF NOT EXISTS anuncioGTS(
    idAnuncio SERIAL NOT NULL,
    vendedor int NOT NULL,
    comprador int,
    preco float NOT NULL,
    estado varchar(15) NOT NULL,
    pokemon int,
    item varchar(20),
    constraint pk_anuncioGTS primary key (idAnuncio),
    constraint fk_jogador_anuncioGTS1 foreign key (vendedor) references jogador(UUID),
    constraint fk_jogador_anuncioGTS2 foreign key (comprador) references jogador(UUID),
    constraint fk_pokemon_anuncioGTS foreign key (pokemon) references pokemon(dexNum),
    constraint fk_item_anuncioGTS foreign key (item) references item(itemNome) 
);

INSERT INTO logar (username, senha_cripto) VALUES
('ash_ketchum', 'senha_1'),
('misty_water', 'senha_2'),
('brock_stone', 'senha_3'),
('gary_oak', 'senha_4'),
('len', 'senha_5'),
('rin', 'senha_6'),
('joana', 'senha_7'),
('carlos', 'senha_8'),
('patricia', 'senha_9'),
('jessica', 'senha_10'),
('jessie_rocket', 'senha_11'),
('james_rocket', 'senha_12');

INSERT INTO jogador (UUID, nickname, ipAddress, servidor, safariZone, Elite4, almas, pokecoins, pontos) VALUES
(1, 'ash_ketchum', '192.168.1.10', 1, false, false, 10, 1500, 250),
(2, 'misty_water', '192.168.1.11', 1, false, false, 5, 1200, 300),
(3, 'brock_stone', '192.168.1.12', 2, false, false, 3, 800, 150),
(4, 'gary_oak', '192.168.1.13', 1, true, true, 50, 5000, 700),
(5, 'len', '203.0.113.1', 1, true, true, 100, 25000, 3000),
(6, 'rin', '203.0.113.2', 1, true, true, 95, 22000, 2800),
(7, 'joana', '203.0.113.5', 2, false, true, 40, 3200, 650),
(8, 'carlos', '203.0.113.8', 2, true, false, 60, 4500, 800),
(9, 'patricia', '198.51.100.1', 3, true, true, 200, 50000, 5000),
(10, 'jessica', '198.51.100.2', 3, true, true, 180, 48000, 4500),
(11, 'jessie_rocket', '10.0.0.5', 4, false, false, 1, 150, 20),
(12, 'james_rocket', '10.0.0.6', 4, false, false, 1, 200, 25);

INSERT INTO pokemon (dexNum, poke_name) VALUES
(3, 'Venusaur'), (6, 'Charizard'), (9, 'Blastoise'),
(25, 'Pikachu'), (52, 'Meowth'), (59, 'Arcanine'),
(65, 'Alakazam'), (94, 'Gengar'), (130, 'Gyarados'),
(131, 'Lapras'), (143, 'Snorlax'), (149, 'Dragonite'),
(248, 'Tyranitar'), (384, 'Rayquaza'), (448, 'Lucario');

INSERT INTO item (itemNome, descricao) VALUES
('Poke Ball', 'Uma bola para capturar Pokemons.'),
('Great Ball', 'Uma bola com maior taxa de captura.'),
('Ultra Ball', 'Uma bola de alto desempenho.'),
('Master Ball', 'Captura garantida.'),
('Potion', 'Restaura 20 HP.'),
('Super Potion', 'Restaura 60 HP.'),
('Hyper Potion', 'Restaura 120 HP.'),
('Max Potion', 'Restaura todo o HP.'),
('Revive', 'Reanima um Pokemon com metade do HP.'),
('Max Revive', 'Reanima um Pokemon com todo o HP.'),
('Rare Candy', 'Aumenta o nivel de um Pokémon em 1.'),
('Lucky Egg', 'Aumenta a experiencia ganha.'),
('Leftovers', 'Recupera um pouco de HP a cada turno.'),
('Choice Band', 'Aumenta o ataque, mas prende a um golpe.'),
('Focus Sash', 'Permite sobreviver a um golpe fatal.');

INSERT INTO evento (nomeEvento, tipoEvento, tier) VALUES
('Torneio das Estrelas', 'PVP', 'AG'),
('Torneio semanal', 'PVP', 'Monotype');

INSERT INTO evento (nomeEvento, tipoEvento) VALUES
('Corrida Aquatica', 'PVE'),
('Concurso de Beleza', 'PVE'),
('Esconde esconde', 'PVP');

INSERT INTO participacao (idEvento, UUID, colocacao) VALUES
(1, 1, 2), (1, 3, 5), (1, 4, 1),
(2, 5, 1), (2, 6, 2), (2, 9, 3), (2, 10, 4),
(3, 2, 1), (3, 7, 3), (3, 11, 8),
(4, 8, 1), (4, 1, 5),
(5, 9, 1), (5, 5, 2); 

INSERT INTO troca (origemUUID, destinoUUID, pokemon1, pokemon2) VALUES
(1, 3, 25, 94),
(2, 7, 130, 3),
(4, 6, 59, 9),
(5, 10, 149, 248),
(8, 1, 448, 143),
(11, 12, 52, 65),
(9, 5, 384, 149),
(1, 2, 143, 131),
(3, 4, 94, 59),
(6, 7, 6, 130),
(10, 9, 248, 448);

INSERT INTO anuncioGTS (vendedor, comprador, preco, estado, pokemon, item) VALUES
(4, 6, 10000, 'fechado', 6, NULL),
(10, 9, 50000, 'fechado', 248, NULL),
(8, NULL, 500, 'aberto', NULL, 'Lucky Egg'),
(1, NULL, 2500, 'aberto', 25, NULL),
(2, NULL, 3000, 'aberto', 131, NULL),
(7, 1, 150, 'fechado', NULL, 'Max Revive'),
(11, NULL, 9999, 'aberto', 52, NULL),
(3, NULL, 200, 'cancelado', NULL, 'Revive'),
(5, NULL, 80000, 'aberto', 149, NULL),
(9, NULL, 250, 'aberto', NULL, 'Focus Sash'),
(6, 4, 12000, 'fechado', 9, NULL),
(1, NULL, 50, 'aberto', NULL, 'Poke Ball');
