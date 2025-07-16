--1 ranking de eventos
select j.nickname, 
sum(case when p.colocacao = 1 then 10 when p.colocacao = 2 then 7 when p.colocacao = 3 then 5 else 1 end) as pontuacao_total_eventos
from jogador j join participacao p on j.uuid = p.uuid
where p.colocacao is not null
group by j.nickname
order by pontuacao_total_eventos desc;

--2 historico de trocas entre players
select t.idtroca as "ID da Troca",
j_origem.nickname as "Jogador (Origem)",
p1.poke_name as "Ofereceu o Pokemon",
j_destino.nickname as "Jogador (Destino)",
p2.poke_name as "Recebeu o Pokemon"
from troca t join jogador j_origem on t.origemuuid = j_origem.uuid join
jogador j_destino on t.destinouuid = j_destino.uuid join
pokemon p1 on t.pokemon1 = p1.dexnum join pokemon p2 on t.pokemon2 = p2.dexnum
order by "ID da Troca";

--3 participacao em eventos
select e.nomeevento, e.tipoevento, e.tier, j.nickname,
    case
        when p.colocacao is null then 'Sem classificacao'
        else cast(p.colocacao as varchar)
    end as "Colocacao"
from participacao p join evento e on p.idevento = e.idevento join jogador j on p.uuid = j.uuid
order by e.nomeevento, p.colocacao;

--4 top mais ricos do serv
select j.uuid, j.nickname, j.pokecoins from jogador j order by pokecoins desc limit 5;

--5 participacao em eventos por qtd
select j.nickname,
    COUNT(p.idParticipacao) as "Total de Participacoes"
from jogador j join participacao p on j.UUID = p.UUID
group by j.nickname order by "Total de Participacoes" desc;

--6 anuncios fechados do gts
select a.idanuncio, vendedor.nickname as "vendedor", comprador.nickname as "comprador" from
    anunciogts a join jogador AS vendedor ON a.vendedor = vendedor.UUID join
    jogador AS comprador ON a.comprador = comprador.UUID
where a.estado = 'fechado';

--7 pokemons que tao no gts
select a.idanuncio, j.nickname, poke.poke_name, preco from
jogador j join anunciogts a on a.vendedor = j.uuid join pokemon poke on a.pokemon=poke.dexnum 
where a.estado = 'aberto' and pokemon is not null;

--8 ficha de jogador 
select j.nickname,
    case
        when contagem_trocas.total_trocas is null then 0
        else contagem_trocas.total_trocas
    end as "Trocas Realizadas",
    case
        when contagem_anuncios.total_anuncios is null then 0
        else contagem_anuncios.total_anuncios
    end as "Total de Anuncios no GTS", j.pokecoins, j.almas, j.pontos from
    jogador j left join ( select origemuuid as jogador_uuid, count(*) as total_trocas
    from troca group by origemuuid
) as contagem_trocas on j.uuid = contagem_trocas.jogador_uuid left join (
    select vendedor as jogador_uuid, count(*) as total_anuncios from anunciogts
    group by vendedor
) as contagem_anuncios on j.uuid = contagem_anuncios.jogador_uuid
order by j.nickname;