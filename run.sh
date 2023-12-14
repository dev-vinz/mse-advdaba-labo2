#! /bin/bash

# Download data with wget
# Transform numerical with this following command : sed -r 's/NumberInt\(([0-9]+)\)/\1/g nom_du_fichier
# Stream apoc https://neo4j.com/labs/apoc/4.1/import/load-json/#load-json-examples

if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <password>"
    exit 1
fi

FILE_NAME="JeaMar_data.json"

echo "Starting..." > log.txt;
start=`date +%s`

wget --no-hsts -O dblpv13.json  http://vmrum.isc.heia-fr.ch/dblpv13.json
sed -r  's/NumberInt\(([0-9]+)\)/\1/g' dblpv13.json > "./$FILE_NAME" 

cypher-shell -u $1 -p $2 "
    CALL apoc.periodic.iterate(
        'CALL apoc.load.jsonArray(\"file:///$FILE_NAME\") YIELD value AS article RETURN article',
        '
        // Create the article node
        MERGE (art: ARTICLE { id: article._id })
        ON CREATE SET art.title = article.title
        ON MATCH SET art.title = article.title

        // Create the author nodes and the authored relationships
        WITH article, art, COALESCE(article.authors, []) as authors // May be null
        UNWIND authors as author
        WITH article, art, author WHERE author._id IS NOT NULL // Some authors id are null...
        MERGE (aut: AUTHOR { id: author._id })
        ON CREATE SET aut.name = author.name
        ON MATCH SET aut.name = author.name

        // Create authored relationships
        CREATE (aut)-[:AUTHORED]->(art)

        // Create cites relationships
        WITH art, COALESCE(article.references, []) as references // May be null or empty
        UNWIND references as referenceId
        MERGE (ref: ARTICLE { id: referenceId })
        MERGE (art)-[:CITES]->(ref)',
        { batchSize: 500, iterateList: true, parallel: true }
    );
";

end=`date +%s`

echo "Data loaded successfully" >> log.txt;
echo Execution time was `expr $end - $start` seconds. >> log.txt;
