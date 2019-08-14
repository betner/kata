-module(game_tests).
-include_lib("eunit/include/eunit.hrl").

score_test() ->
	Player1 = p1,
	Player2 = p2,
	Game = game:create(Player1, Player2),

	R1 = game:player_scores(Player1, Game),
	?assert({love, 0} =:= game:get_score(R1)),

	R2 = game:player_scores(Player1, R1),
	?assert({30, 0} =:= game:get_score(R2)),

	R3 = game:player_scores(Player1, R2),
	?assert({40, 0} =:= game:get_score(R3)),

	End = game:player_scores(Player1, R3),	
	?assert({winner, Player1} =:= game:get_score(End)).

deuce_test() ->
	Player1 = p1,
	Player2 = p2,
	Game = game:create(Player1, Player2),

	Love_Zero    = game:player_scores(Player1, Game),
	Deuce1       = game:player_scores(Player2, Love_Zero),
	Thirty_Love  = game:player_scores(Player1, Deuce1),
	Deuce2       = game:player_scores(Player2, Thirty_Love),
	Forty_Thirty = game:player_scores(Player1, Deuce2),
	
	Deuce3= game:player_scores(Player2, Forty_Thirty),
	?assert({deuce} =:= game:get_score(Deuce3)),

	AdvP1 = game:player_scores(Player1, Deuce3),
	?assert({advantage, 40} =:= game:get_score(AdvP1)),
	Deuce4 = game:player_scores(Player2, AdvP1),
	?assert({deuce} =:= game:get_score(Deuce4)),
	AdvP2 = game:player_scores(Player2, Deuce4),
	?assert({40, advantage} =:= game:get_score(AdvP2)),
	End = game:player_scores(Player2, AdvP2),
	?assert({winner, p2} =:= game:get_score(End)).
