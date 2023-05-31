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