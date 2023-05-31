insert into account values ('www.twitter.com/user1_pedro', False, 'Pedro', NULL, 'account_1', 'Bio do Pedro', NULL, '@user1_pedro', NULL, 100, 200, NULL, NULL);
insert into account values ('www.twitter.com/user2_vitor', False, 'Vitor', NULL, 'account_2', 'Bio do Vitor', NULL, '@user2_vitor', NULL, 877, 103, NULL, NULL);
insert into account values ('www.twitter.com/user3_joao', False, 'João', NULL, 'account_3', 'Bio do João', NULL, '@user3_joao', NULL, 10, 2, NULL, NULL);
insert into account values ('www.twitter.com/user4_maria', False, 'Maria', NULL, 'account_4', 'Bio da Maria', NULL, '@user4_maria', NULL, 554, 260, NULL, NULL);
insert into account values ('www.twitter.com/user5_bruna', False, 'Bruna', NULL, 'account_5', 'Bio da Pedro', NULL, '@user5_bruna', NULL, 100, 68, NULL, NULL);
insert into account values ('www.twitter.com/user6_bruno', True, 'Bruno', NULL, 'account_6', 'Bio do Bruno', NULL, '@user6_bruno', NULL, 1776, 1000000, NULL, NULL);
insert into account values ('www.twitter.com/user7_sergio', False, 'Sergio', NULL, 'account_7', 'Bio do Sergio', NULL, '@user7_sergio', NULL, 370, 304, NULL, NULL);
insert into account values ('www.twitter.com/user8_cristina', True, 'Pedro', NULL, 'account_8', 'Bio da Cristina', NULL, '@user8_cristina', NULL, 450, 330000, NULL, NULL);

insert into follows values ('account_2', 'account_1');
insert into follows values ('account_3', 'account_1');
insert into follows values ('account_4', 'account_1');
insert into follows values ('account_6', 'account_3');
insert into follows values ('account_7', 'account_3');
insert into follows values ('account_7', 'account_4');
insert into follows values ('account_7', 'account_8');
insert into follows values ('account_8', 'account_4');

insert into tweet values (False, 'www.twitter.com/user1_pedro/status/1', '1', NULL, 'everyone', null, 'pt', 1000, 'account_1', current_timestamp,
10, 5, 20, 3, 'exemplo de tweet', null, null);

insert into tweet values (False, 'www.twitter.com/user3_joao/status/1', '2', NULL, 'everyone', null, 'pt', 1000, 'account_3', current_timestamp,
0, 0, 0, 4, 'RT @user1_pedro exemplo de tweet', null, null);

insert into references_table values ('2', '1', 'Retweet');

insert into tweet values (False, 'www.twitter.com/user6_bruno/status/1', '3', NULL, 'everyone', null, 'pt', 1000, 'account_6', current_timestamp,
0, 0, 0, 5, 'RT @user1_pedro exemplo de tweet', null, null);

insert into references_table values ('3', '1', 'Retweet');

insert into tweet values (False, 'www.twitter.com/user7_sergio/status/1', '4', NULL, 'everyone', null, 'pt', 1000, 'account_7', current_timestamp,
0, 0, 0, 6, 'RT @user1_pedro exemplo de tweet', null, null);

insert into references_table values ('4', '1', 'Retweet');

create or replace function retweeters(tweet_id text) returns text[] as $$
declare
	retweeters text[];
begin
	select array_agg(fk_account_id) into retweeters 
	from tweet  
	where id in (select references_tweet 
			from references_table rt
			where referenced_tweet = tweet_id
			and type = 'Retweet');
	return retweeters;
end;
$$ language plpgsql

select * from retweeters('1');

create or replace function author(tweet_id text) returns text as $$
declare
	author text;
begin 
	select fk_account_id into author
	from tweet
	where id = tweet_id;
	return author;
end;
$$ language plpgsql

select * from author('1');

create or replace function possible_rt_path(retweeters text[], author text) returns table (accounts_path text[]) as $$
declare
	i text;
begin
	FOREACH i IN ARRAY retweeters
	loop
		return query
		with recursive graph_cte (fk_account_id, fk_account_id_, path) 
		as
		( 
		  select fk_account_id, fk_account_id_, ARRAY[fk_account_id] as path
		  from follows
		  where fk_account_id = i
		  union all
		  select nxt.fk_account_id, nxt.fk_account_id_, array_append(prv.path, nxt.fk_account_id)
		  from follows nxt, graph_cte prv
		  where nxt.fk_account_id = prv.fk_account_id_
		  and nxt.fk_account_id != ALL(prv.path)
		)
		select array_append(path, fk_account_id_)
		from graph_cte
		where fk_account_id_ = author;
	end loop;
end;
$$ language plpgsql

select * from possible_rt_path((select * from retweeters('1')), (select * from author('1')))