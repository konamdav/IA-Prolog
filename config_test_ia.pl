% TEST IA

% TEST 1
% COUP PERDANT
board1(
[[[(1, 1), 2], [(1, 2), 2], [(1, 3), 3], [(1, 4), 1], [(1, 5), 2], [(1, 6), 2]], 
[[(2, 1), 1], [(2, 2), 3], [(2, 3), 1], [(2, 4), 3], [(2, 5), 1], [(2, 6), 3]],
[[(3, 1), 2], [(3, 2), 1], [(3, 3), 2], [(3, 4), 2], [(3, 5), 3], [(3, 6), 1]],
[[(4, 1), 2], [(4, 2), 3], [(4, 3), 1], [(4, 4), 3], [(4, 5), 1], [(4, 6), 3]],
[[(5, 1), 2], [(5, 2), 1], [(5, 3), 3], [(5, 4), 2], [(5, 5), 3], [(5, 6), 2]],
[[(6, 1), 1], [(6, 2), 3], [(6, 3), 2], [(6, 4), 2], [(6, 5), 1], [(6, 6), 3]]
]).

test1(LEVEL):- 
	clear_data, 
	init_board1, attente, 
	init_player(LEVEL), 
	exec_game(1, 2, ocre).

init_board1:-
	jouer_coup([[kalista, ocre, 1], [nil, (5,4)]]),
	jouer_coup([[sbire, ocre, 2], [nil, (3,1)]]),
	jouer_coup([[kalista, rouge, 1], [nil, (4,6)]]),
	jouer_coup([[sbire, rouge, 2], [nil, (3,4)]]),
	board1(X),
	write('---------------------------------INIT-----------------------------------------'),nl, 
	printTableau(X),
	write('------------------------------------------------------------------------------'),nl.


% TEST 2
% COUP GAGNANT 3 TOURS DE JEU
board2(
[[[(1, 1), 2], [(1, 2), 2], [(1, 3), 3], [(1, 4), 1], [(1, 5), 2], [(1, 6), 2]], 
[[(2, 1), 1], [(2, 2), 3], [(2, 3), 3], [(2, 4), 3], [(2, 5), 1], [(2, 6), 3]],
[[(3, 1), 2], [(3, 2), 1], [(3, 3), 2], [(3, 4), 2], [(3, 5), 3], [(3, 6), 1]],
[[(4, 1), 2], [(4, 2), 3], [(4, 3), 2], [(4, 4), 3], [(4, 5), 1], [(4, 6), 3]],
[[(5, 1), 2], [(5, 2), 1], [(5, 3), 3], [(5, 4), 2], [(5, 5), 3], [(5, 6), 2]],
[[(6, 1), 1], [(6, 2), 3], [(6, 3), 2], [(6, 4), 2], [(6, 5), 1], [(6, 6), 3]]
]).	
	
test2(LEVEL):- 
	clear_data,
	init_board2, attente, 
	init_player(LEVEL), 
	exec_game(2, 3, ocre).

init_board2:-
	jouer_coup([[kalista, ocre, 1], [nil, (4,3)]]),
	jouer_coup([[sbire, rouge, 2], [nil, (6,6)]]),
	jouer_coup([[kalista, rouge, 1], [nil, (1,5)]]),
	board2(X),
	write('---------------------------------INIT-----------------------------------------'),nl, 
	printTableau(X),
	write('------------------------------------------------------------------------------'),nl.
	
	
% TEST 3
% COUP GAGNANT 5 TOURS DE JEU
board3(
[[[(1, 1), 1], [(1, 2), 3], [(1, 3), 1], [(1, 4), 1], [(1, 5), 1], [(1, 6), 1]], 
[[(2, 1), 1], [(2, 2), 1], [(2, 3), 1], [(2, 4), 1], [(2, 5), 1], [(2, 6), 1]],
[[(3, 1), 1], [(3, 2), 1], [(3, 3), 1], [(3, 4), 2], [(3, 5), 2], [(3, 6), 2]],
[[(4, 1), 2], [(4, 2), 1], [(4, 3), 1], [(4, 4), 1], [(4, 5), 1], [(4, 6), 1]],
[[(5, 1), 1], [(5, 2), 2], [(5, 3), 1], [(5, 4), 1], [(5, 5), 1], [(5, 6), 1]],
[[(6, 1), 2], [(6, 2), 1], [(6, 3), 2], [(6, 4), 1], [(6, 5), 2], [(6, 6), 3]]
]).	
	
test3(LEVEL):- 
	clear_data,
	init_board3, attente, 
	init_player(LEVEL), 
	exec_game(3, 5, ocre).

init_board3:-
	jouer_coup([[kalista, ocre, 1], [nil, (6,6)]]),
	jouer_coup([[kalista, rouge, 1], [nil, (3,2)]]),
	jouer_coup([[sbire, rouge, 2], [nil, (6,1)]]),
	board3(X),
	write('---------------------------------INIT-----------------------------------------'),nl, 
	printTableau(X),
	write('------------------------------------------------------------------------------'),nl.
	
% TEST 4
% REPLACEMENT DE PION
board4(
[[[(1, 1), 1], [(1, 2), 3], [(1, 3), 1], [(1, 4), 1], [(1, 5), 1], [(1, 6), 1]], 
[[(2, 1), 1], [(2, 2), 1], [(2, 3), 1], [(2, 4), 1], [(2, 5), 1], [(2, 6), 1]],
[[(3, 1), 2], [(3, 2), 1], [(3, 3), 1], [(3, 4), 2], [(3, 5), 2], [(3, 6), 2]],
[[(4, 1), 2], [(4, 2), 1], [(4, 3), 1], [(4, 4), 1], [(4, 5), 1], [(4, 6), 1]],
[[(5, 1), 1], [(5, 2), 2], [(5, 3), 1], [(5, 4), 1], [(5, 5), 1], [(5, 6), 1]],
[[(6, 1), 2], [(6, 2), 1], [(6, 3), 2], [(6, 4), 1], [(6, 5), 2], [(6, 6), 3]]
]).	
	
test4(LEVEL):- 
	clear_data,
	init_board4, attente, 
	init_player(LEVEL), 
	exec_game(4, 3, ocre).

init_board4:-
	jouer_coup([[kalista, ocre, 1], [nil, (6,6)]]),
	jouer_coup([[sbire, ocre, 2], [nil, nil]]),
	jouer_coup([[kalista, rouge, 1], [nil, (1,1)]]),
	jouer_coup([[sbire, rouge, 4], [nil, (5,6)]]),
	jouer_coup([[sbire, rouge, 2], [nil, (6,5)]]),
	board4(X),
	write('---------------------------------INIT-----------------------------------------'),nl, 
	printTableau(X),
	write('------------------------------------------------------------------------------'),nl.	
	

% CONTROLE EXECUTION  DU JEU	
exec_game(_, _, _):- board1(BOARD), partie_gagne(BOARD, _), nl, write('FIN DU JEU'), !.	
	
exec_game(NUM_TEST, PROF, PLAYER):- PROF > 0,
	test_board(NUM_TEST, BOARD), 
	action_joueur(ia, PLAYER, BOARD),nl,
	printTableau(BOARD), nl,
	opposant_de(PLAYER, OPPOSANT), 
	NPROF is PROF -1,
	exec_game(NUM_TEST, NPROF, OPPOSANT),!.
	
exec_game(_, 0, _).

attente:- nl, write('Lancer la demonstration : '), read(X), nl.

% INIT JOUEURS
init_player(LEVEL):- 
	initPlayerRouge(ia_vs_ia, _,  [1, LEVEL]).

% GENERER TABLEAU
test_board(1, BOARD):- board1(BOARD),!.
test_board(2, BOARD):- board2(BOARD),!.
test_board(3, BOARD):- board3(BOARD),!.
test_board(4, BOARD):- board4(BOARD),!.

% LANCEUR TEST	
test(1):- write('LEVEL IA ?'), nl, read(LEVEL), test1(LEVEL),!.
test(2):- write('LEVEL IA ?'), nl, read(LEVEL), test2(LEVEL),!.
test(3):- write('LEVEL IA ?'), nl, read(LEVEL), test3(LEVEL),!.
test(4):- write('LEVEL IA ?'), nl, read(LEVEL), test4(LEVEL),!.

	
	