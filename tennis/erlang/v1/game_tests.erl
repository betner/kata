-module(game_tests).
-include_lib("eunit/include/eunit.hrl").

score_test() ->
	Game = game:create(p1, p2),
	R1 = game:player_one_scores(Game),
	?assert({15, 0} =:= game:get_score(R1)),

	R2 = game:player_one_scores(R1),
	?assert({30, 0} =:= game:get_score(R2)),

	R3 = game:player_one_scores(R2),
	?assert({40, 0} =:= game:get_score(R3)),

	End = game:player_one_scores(R3),	
	?assert({winner, p1} =:= game:get_score(End)).

deuce_test() ->
	Game = game:create(p1, p2),
	R1 = game:player_one_scores(Game),	
	R2 = game:player_two_scores(R1),	
	R3 = game:player_one_scores(R2),	
	R4 = game:player_two_scores(R3),	
	R5 = game:player_one_scores(R4),	
	Deuce = game:player_two_scores(R5),	
	io:format("Deuce: ~p", [game:get_score(Deuce)]),
	?assert({deuce} =:= game:get_score(Deuce)).

advantage_test() ->
	Game = game:create(p1, p2),
	R1 = game:player_one_scores(Game),	
	R2 = game:player_two_scores(R1),	
	R3 = game:player_one_scores(R2),	
	R4 = game:player_two_scores(R3),	
	R5 = game:player_one_scores(R4),	
	Deuce = game:player_two_scores(R5),	

	AdvP1 = game:player_one_scores(Deuce),
	?assert({advantage, 40} =:= game:get_score(AdvP1)),
	Deuce2 = game:player_two_scores(AdvP1),
	?assert({deuce} =:= game:get_score(Deuce2)),
	AdvP2 = game:player_two_scores(Deuce2),
	?assert({40, advantage} =:= game:get_score(AdvP2)),
	End = game:player_two_scores(AdvP2),
	?assert({winner, p2} =:= game:get_score(End)).
