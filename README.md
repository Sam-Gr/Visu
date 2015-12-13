# Visu

## Introduction
	Dans ce TP, nous avons pu, à l'aide de l'outil Processing, réaliser une 
application de visualisation de données sur les villes de France. Nous avons dÛ
faire des choix de variables visuelles pour représenter certaines grandeurs, 
elles aussi choisis judicieusement.

### Exécution
	Je n'ai pas réussi à exporter l'application correctement. Il faut donc ouvrir 
le projet avec Processing (fichier Visu.pde) et le lancer via Processing.

## Grandeurs représentées

	Les villes sont représentées par des cercles à remplissage transparent pour 
laisser transparaître des villes éventuellement recouvertes par d'autres.

### La population (nombre d'habitants)
	Une ville est représentée par un cercle, dont l'aire est proportionnelle au 
nombre d'habitants. La valeur du nombre d'habitants est transposée sur un 
intervalle d'aires de cercles défini en dur pour contrôler la taille des cercles 
affichés par l'application. Sans cette précaution, on pourrait obtenir un cercle 
immense pour la ville de Paris par exemple. La représentation de cette grandeur 
est renseignée à l'utilisateur, via la légende, par une suite de cercles d'aires
croissantes.

	J'ai choisi un cercle pour représenter les villes, car cela transcrit bien la 
réalité d'une ville à peu près uniformément répartie dans toutes les directions.
Le fait qu'une ville peuplée aura un plus grand cercle qu'une petite ville est 
quelque chose de naturel que l'utilisateur comprend bien. De plus, cela met 
l'accent sur les grandes villes, qui sont les villes les plus intéressantes à 
étudier, à montrer.

### La densité
	La densité d'une ville est indiquée par la couleur de remplissage du cercle la 
représentant. Plus précisément, c'est la saturation qui indique la valeur de 
densité. Plus la saturation est élevée, plus la densité de la ville correspondante 
est elevée. La teinte a été choisie arbitrairement ; toutefois, j'ai fait le choix 
de prendre une couleur (rouge-orange) dont les différences de saturation se 
démarquent bien sur le fond blanc. La représentation de cette grandeur est 
indiquée par le dégradé de couleur dans la légende. Ce dégradé est de la même 
teinte, mais avec une saturation croissante qui indique la représentation de la 
donnée.
	
	Le fait de choisir la saturation comme variable rétinienne, a été motivé par 
le fait que l'on peut faire l'analogie entre la densité, ou la concentration, de 
population dans une ville et la saturation d'une couleur, qui peut être vue 
comme une densité, ou concentration, de couleur.

## Interactions

### Survol d'une ville
	Au survol d'une ville, le contour de son cercle est plus épais et le nom de la 
ville apparaît dans un rectangle à fond vert un peu transparent pour que le 
texte soit bien visible sans occulter complètement la carte.

### Seuillage du nombre d'habitants pour l'affichage des villes
	Pour ne pas avoir un excès de données affichées, il est possible de définir un 
nombre d'habitants minimum pour qu'une ville soit affichée. Ce seuil est indiqué 
et géré par la partir inférieure droite de l'application (histogramme). Il est 
possible d'y voir un histogramme de distribution des villes par rapport au 
nombre d'habitants. Cet histogramme est représenté sur une échelle logarithmique.
En effet, avec un histogramme sur une échelle linéaire la très grande majorité 
des villes se trouvent dans le premier intervalle de valeur, rendant l'histogramme
inexpoloitable et pas informatif. Là, on voit bien la répartition des villes selon
le nombre d'habitants. De plus, un curseur est présent sur cet histogramme. Il 
permet de fixer le seuil décrit plus haut. On peut le bouger en faisant un 
cliquer-déplacer avec la souris et le seuil, ainsi que l'affichage des villes 
correspondant, se mettent à jour dynamiquement.
