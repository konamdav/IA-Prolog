% FONCTIONS DE SERVICES

% EFFACE LA MEMOIRE
clear_data:-
	retractall(pose_sur(_,_)),
	retractall(khan_historique(_,_)),
	retractall(historique(_,_,_)),
	retractall(joueur(_,_)).

% GENERE UN ID POUR CHAQUE PION DE L'EQUIPE	
generate_id_pion(PLAYER, ID):- findall(ID, pose_sur([_, PLAYER, ID], _), LIST), max_of_list(LIST, MAX), ID is MAX+1,!.
generate_id_pion(_, 1).

% NOMBRE DE PIONS DU JOUEUR SUR UN TYPE DE CASE
nombre_pions_sur_cases(BOARD, PLAYER, IND, NB):- 
	get_cell((_,_), BOARD, CELL), 
	get_occupant(CELL, PION), 
	get_equipe(PION, PLAYER), 
	findall(C,get_score(C, IND),LISTE), 
	length(LISTE, NB),!.

% FONCTIONS DE SERVICE PION
get_type(PION, TYPE):- get(PION, 1, TYPE).
get_equipe(PION, EQUIPE):- get(PION, 2, EQUIPE).
   
% KHAN
% TROUVER SCORE ASSOCIE AU KHAN
find_score_khan(BOARD, SCORE):- contient_khan(ID), get_cell(ID, BOARD, CELL), get_score(CELL, SCORE),!.

% RECUPERE COORDONNES DE LA CASE AYANT LE KHAN
contient_khan(X):- get_id_tour(NUM_TOUR), khan_historique(NUM_TOUR, X).
find_case_same_score(SCORE, ID, BOARD):- get_cell(ID, BOARD, CELL), get_score(CELL, SCORE).

% SE REPERER DANS LE PLATEAU
% COIN HAUT GAUCHE
in_coins((X, Y)):- 
	X > 0, 
	X =< 2, 
	Y > 0, 
	Y =< 2.
	
% COIN HAUT DROIT
in_coins((X, Y)):- 
	nbColonnes(NBC), 
	X > 4, 
	X =< NBC, 
	Y > 0, 
	Y =< 2.
	
% COIN BAS GAUCHE
in_coins((X, Y)):- 
	nbLignes(NBL), 
	X > 0, 
	X =< 2, 
	Y > 4, 
	Y =< NBL.
	
% COIN BAS DROITE
in_coins((X, Y)):- 
	nbColonnes(NBC), 
	nbLignes(NBL), 
	X > 4, 
	X =< NBC, 
	Y > 4, 
	Y =< NBL.

% FONCTION DE SERVICE CELL (CASE)	
% OBTENIR COORDONNES
get_id(CELL, ID):- 
	get(CELL, 1, ID). 

% OBTENIR SCORE 	
get_score(CELL, SCORE):- 
	get(CELL, 2, SCORE).

% OBTENIR OCUPPANT	
get_occupant(CELL, PION):- 
	get_id(CELL, ID), 
	pose_sur( PION, ID).

% SAVOIR SI CONTIENT KHAN	
is_khan(CELL):- 
	get_id(CELL, ID), 
	contient_khan(ID).

% REPERER LIGNE ET CASE 	
is_ligne([[(I, _) | _ ] | _], I).
is_cell_from_ligne([( _, J) | _ ], J).

% OBTENIR LIGNE
get_ligne([LIGNE| _], I, LIGNE):- is_ligne(LIGNE, I).
get_ligne([_| Q], I, L):- get_ligne(Q, I, L).

% OBTENIR CASE
get_cell_from_ligne([CELL | _], J, CELL):- is_cell_from_ligne(CELL, J).
get_cell_from_ligne([_ | Q], J, C):- get_cell_from_ligne(Q, J, C).
get_cell((I,J), BOARD, CELL):-  
	get_ligne(BOARD, I, LIGNE), 
	get_cell_from_ligne(LIGNE, J, CELL). 

% AFFICHAGE EQUIPE
afficheEquipe(rouge):- write('1'),!.
afficheEquipe(ocre):- write('2').

% AFFICHAGE PLATEAU DE JEU
printTableau([]):- nl.
printTableau([H|T]):- 
	is_ligne(H, 1), 
	write('  X / Y  |    1    |    2    |    3    |    4    |    5    |    6    '),   
	nl, write('    1    '), 
	printLigneTableau(H),nl, 
	printTableau(T),!.
	
printTableau([H|T]):- is_ligne(H, I), 
	write('    '), 
	write(I), 
	write('    '), printLigneTableau(H), nl, printTableau(T),!.

% AFFICHAGE LIGNE DE JEU	
% AVEC KHAN
printLigneTableau([CELL | Q ]):- 
	is_khan(CELL), get_score(CELL, SCORE), 
	get_occupant(CELL, PION),  
	write('|('),
	write(SCORE), 
	write(') '), 
	affichePion(PION), 
	write(' * '), 
	printLigneTableau(Q),!.

% SANS KHAN	
printLigneTableau([CELL | Q ]):- 
	get_score(CELL, SCORE), 
	get_occupant(CELL, PION),  
	write('|('),
	write(SCORE), 
	write(') '), 
	affichePion(PION), 
	write('   '), 
	printLigneTableau(Q),!.

% SANS PION	
printLigneTableau([CELL | Q ]):- get_score(CELL, SCORE), write('|('),write(SCORE), write(')      '), printLigneTableau(Q),!.
printLigneTableau([]).

% AFFICHER UN PION
affichePion(PION):- get_type(PION, kalista), write('K'), get_equipe(PION, EQUIPE), afficheEquipe(EQUIPE).
affichePion(PION):- get_type(PION, sbire), write('S'), get_equipe(PION, EQUIPE), afficheEquipe(EQUIPE).

% NOMBRE DE SBIRES RESTANTS AU JOUEUR
nombre_sbires_restants(BOARD, PLAYER, NB):-  
   setof(SBIRE, get_sbire(BOARD, PLAYER, SBIRE), LISTE), 
   length(LISTE, NB),!.   
   
nombre_sbires_restants(_, _, 0).

% MANIPULATION DE LISTES
% DELETE
del(X,[X|L],L).
del(X,[Y|L],[Y|L1]):- del(X,L,L1).

% AJOUT
putk(X,1,L,[X|L]):- !.
putk(X,K,[F|L],[F|LX]):- K1 is K-1, putk(X,K1,L,LX).

% ELEMENT
get([T | _], 1,  T):- !.
get([_ | Q], I,  R2):- J is I -1, get(Q, J, R2), !.
get([], _,[]).

% PREMIER DE LISTE
first([T | _], T).

% VIDE
empty([]).

% MAXIMUM DE LA LISTE
max_of_list([VAL], VAL).
max_of_list([VAL1| RESTE], MAX):-
	max_of_list(RESTE, VAL2),
	max(VAL1, VAL2, MAX).
	
max(VAL1, VAL2, VAL1):- VAL1 > VAL2,!.
max(_, VAL2, VAL2).

% SOMME DE LISTE
sumlist([], 0).
sumlist([T|Q], S):-
   sumlist(Q, SS),
   S is T + SS.

egalite(X, X).
different(X,Y):- \+ egalite(X,Y).   
   
% TESTER PRESENCE   
mymember(X,[X|_]):-!.
mymember(X,[_|T]) :- mymember(X,T),!.

% CHARGEMENT DES PLATEAUX DEPUIS FICHIER
file_to_list(FILE,LIST) :- 
   see(FILE), nl,
   fill_term([],R), 
   reverse(R,LIST),
   seen.
   
% CHARGEMENT DES PLATEAUX DEPUIS FICHIER
fill_term(IN,OUT):-
   read(Data), 
   (Data == end_of_file ->   
      OUT = IN;   
      fill_term([Data|IN],OUT)).