% FICHIER JEU

% SUCCESSEURS DES CASES
is_succ((X1,Y1),(X2, Y1)):- nbColonnes(NBC), nbLignes(NBL), X2 is X1 +1, X2 @=< NBL, X1 @>0, Y1 @=< NBC,  Y1 @> 0.   
is_succ((X1,Y1),(X2, Y1)):- nbColonnes(NBC), nbLignes(NBL), X2 is X1-1, X1 @=< NBL, X2 @>0, Y1 @=< NBC,  Y1 @> 0.   
is_succ((X1,Y1),(X1, Y2)):- nbColonnes(NBC), nbLignes(NBL), Y2 is Y1+1, X1 @=< NBL, X1 @>0, Y2 @=< NBC,  Y1 @> 0. 
is_succ((X1,Y1),(X1, Y2)):- nbColonnes(NBC), nbLignes(NBL), Y2 is Y1-1, X1 @=< NBL, X1 @>0, Y1 @=< NBC,  Y2 @> 0. 
is_succ_valide((X1,Y1),(X2, Y2), BOARD):- is_succ((X1,Y1),(X2, Y2)), get_cell((X2, Y2), BOARD, CELL), \+get_occupant(CELL, _).

% CONSTRUCTION CHEMIN
chemin((X1, Y1), (X2, Y2), BOARD, 1, PLAYER, [(X1, Y1), (X2, Y2)]):- 
	is_succ((X1, Y1), (X2, Y2)), 
	get_cell((X2, Y2), BOARD, CELL),
	get_occupant(CELL, PION),
	opposant_de(PLAYER, OPPOSANT),
	get_equipe(PION, OPPOSANT).

% CONSTRUCTION CHEMIN	
chemin((X1, Y1), (X2, Y2), BOARD, 1, _, [(X1, Y1), (X2, Y2)]):- 
	is_succ_valide((X1, Y1), (X2, Y2), BOARD), 
	get_cell((X2, Y2), BOARD, _).

% CONSTRUCTION CHEMIN	
chemin((X1, Y1), (_, _), BOARD, CPT, PLAYER, [(X1, Y1) | Q ]):-  
	CPT @>=1, 
	is_succ_valide((X1, Y1), (I, J), BOARD),
	NCPT is CPT-1, 
	chemin((I, J), (_, _), BOARD, NCPT, PLAYER, Q),
	\+ member((X1, Y1), Q).

% CONSTRUCTION CHEMIN DE LONGUEUR = SCORE
get_chemin_from_cell((X1, Y1), BOARD, PLAYER, L):- 
	get_cell((X1, Y1), BOARD, CELL), 
	get_score(CELL, SCORE),
	chemin((X1, Y1), (_, _), BOARD, SCORE, PLAYER, L).
	
% PRESENCE KALISTA
presence_kalista(BOARD, PLAYER):-
	get_cell((_, _), BOARD, CELL), 
	get_occupant(CELL, PION), 
	get_type(PION, kalista),
	get_equipe(PION, PLAYER).

% FIN DE LA PARTIE
partie_gagne(BOARD, PLAYER):- 
	opposant_de(PLAYER, OPPOSANT), \+presence_kalista(BOARD, OPPOSANT),!.


% replacement DE SBIRE
peut_reprendre_sbire(BOARD, PLAYER):- nombre_sbires_restants(BOARD, PLAYER, NB), nbSbires(NBS), NB < NBS.
get_sbire(BOARD, PLAYER, SBIRE):- get_cell((_,_), BOARD, CELL), get_occupant(CELL, SBIRE), get_equipe(SBIRE, PLAYER), get_type(SBIRE, sbire).

%obeissance 
obeissance(BOARD, PLAYER):- 
	find_score_khan(BOARD, SCORE_KHAN),
	get_cell((_, _), BOARD, CELL), 
	get_occupant(CELL, PION), 
	get_equipe(PION, PLAYER), 
	get_score(CELL, SCORE_KHAN),
	get_id(CELL, ID),
	get_chemin_from_cell(ID, BOARD, PLAYER, _),
	!.
	
% DESOBEISSANCE	
desobeissance(BOARD, PLAYER):- \+obeissance(BOARD, PLAYER).
	
%selection des pions
% avec khan
pion_jouable(BOARD, PLAYER, [PION , [FROM, TO]]):- 
	obeissance(BOARD, PLAYER),
	find_score_khan(BOARD, SCORE_KHAN),
	get_cell((_, _), BOARD, CELL), 
	get_occupant(CELL, PION), 
	get_equipe(PION, EQUIPE), EQUIPE == PLAYER,
	get_score(CELL, SCORE_KHAN),
	get_id(CELL, ID),
	get_chemin_from_cell(ID, BOARD, PLAYER, MOVE),
	first(MOVE, FROM), 
	last(MOVE, TO).	

% selection des pions
% debut du jeu + desobeissance
pion_jouable(BOARD, PLAYER, [PION , [FROM, TO]]):- 
	desobeissance(BOARD, PLAYER),
	get_cell((_, _), BOARD, CELL), 
	get_occupant(CELL, PION), 
	get_equipe(PION, PLAYER),
	get_id(CELL, ID), 
	get_chemin_from_cell(ID, BOARD, PLAYER, MOVE), first(MOVE, FROM), last(MOVE, TO).	

%coups possibles (tenant compte de la desobeissance ou non)	
possibleMoves(BOARD, PLAYER, LIST_MOVE):- setof( MOVE, pion_jouable(BOARD, PLAYER, MOVE), LIST_MOVE).

% MISE EN PLACE CHANGEMENT DE POSITIONS + GESTION HISTORIQUE
% JOUER
jouer_coup([PION, [FROM, TO]]):-
	generate_id_tour(NUM_TOUR),
	ajoutPosition(NUM_TOUR, [PION, [FROM, TO]]),
	asserta(khan_historique(NUM_TOUR, TO)).
	
% CHANGEMENT POSITION
ajoutPosition(NUM_TOUR, [PION, [FROM, TO]]):- 
	pose_sur(PION2, TO),
	retractall(pose_sur(PION2, _)), 
	asserta(pose_sur(PION2, nil)),
	add_coup_historique(NUM_TOUR, [PION2, [TO, nil]]),
	retractall(pose_sur(PION, FROM)),
	asserta(pose_sur(PION, TO)),
	add_coup_historique(NUM_TOUR, [PION, [FROM, TO]]),
	!.
	
% CHANGEMENT POSITION	
ajoutPosition(NUM_TOUR, [PION, [FROM, TO]]):-
	add_coup_historique(NUM_TOUR, [PION, [FROM, TO]]),
	retractall(pose_sur(PION, _)),
	asserta(pose_sur(PION, TO)),!.

% GENERATION ID HISTORIQUE
generate_id_tour(NEW_TOUR):- get_id_tour(TOUR), NEW_TOUR is TOUR+1, !.
generate_id_tour(1).

% GET ID TOUR ACTUEL DANS HISTORIQUE
get_id_tour(TOUR):-findall(TOUR, historique(TOUR, _,_), LIST), max_of_list(LIST, TOUR),!.
get_id_tour(1):- \+historique(_,_,_). 

% GENERATION NOUVEAU COUP DANS HISTORIQUE
generate_id_coup(TOUR, ID):- findall(COUP, historique(TOUR, COUP, _  ), LIST),  \+ empty(LIST), max_of_list(LIST, MAX), ID is MAX+1, !.
generate_id_coup(_, 1).

% GENERER NOUVELLE ENTREE DANS HISTORIQUE
add_coup_historique(TOUR, [PION, [FROM, TO]]):- 
	generate_id_coup(TOUR, COUP), asserta(historique(TOUR, COUP,[PION, [FROM, TO]])).
	
% BACKTRACKING DANS LE JEU - ANNULATION DE TOUR
remove_tour(TOUR):- retractall(historique(TOUR, _, _)), retractall(khan_historique(TOUR, _)).

% ANNULATION DE TOUR	
annuler_tour:- 
	get_id_tour(NUM_TOUR), 
	setof([NUM_TOUR, NUM_COUP, [PION, [FROM, TO]]], 
	historique(NUM_TOUR, NUM_COUP, [PION, [FROM, TO]]), LIST), 
	annuler_coup(LIST), 
	remove_tour(NUM_TOUR).

% ANNULATION DE COUP	
annuler_coup([[_, _, [PION, [FROM, _]]] | RESTE]):- 
	retractall(pose_sur(PION, _)),
	annuler_coup(RESTE), asserta(pose_sur(PION, FROM)).
annuler_coup([]):-!.

% SELECTION DU COUP
selection_coup(PLAYER, BOARD):-
	possibleMoves(BOARD, PLAYER, LIST),
	affichePossibleMoves(1, LIST),nl,
	write('Selectionne un coup : '),
	read(IND),
	length(LIST, SIZE),
	IND > 0, IND =< SIZE,
	get(LIST, IND, MOVE),
	jouer_coup(MOVE),!.
	
selection_coup(PLAYER, BOARD):-
	write('Selection incorrecte.'),nl,
	write('Recommencez'),nl,
	!,selection_coup(PLAYER, BOARD),!.


% REPLACEMENT	
replacement(BOARD, PLAYER):-
	find_score_khan(BOARD, SCORE), findall(ID, find_case_same_score(SCORE, ID, BOARD), LIST),
	write('Cases possibles pour le repositionnement d\'un sbire : '),nl,
	write(LIST), nl,
	write('X ? '),nl,nl,
	read(X),
	write('Y ? '), 
	read(Y),
	mymember((X, Y), LIST),
	pose_sur(PION, nil),
	get_equipe(PION, PLAYER), 
	jouer_coup([PION, [nil, (X,Y)]]),!.

possibleReprises(BOARD, PLAYER, LIST):-
	pose_sur(PION, nil),
	get_equipe(PION, PLAYER),
	find_score_khan(BOARD, SCORE), findall([PION, [nil, ID]], find_case_same_score(SCORE, ID, BOARD), LIST),!.

possibleReprises(_, _, []).
	
replacementIA(BOARD, PLAYER):-
	joueur(PLAYER, _, LEVEL),
	minmax(reprise, LEVEL, BOARD, PLAYER, MOVE, SCORE),nl,
	write('Estimation IA : '), write(SCORE),nl,
	jouer_coup(MOVE), 
	write('IA reprend un sbire'),nl,!.
		
decision_joueur(PLAYER, BOARD, 1):-
	replacement(BOARD, PLAYER).
	
decision_joueur(PLAYER, BOARD, 2):-
	jouer(humain, PLAYER, BOARD).

% ACTION DU JOUEUR LORS D'UN TOUR	
action_joueur(humain, PLAYER, BOARD):- 
	desobeissance(BOARD, PLAYER),
	peut_reprendre_sbire(BOARD, PLAYER),
	possibleMoves(BOARD, PLAYER, _),
	write('Plusieurs choix possibles dans cette situation de desobeissance'),nl,
	write('Que faire ?'),nl,nl,
	write('[1] Recuperer un sbire'),nl,
	write('[2] Jouer les autres pions'),nl,
	read(CHOIX), 
	integer(CHOIX),
	CHOIX <3, CHOIX >0,
	decision_joueur(PLAYER, BOARD, CHOIX),
	!.
	
action_joueur(humain, PLAYER, BOARD):- 
	desobeissance(BOARD, PLAYER),
	peut_reprendre_sbire(BOARD, PLAYER),
	decision_joueur(PLAYER, BOARD, 1),
	!.
	
action_joueur(humain, PLAYER, BOARD):- 
	jouer(humain, PLAYER, BOARD),!.

action_joueur(ia, PLAYER, BOARD):- 
	jouer(ia, PLAYER, BOARD),!.
	
action_joueur(ia, PLAYER, BOARD):- 
	write('IA est contraint de reprendre un  pion'),nl, replacementIA(BOARD, PLAYER),!.

action_joueur(_, _, _).

% JOUER
jouer(humain, PLAYER, BOARD):-
	selection_coup(PLAYER, BOARD),!.
	
jouer(ia, PLAYER, BOARD):-
	joueur(PLAYER, _, LEVEL),
	minmax(coup, LEVEL, BOARD, PLAYER, MOVE, SCORE),nl,
	write('Estimation IA : '), write(SCORE),nl,
	jouer_coup(MOVE).

