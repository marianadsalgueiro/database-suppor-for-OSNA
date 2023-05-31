// Exemplo baseado na modelagem

CREATE CONSTRAINT account_id FOR (a:Account) REQUIRE a.id IS UNIQUE
CREATE CONSTRAINT account_id_exists FOR (a:Account) REQUIRE a.id IS NOT NULL

CREATE (:Account {id: '1'})
CREATE (:Account {id: '2'})
MATCH (a:Account), (b:Account) WHERE a.id = '2' AND b.id = '1'
CREATE (a)-[f:Follows]->(b)

CREATE CONSTRAINT tweet_id FOR (t:Tweet) REQUIRE t.id IS UNIQUE
CREATE CONSTRAINT tweet_id_exists FOR (t:Tweet) REQUIRE t.id IS NOT NULL
CREATE (:Tweet {id: '1'})
CREATE (:Tweet {id: '2'})

MATCH (a:Account {id:'1'}), (b:Tweet {id:'1'})
CREATE (a)-[c:Creates {timestamp: apoc.date.format(timestamp())}]->(b)

MATCH (a:Account {id:'1'}),(b:Tweet {id:'1'})
CREATE (a)-[l:Likes]->(b)

MATCH (a:Account {id:'1'}),(b:Tweet {id:'1'})
CREATE (a)-[p:Pins]->(b)

MATCH (a:Account {id:'1'}),(b:Tweet {id:'1'})
CREATE (b)-[m:Mentions]->(a)

MATCH (a:Account {id:'1'}),(b:Tweet {id:'1'})
CREATE (b)-[:Belongs_To_Timeline]->(a)

MATCH (a:Tweet {id:'1'}),(b:Tweet {id:'2'})
CREATE (b)-[:References {type:'Share'}]->(a)


// Exemplo de caminho de retweet
CREATE (:Account {id: 'account_1'})
CREATE (:Account {id: 'account_2'})
CREATE (:Account {id: 'account_3'})
CREATE (:Account {id: 'account_4'})
CREATE (:Account {id: 'account_5'})
CREATE (:Account {id: 'account_6'})
CREATE (:Account {id: 'account_7'})
CREATE (:Account {id: 'account_8'})

MATCH (a:Account), (b:Account) WHERE a.id = 'account_2' AND b.id = 'account_1'
CREATE (a)-[f:Follows]->(b)
MATCH (a:Account), (b:Account) WHERE a.id = 'account_3' AND b.id = 'account_1'
CREATE (a)-[f:Follows]->(b)
MATCH (a:Account), (b:Account) WHERE a.id = 'account_4' AND b.id = 'account_1'
CREATE (a)-[f:Follows]->(b)
MATCH (a:Account), (b:Account) WHERE a.id = 'account_6' AND b.id = 'account_3'
CREATE (a)-[f:Follows]->(b)
MATCH (a:Account), (b:Account) WHERE a.id = 'account_7' AND b.id = 'account_3'
CREATE (a)-[f:Follows]->(b)
MATCH (a:Account), (b:Account) WHERE a.id = 'account_7' AND b.id = 'account_4'
CREATE (a)-[f:Follows]->(b)
MATCH (a:Account), (b:Account) WHERE a.id = 'account_7' AND b.id = 'account_8'
CREATE (a)-[f:Follows]->(b)
MATCH (a:Account), (b:Account) WHERE a.id = 'account_8' AND b.id = 'account_4'
CREATE (a)-[f:Follows]->(b)

CREATE (:Tweet {id: 'tweet_1'})
CREATE (:Tweet {id: 'tweet_2'})
CREATE (:Tweet {id: 'tweet_3'})
CREATE (:Tweet {id: 'tweet_4'})

MATCH (a:Account {id:'account_1'}), (b:Tweet {id:'tweet_1'})
CREATE (a)-[c:Creates {timestamp: apoc.date.format(timestamp())}]->(b)
MATCH (a:Account {id:'account_3'}), (b:Tweet {id:'tweet_2'})
CREATE (a)-[c:Creates {timestamp: apoc.date.format(timestamp())}]->(b)
MATCH (a:Account {id:'account_6'}), (b:Tweet {id:'tweet_3'})
CREATE (a)-[c:Creates {timestamp: apoc.date.format(timestamp())}]->(b)
MATCH (a:Account {id:'account_7'}), (b:Tweet {id:'tweet_4'})
CREATE (a)-[c:Creates {timestamp: apoc.date.format(timestamp())}]->(b)

MATCH (a:Tweet {id:'tweet_1'}),(b:Tweet {id:'tweet_2'})
CREATE (b)-[:References {type:'Retweet'}]->(a)
MATCH (a:Tweet {id:'tweet_1'}),(b:Tweet {id:'tweet_3'})
CREATE (b)-[:References {type:'Retweet'}]->(a)
MATCH (a:Tweet {id:'tweet_1'}),(b:Tweet {id:'tweet_4'})
CREATE (b)-[:References {type:'Retweet'}]->(a)