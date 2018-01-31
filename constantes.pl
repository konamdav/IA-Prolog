% FICHIER CONSTANTES & INITIALISATIONS

% TABLEAU POUR DEBOGAGE
board([[[(1, 1), 2], [(1, 2), 2], [(1, 3), 3], [(1, 4), 1], [(1, 5), 2], [(1, 6), 2]], 
[[(2, 1), 1], [(2, 2), 3], [(2, 3), 1], [(2, 4), 3], [(2, 5), 1], [(2, 6), 3]],
[[(3, 1), 3], [(3, 2), 1], [(3, 3), 2], [(3, 4), 2], [(3, 5), 3], [(3, 6), 1]],
[[(4, 1), 2], [(4, 2), 3], [(4, 3), 1], [(4, 4), 3], [(4, 5), 1], [(4, 6), 2]],
[[(5, 1), 2], [(5, 2), 1], [(5, 3), 3], [(5, 4), 1], [(5, 5), 3], [(5, 6), 2]],
[[(6, 1), 1], [(6, 2), 3], [(6, 3), 2], [(6, 4), 2], [(6, 5), 1], [(6, 6), 3]]
]).

% PREDICATS DYNAMIQUES
:- dynamic(khan_historique/2).
:- dynamic(historique/3).
:- dynamic(pose_sur/2).
:- dynamic(joueur/3).
:- dynamic(minmax_stop/1).

% CONSTANTES
nbLignes(6).
nbColonnes(6).
nbSbires(5).
opposant_de(rouge,ocre).
opposant_de(ocre,rouge).

