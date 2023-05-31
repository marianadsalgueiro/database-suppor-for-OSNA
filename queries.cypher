MATCH (a:Account)-[c:Creates]->()-[r:References {type: 'Retweet'}]->(t:Tweet {id: 'tweet_1'})<-[c1:Creates]-()
WITH DISTINCT (a)
MATCH c=(a)-[r:Follows*]->()-[c2:Creates]->(t:Tweet {id: 'tweet_1'})
return [n in NODES(c) where not n:Tweet | n.id] as possible_rt_path