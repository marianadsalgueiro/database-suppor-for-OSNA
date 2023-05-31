create or replace function possible_rt_path(retweeters text[], author text) returns table (accounts_path text[]) as $$
declare
	i text;
begin
	FOREACH i IN ARRAY retweeters
	loop
		return query
		with recursive graph_cte (fk_account_id, fk_account_id_, path) as ( 
		  select fk_account_id, fk_account_id_, ARRAY[fk_account_id] as path from follows where fk_account_id = i
		  union all
		  select nxt.fk_account_id, nxt.fk_account_id_, array_append(prv.path, nxt.fk_account_id) from follows nxt, graph_cte prv where nxt.fk_account_id = prv.fk_account_id_ and nxt.fk_account_id != ALL(prv.path) )
		select array_append(path, fk_account_id_) from graph_cte where fk_account_id_ = author;
	end loop;
end;
$$ language plpgsql

select * from possible_rt_path((select * from retweeters('1')), (select * from author('1')))