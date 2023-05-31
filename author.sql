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