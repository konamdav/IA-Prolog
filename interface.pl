% FICHIER INTERFACE

% LANCEUR
initMode:-
	write('[1] A propos du jeu'),nl,
	write('[2] Humain VS IA'),nl,
	write('[3] Humain VS Humain'),nl,
	write('[4] IA VS IA'),nl,
	write('[5] Test configuration 1'),nl,
	write('[6] Test configuration 2'),nl,
	write('[7] Test configuration 3'),nl,
	write('[8] Test configuration 4'),nl,
	write('[9] Quitter'),nl,nl,
	read(CHOIX),
	CHOIX > 0, 
	CHOIX < 10,
	execMode(CHOIX),
	!.
initMode:- 
	nl,
	write('Selection incorrect'),nl,
	write('Recommencez'),nl,nl,
	initMode.

% EXECUTION CHOIX USER
execMode(1):- 
	write('# Les regles'),nl, nl, 
	write('Jouer tour à tour pour prendre la kalista de l\'autre joueur !'), nl, 
	write('L\'anticipation est la clé de votre victoire'),nl, nl, initMode,!.
	
execMode(2):- 
	write('# Humain VS IA'),nl,nl,clear_data, 
	initBoard(h_vs_ia, BOARD),
	boucleJeu(BOARD, rouge),
	!.
	
execMode(3):-
	write('# Humain VS Humain'),nl,nl,clear_data, 
	initBoard(h_vs_h, BOARD),
	boucleJeu(BOARD, rouge),
	!.
execMode(4):-
	write('# IA VS IA'),nl,nl,clear_data, 
	initBoard(ia_vs_ia, BOARD),
	boucleJeu(BOARD, rouge),
	!.
execMode(9):- halt,!.
execMode(CPT):- TEST is CPT - 4, write('EXECUTION TEST N°'), write(TEST), nl, test(TEST), nl, nl, initMode.

% BOUCLE DE PARTIE
% SI FIN DE JEU
boucleJeu(BOARD, _):- 
	partie_gagne(BOARD, PLAYER), printTableau(BOARD), nl,  nl, 
	write('Joueur '), write(PLAYER), 
	write(' remporte la partie !'),nl,nl,get_id_tour(TOUR), write('Nombre de tours '),write(TOUR),nl,nl,
	write('Fin du jeu. '), nl, nl, clear_data, initMode, !.

% TOUR
boucleJeu(BOARD, PLAYER):-
	printTableau(BOARD),
	write('# Tour du joueur '), write(PLAYER), nl, nl,	
	joueur(PLAYER, TYPE_JOUEUR, _),
	action_joueur(TYPE_JOUEUR, PLAYER, BOARD),
	opposant_de(PLAYER, OPPOSANT),cls, 
	boucleJeu(BOARD, OPPOSANT).
	
% AFFICHAGE COUPS POSSIBLES
affichePossibleMoves(CPT, [[ PION , [FROM, TO]]| MOVES]):- 
	write('[ '), 
	write(CPT), 
	write(' ] '), 
	affichePion(PION), 
	write(' ('), 
	write(FROM), 
	write(') -> ('), 
	write(TO), 
	write(')'),nl, NCPT is CPT+1,
	affichePossibleMoves(NCPT,MOVES),!.
	
affichePossibleMoves(_, []).

% AFFICHAGE LISTE DE CHOIX DE CASES
afficheCases(CPT, [ID_CASE | RESTE]):- 
	write('[ '), 
	write(CPT), 
	write(' ] '), 
	write('( '), write(ID_CASE), write(' )'),nl,
	NCPT is CPT+1,
	afficheCases(NCPT,RESTE),!.
	
afficheCases(_, []).

% PLACEMENT DES PIONS
placementPion(ia,_, sbire, _, _, 1):- !.	
placementPion(_,_, _, _, _, 0):-!.
placementPion(humain, BOARD, TYPE_PION, [MIN, MAX], PLAYER, I):- 
	printTableau(BOARD),
	findall(ID_CELL,getPlaceDispoPlacement(BOARD, [MIN, MAX], ID_CELL), LIST),
	length(LIST, SIZE),
	afficheCases(1, LIST),nl,nl,
	write('Selectionnez une des cases possibles :'), nl,
	read(CHOIX), integer(CHOIX),
	CHOIX > 0, CHOIX =< SIZE,
	get(LIST, CHOIX, CELL),
	get_id_tour(NUM_TOUR),
	generate_id_pion(PLAYER, ID),
	ajoutPosition(NUM_TOUR, [[TYPE_PION,PLAYER, ID],[nil, CELL]]),
	I1 is I-1, placementPion(humain, BOARD, TYPE_PION, [MIN, MAX], PLAYER, I1),!.
	
placementPion(humain, BOARD, TYPE_PION, [MIN, MAX], PLAYER, I):- 
	write('Saisie incorrect.'), 
	nl, 
	nl,
	placementPion(humain, BOARD, TYPE_PION, [MIN, MAX], PLAYER, I).

placementPion(ia, BOARD, kalista, [MIN, MAX], ocre, I):- 
	findall(ID_CELL,getPlaceDispoPlacement(BOARD, [MAX, MAX], ID_CELL), LIST),
	length(LIST, SIZE),
	random(1,SIZE,Z),
	get(LIST, Z, (X,Y)),
	get_id_tour(NUM_TOUR),
	generate_id_pion(ocre, ID),
	generate_id_pion(ocre, ID2),
	XX is X-1,
	ajoutPosition(NUM_TOUR, [[kalista,ocre, ID],[nil, (X,Y)]]),
	ajoutPosition(NUM_TOUR, [[sbire,ocre, ID2],[nil, (XX, Y)]]),
	I1 is I-1, placementPion(ia, BOARD, kalista, [MIN, MAX], ocre, I1),!.

placementPion(ia, BOARD, kalista, [MIN, MAX], rouge, I):- 
	findall(ID_CELL,getPlaceDispoPlacement(BOARD, [MIN, MIN], ID_CELL), LIST),
	length(LIST, SIZE),
	random(1,SIZE,Z),
	get(LIST, Z, (X,Y)), 
	get_id_tour(NUM_TOUR),
	generate_id_pion(rouge, ID),
	generate_id_pion(ocre, ID2),
	XX is X+1,
	ajoutPosition(NUM_TOUR, [[kalista,rouge, ID],[nil, (X,Y)]]),
	ajoutPosition(NUM_TOUR, [[sbire,rouge, ID2],[nil, (XX, Y)]]),
	I1 is I-1, placementPion(ia, BOARD, kalista, [MIN, MAX], rouge, I1),!.

placementPion(ia, BOARD, TYPE_PION, [MIN, MAX], PLAYER, I):- 
	findall(ID_CELL,getPlaceDispoPlacement(BOARD, [MIN, MAX], ID_CELL), LIST),
	length(LIST, SIZE),
	random(1,SIZE,Z),
	get(LIST, Z, CELL), 
	get_id_tour(NUM_TOUR),
	generate_id_pion(PLAYER, ID),
	ajoutPosition(NUM_TOUR, [[TYPE_PION,PLAYER, ID],[nil, CELL]]),
	I1 is I-1, placementPion(ia, BOARD, TYPE_PION, [MIN, MAX], PLAYER, I1),!.

getPlaceDispoPlacement(BOARD ,[MIN, MAX], (I,J)):-
	get_cell((I,J), BOARD, _), \+ pose_sur(_, (I,J)), I>= MIN, I=<MAX.
	
initPions(TYPE_JOUEUR, BOARD, rouge):- 
	placementPion(TYPE_JOUEUR, BOARD, kalista, [1, 2], rouge, 1),
	nl,nbSbires(NBS), 
	placementPion(TYPE_JOUEUR, BOARD, sbire, [1, 2], rouge, NBS),!.

initPions(TYPE_JOUEUR, BOARD, ocre):- 
	placementPion(TYPE_JOUEUR, BOARD, kalista, [5, 6], ocre, 1),
	nl,nbSbires(NBS), 
	placementPion(TYPE_JOUEUR, BOARD, sbire, [5, 6], ocre, NBS),!.



% INITIALISATION DU PLATEAU	 
% HUMAIN VS IA 
initBoard(h_vs_ia, BOARD):-
	write('Niveau IA ? '), nl,
	read(LEVEL),
	write('Souhaites tu etre le joueur Rouge ?'),
	nl, 
	write('[1] Oui'),
	nl,
	write('[2] Non'),nl,
	read(CHOIX),
	initPlayerRouge(h_vs_ia, CHOIX, [LEVEL]),
	nl,
	joueur(rouge, TYPE_JOUEUR_ROUGE, _),
	initInclinaison(TYPE_JOUEUR_ROUGE, BOARD),
	nl, 
	initPions(TYPE_JOUEUR_ROUGE, BOARD, rouge),
	joueur(ocre, TYPE_JOUEUR_OCRE, _),
	initPions(TYPE_JOUEUR_OCRE, BOARD, ocre).

% HUMAIN VS HUMAIN
initBoard(h_vs_h, BOARD):-
	write('Vous êtes le joueur rouge !'),
	initPlayerRouge(h_vs_h, 1),
	nl,
	initInclinaison(humain, BOARD),
	nl, 
	initPions(humain, BOARD, rouge),
	initPions(humain, BOARD, ocre).

% IA VS IA
initBoard(ia_vs_ia, BOARD):-
	write('Niveau IA1 ? '), nl,
	read(LEVEL1),
	write('Niveau IA2 ? '), nl,
	read(LEVEL2),
	initPlayerRouge(ia_vs_ia, 1, [LEVEL1, LEVEL2]),
	nl,
	initInclinaison(ia, BOARD),
	nl, 
	initPions(ia, BOARD, rouge),
	initPions(ia, BOARD, ocre).

% CHARGEMENT DES FICHIERS	
initDirection(1, BOARD):- write('Selection du bord Nord'), file_to_list('./board/board-n.txt',BOARD),!.
initDirection(2, BOARD):- write('Selection du bord Sud'), file_to_list('./board/board-s.txt',BOARD), !.
initDirection(3, BOARD):- write('Selection du bord Ouest'), file_to_list('./board/board-o.txt',BOARD), !.
initDirection(4, BOARD):- write('Selection du bord Est'), !, file_to_list('./board/board-e.txt',BOARD), !.
initDirection(X, BOARD):- 
	X> 4, write('Selection incorrect'), 
	nl, 
	write('Recommencez'), nl,
	read(Y), 
	initDirection(Y, BOARD).

% ATTRIBUTION COULEURS
initPlayerRouge(h_vs_ia, 1, [LEVEL1]):- 
	asserta(joueur(rouge, humain, 0)),
	asserta(joueur(ocre, ia, LEVEL1)),
	write('Tu as choisis d\'etre le joueur Rouge'),!.
	
initPlayerRouge(h_vs_ia, 2, [LEVEL1]):- 
	asserta(joueur(rouge, ia, LEVEL1)),
	asserta(joueur(ocre, humain, 0)),
	write('Ok. Je suis le joueur Rouge'),!.
	
initPlayerRouge(h_vs_h, _, _):- 
	asserta(joueur(rouge, humain, 0)),
	asserta(joueur(ocre, humain, 0)),
	!.
	
initPlayerRouge(ia_vs_ia, _,  [LEVEL1, LEVEL2]):- 
	asserta(joueur(rouge, ia, LEVEL1)),
	asserta(joueur(ocre, ia, LEVEL2)),
	!.
	
initPlayerRouge(MODE, _):- 
	write('Selection incorrect'), nl, 
	write('Recommencez'), nl, 
	read(ROUGE), 
	initPlayerRouge(MODE, ROUGE).

% INCLINAISON
initInclinaison(humain, BOARD):- write('De quel cote souhaitez vous incliner le plateau ? (Tapez le chiffre correspondant)'), 
nl, 
write('[1] Nord'),
nl,
write('[2] Sud'),
nl,
write('[3] Ouest'),
nl,
write('[4] Est'),
nl, read(X),  initDirection(X, BOARD)
,!.

initInclinaison(ia, BOARD):- write('Je choisis l\'inclinaison du plateau'),nl, random(1,4,Z), initDirection(Z, BOARD),!.
