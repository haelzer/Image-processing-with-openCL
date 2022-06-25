# Calcul Haute Performance et filtres d'images avec OpenCL  
Réalisé par EL AMRANI-ZERRIFI Hamza et SCHOONAERT Bastien, avec l'aide de Mr GAVET Yann.
Supervisé par Mr AOUFI Asdin.
Un compte-rendu au format PDF adjoint à cette archive explicite les fonctions filtres étudiées et fait part de quelques observations.

## Compilation du code C++ et programmation de la convolution

### Chargement des modules

```shell
module load cuda/10.1
module load gcc/8.3.1
```

### Compilation

Pour générer le makefile: 

```
cmake -g .
```

Puis, pour compiler :

```
make
```

### Execution

```
Pour le filtre moyenneur :
./imageCopyFilter  n -k moyenne
Pour le filtre gaussien :
./imageCopyFilter n sigma -k gauss

Les paramètres:
n désigne l'entier taille de la fenêtre.
sigma désigne le paramètre sigma dans la formule de la fonction gaussienne. 
Il ne faut pas saisir de paramètres sigma lors de l'utilisation du moyenneur.
```

### Pour l'aide :
```
./imageCopyFilter -h
```

