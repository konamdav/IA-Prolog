% CHARGEMENTS MODULES
load_files:-
	['constantes'],
	['strategie'],
	['fonctions_services'],
	['jeu'],
	['config_test_ia'],
	['interface'].



print_logo:-
nl,
write('    _____  ________  __    __        _______   ________        __    __  __    __   ______   __    __                      ______   ______    ______    ______  '),nl,
write('   /     |/        |/  |  /  |      /       \\ /        |      /  |  /  |/  |  /  | /      \\ /  \\  /  |                    /      | /      \\  /      \\  /      \\ '),nl,
write('   $$$$$ |$$$$$$$$/ $$ |  $$ |      $$$$$$$  |$$$$$$$$/       $$ | /$$/ $$ |  $$ |/$$$$$$  |$$  \\ $$ |                    $$$$$$/ /$$$$$$  |/$$$$$$  |/$$$$$$  |'),nl,
write('      $$ |$$ |__    $$ |  $$ |      $$ |  $$ |$$ |__          $$ |/$$/  $$ |__$$ |$$ |__$$ |$$$  \\$$ |       ______         $$ |  $$ |__$$ |$$$  \\$$ |$$____$$ |'),nl,
write(' __   $$ |$$    |   $$ |  $$ |      $$ |  $$ |$$    |         $$  $$<   $$    $$ |$$    $$ |$$$$  $$ |      /      |        $$ |  $$    $$ |$$$$  $$ | /    $$/ '),nl,
write('/  |  $$ |$$$$$/    $$ |  $$ |      $$ |  $$ |$$$$$/          $$$$$  \\  $$$$$$$$ |$$$$$$$$ |$$ $$ $$ |      $$$$$$/         $$ |  $$$$$$$$ |$$ $$ $$ |/$$$$$$/  '),nl,
write('$$ \\__$$ |$$ |_____ $$ \\__$$ |      $$ |__$$ |$$ |_____       $$ |$$  \\ $$ |  $$ |$$ |  $$ |$$ |$$$$ |                     _$$ |_ $$ |  $$ |$$ \\$$$$ |$$ |_____ '),nl,
write('$$    $$/ $$       |$$    $$/       $$    $$/ $$       |      $$ | $$  |$$ |  $$ |$$ |  $$ |$$ | $$$ |                    / $$   |$$ |  $$ |$$   $$$/ $$       |'),nl,
write(' $$$$$$/  $$$$$$$$/  $$$$$$/        $$$$$$$/  $$$$$$$$/       $$/   $$/ $$/   $$/ $$/   $$/ $$/   $$/                     $$$$$$/ $$/   $$/  $$$$$$/  $$$$$$$$/ '),nl,nl,
write('Programme developpe par David KONAM et Sebastien LAIDOUM '),nl.
                                                                                                                                                                                                                                                                                                                                 
cls(0):-!. 

cls(X):- 
    integer(X), 
    Y is X - 1, 
    nl, 
    cls(Y). 

cls:- cls(2).

% LANCEUR
initGame:-
	load_files, 
	cls, 
	print_logo, 
	cls, 
	initMode.