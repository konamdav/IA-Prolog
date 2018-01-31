% FICHIER STRATEGIE
danger_imminent(BOARD, PLAYER):- 
	pose_sur([kalista, PLAYER, _], ID_CASE),
	opposant_de(PLAYER, OPPOSANT), 
	possibleMoves(BOARD, OPPOSANT, LIST_MOVES), 
	mymember([[_, OPPOSANT, _], [_, ID_CASE]], LIST_MOVES).
	
victoire_imminente(BOARD, PLAYER):- 
	opposant_de(PLAYER, OPPOSANT), 
	pose_sur([kalista, OPPOSANT,_], ID_CASE),
	possibleMoves(BOARD, PLAYER, LIST_MOVES), 
	mymember([[_, PLAYER, _], [_, ID_CASE]], LIST_MOVES).

% EVALUATION DU JEU
evaluer_etat(BOARD, PLAYER, PLAYER_CUR, PROFONDEUR, SCORE):- 
	findall(S, evaluer(BOARD, PLAYER, PLAYER_CUR, PROFONDEUR, S), LIST_SCORE), 
	sumlist(LIST_SCORE, SCORE), 
	SCORE > 600000, 
	retractall(minmax_stop(_)), 
	asserta(minmax_stop(PROFONDEUR)),!.
	
evaluer_etat(BOARD, PLAYER, PLAYER_CUR, PROFONDEUR, SCORE):- 
	findall(S, evaluer(BOARD, PLAYER, PLAYER_CUR, PROFONDEUR, S), LIST_SCORE), sumlist(LIST_SCORE, SCORE).

% VICTOIRE
evaluer(BOARD, PLAYER, _, _, SCORE):-  
	partie_gagne(BOARD, PLAYER), 
	SCORE is 1000000.
	
% DEFAITE
evaluer(BOARD, PLAYER, _, _, SCORE):- 
	opposant_de(PLAYER, OPPOSANT), partie_gagne(BOARD, OPPOSANT),
	SCORE is -1000000.
	
% ANTICIPATION PROCHAIN COUP (AJOUTE UNE PROFONDEUR SUPPLEMENTAIRE AU MINMAX)
evaluer(BOARD, PLAYER, _, _, SCORE):- 
	victoire_imminente(BOARD, PLAYER), joueur(PLAYER, _, LEVEL), LEVEL > 2, 
	SCORE is 50000.
	
evaluer(BOARD, PLAYER, _, _, SCORE):- 
	danger_imminent(BOARD, PLAYER),	joueur(PLAYER, _, LEVEL), LEVEL > 2,
	SCORE is -50000.

evaluer(BOARD, PLAYER, PLAYER, _, SCORE):- 
	desobeissance(BOARD, PLAYER), 
	SCORE is 45000.
	
evaluer(BOARD, PLAYER, PLAYER_CUR, _, SCORE):- 
	different(PLAYER, PLAYER_CUR), 
	opposant_de(PLAYER, OPPOSANT), 
	obeissance(BOARD, OPPOSANT), 
	SCORE is 20000.
	
evaluer(BOARD, PLAYER, PLAYER, _, SCORE):- 
	obeissance(BOARD, PLAYER), 
	SCORE is -40000.
	
evaluer(BOARD, PLAYER, PLAYER_CUR, _, SCORE):- 
	different(PLAYER, PLAYER_CUR), 
	opposant_de(PLAYER, OPPOSANT), 
	desobeissance(BOARD, OPPOSANT), 
	SCORE is -20000.

%  MOINS DE PIONS QUE ADV (AVANTAGE POUR DESOBEISSANCE)
evaluer(BOARD, PLAYER, _, _, SCORE):-
	opposant_de(PLAYER, OPPOSANT), 
	nombre_sbires_restants(BOARD, PLAYER, NB_PLAY), 
	nombre_sbires_restants(BOARD, OPPOSANT, NB_ADV), 
	NB_PLAY < NB_ADV, 
	SCORE is 15000.

%  PLUS DE PIONS QUE ADV (DESAVANTAGE POUR DESOBEISSANCE)
evaluer(BOARD, PLAYER, _, _, SCORE):-
	opposant_de(PLAYER, OPPOSANT), 
	nombre_sbires_restants(BOARD, PLAYER, NB_PLAY), 
	nombre_sbires_restants(BOARD, OPPOSANT, NB_ADV), 
	NB_PLAY >= NB_ADV, 
	SCORE is -15000.

% KALISTA ADV DANS UN COIN 
evaluer(_, PLAYER, _, _, SCORE):-
	opposant_de(PLAYER, OPPOSANT), 
	pose_sur([kalista, OPPOSANT], ID_CASE), 
	pose_sur([sbire, OPPOSANT], (_,_)), 
	in_coins(ID_CASE), 
	SCORE is 10000.
	
% KALISTA ADV AU CENTRE DU PLATEAU (PAS DANS UN COIN)
evaluer(_, PLAYER, _, _, SCORE):- 
	opposant_de(PLAYER, OPPOSANT), 
	pose_sur([kalista, OPPOSANT], ID_CASE), 
	pose_sur([sbire, OPPOSANT], (_,_)), 
	\+in_coins(ID_CASE), 
	SCORE is -10000.	
	
% KALISTA DANS UN COIN 
evaluer(_, PLAYER, _, _, SCORE):-
	pose_sur([kalista, PLAYER], ID_CASE), 
	pose_sur([sbire, PLAYER], (_,_)), 
	in_coins(ID_CASE), 
	SCORE is 10000.
	
% KALISTA AU CENTRE DU PLATEAU (PAS DANS UN COIN)
evaluer(_, PLAYER, _, _, SCORE):- 
	pose_sur([kalista, PLAYER], ID_CASE), 
	pose_sur([sbire, PLAYER], (_,_)), 
	\+in_coins(ID_CASE), 
	SCORE is -10000.

% FAVORISE LES NOEUDS EN HAUT DE L ARBRE (SOLUTION PLUS COURTE)
evaluer(_, _, _, PROFONDEUR, SCORE):- 
	SCORE is 5000*PROFONDEUR.
	
% EVALUATION PAR DEFAUT
evaluer(_, _, _, _, 0).

% ALGO MINMAX
% DEBUT ALGO RECHERCHE DU MAX
minmax(reprise, PROFONDEUR, BOARD, PLAYER, BEST_MOVE, VAL) :- 
	retractall(minmax_stop(_)),
    % on cherche les meilleurs coup du joueur
	possibleReprises(BOARD, PLAYER, LIST_MOVES),
	% on cherche le meilleur de ces coups
    best_max(PROFONDEUR, BOARD, PLAYER, PLAYER, LIST_MOVES, BEST_MOVE, VAL)
	,retractall(minmax_stop(_)).
	
minmax(coup, PROFONDEUR, BOARD, PLAYER, BEST_MOVE, VAL) :- 
	retractall(minmax_stop(_)),
    % on cherche les meilleurs coup du joueur
	possibleMoves(BOARD, PLAYER, LIST_MOVES),
	% on cherche le meilleur de ces coups
    best_max(PROFONDEUR, BOARD, PLAYER, PLAYER, LIST_MOVES, BEST_MOVE, VAL),
	retractall(minmax_stop(_)).

	      
% RECHERCHE DU MIN	
find_min(PROFONDEUR,BOARD, PLAYER, PLAYER_CUR, _, VAL):- 
	minmax_stop(PROF_GAGNE), 
	PROF_GAGNE >= PROFONDEUR, 
	evaluer_etat(BOARD, PLAYER, PLAYER_CUR,  PROFONDEUR, VAL), !.
	
find_min(0, BOARD, PLAYER, PLAYER_CUR, _, VAL):- 
	evaluer_etat(BOARD, PLAYER, PLAYER_CUR,  0, VAL),!.
	
find_min(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, _, VAL):- 
	partie_gagne(BOARD, _),
	evaluer_etat(BOARD, PLAYER, PLAYER_CUR, PROFONDEUR, VAL),!. 
	
find_min(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, BEST_MOVE, VAL) :-
    % on cherche les meilleurs coup du joueur
	possibleMoves(BOARD, PLAYER_CUR, LIST_MOVES),
	% on cherche le meilleur de ces coups
    best_min(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, LIST_MOVES, BEST_MOVE, VAL).

% RECHERCHE DU MEILLEUR MIN	
best_min(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, [MOVE], MOVE, VAL) :-
	jouer_coup(MOVE),
	NPROFONDEUR is PROFONDEUR-1,
	opposant_de(PLAYER_CUR, OPPOSANT),
    find_max(NPROFONDEUR, BOARD, PLAYER, OPPOSANT, _, VAL),
	annuler_tour, !.

% RECHERCHE DU MEILLEUR MIN
best_min(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, [MOVE1 | LIST_MOVES], BEST_MOVE, BEST_VAL) :-
    jouer_coup(MOVE1),
	NPROFONDEUR is PROFONDEUR-1,
	opposant_de(PLAYER_CUR, OPPOSANT),
	find_max(NPROFONDEUR, BOARD, PLAYER, OPPOSANT, _, VAL1),
	annuler_tour,
    best_min(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, LIST_MOVES, MOVE2, VAL2),
    min_of(MOVE1, VAL1, MOVE2, VAL2, BEST_MOVE, BEST_VAL).

% COMPARAISON MIN
min_of(MOVE1, VAL1, _, VAL2, MOVE1, VAL1) :-   
	% Move1 est meilleur que Move2                   
    VAL1 < VAL2, !.                         

% COMPARAISON MIN	
min_of(_, _, MOVE2, VAL2, MOVE2, VAL2).   

% RECHERCHE DU MAX
find_max(PROFONDEUR,BOARD, PLAYER, PLAYER_CUR, _, VAL):- 
	minmax_stop(PROF_GAGNE),
	PROF_GAGNE >= PROFONDEUR, 
	evaluer_etat(BOARD, PLAYER, PLAYER_CUR,  PROFONDEUR, VAL), !.
	
find_max(0, BOARD, PLAYER, PLAYER_CUR, _, VAL):- 
	evaluer_etat(BOARD, PLAYER, PLAYER_CUR, 0, VAL),!.
	
find_max(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, _, VAL):- 
	partie_gagne(BOARD, _),
	evaluer_etat(BOARD, PLAYER, PLAYER_CUR, PROFONDEUR, VAL),!. 

find_max(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, BEST_MOVE, VAL) :- 
    % on cherche les meilleurs coup de l opposant
	possibleMoves(BOARD, PLAYER_CUR, LIST_MOVES),
	% on cherche le meilleur de ces coups
    best_max(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, LIST_MOVES, BEST_MOVE, VAL).

% RECHERCHE DU MEILLEUR MAX
best_max(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, [MOVE], MOVE, VAL) :-
	jouer_coup(MOVE),
	NPROFONDEUR is PROFONDEUR-1,
	opposant_de(PLAYER_CUR, OPPOSANT),
    find_min(NPROFONDEUR, BOARD, PLAYER, OPPOSANT, _, VAL),
	annuler_tour,!.
	
% RECHERCHE DU MEILLEUR MAX
best_max(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, [MOVE1 | LIST_MOVES], BEST_MOVE, BEST_VAL) :- 
    jouer_coup(MOVE1),
	NPROFONDEUR is PROFONDEUR-1,
	opposant_de(PLAYER_CUR, OPPOSANT),
	find_min(NPROFONDEUR, BOARD, PLAYER, OPPOSANT, _, VAL1),
	annuler_tour,
    best_max(PROFONDEUR, BOARD, PLAYER, PLAYER_CUR, LIST_MOVES, MOVE2, VAL2),
    max_of(MOVE1, VAL1, MOVE2, VAL2, BEST_MOVE, BEST_VAL).

% COMPARAISON MAX
max_of(MOVE1, VAL1, _, VAL2, MOVE1, VAL1) :-   
	% Move1 est meilleur que Move2                   
    VAL1 > VAL2, !.                         

% COMPARAISON MAX	
max_of(_, _, MOVE2, VAL2, MOVE2, VAL2). 

