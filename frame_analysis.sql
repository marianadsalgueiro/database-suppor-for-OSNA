create or replace function frame_analysis(frame_keywords text[]) returns table (tweet_id text, texto text, frame_keyword text) as $$
declare
	i text;
begin
	FOREACH i IN ARRAY frame_keywords
	loop
		return query
		SELECT id, text, i FROM tweet t WHERE lower(text) ~* ('(?<!-|(#\textquestiondown#))' || i || '(?!-|(#\textquestiondown#))');
	end loop;
end;
$$ language plpgsql

select * from frame_analysis(array['apos', 'a medida que', 'quanto maior', 'quanto mais', 'quanto menor', 'quanto menos', 'cria', 'adiant', 'obrigad', 'devido a', 'devido ao', ...])