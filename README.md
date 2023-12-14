# Advanced Database
MSE - Labo 2

### Membres

* Henrique Marques Reis
* Vincent Jeannin

### Approche

Notre approche consiste à utiliser le plugin [APOC](https://neo4j.com/docs/apoc/current/) de Neo4j, avec la fonction `apoc.load.jsonArray`. Grâce à cette fonction, nous pouvons récupérer directement objet par objet, et ainsi les insérer un à un dans la base de données Neo4j.

Afin d'exécuter le script plus rapidement, nous utilisons la fonction `apoc.periodic.iterate` qui permet d'exécuter en parallèle différents blocs.

Seulement, il n'est pas possible de faire ce script sous forme de stream, le fichier doit préalablement être téléchargé, puis modifié à cause des NumericInt.

### Commandes utilisées

* Ajouter le script : `kubectl create configmap neo4j-script-configmap --from-file=run.sh --namespace=adv-da-ba23-jeamar`
* Créer le pod : `kubectl apply -f pod.yaml`
* Entrer dans le pod en exec : `kubectl exec -it neo4j-pod --namespace=adv-da-ba23-jeamar -- /bin/bash`
* Vérifier l'état des pods : `kubectl get pods --namespace=adv-da-ba23-jeamar`
* Logs du pod : `kubectl logs -f neo4j-pod --namespace=adv-da-ba23-jeamar`
* Ajout du KUBECONFIG : `export KUBECONFIG="/[...]/local.yaml"`
