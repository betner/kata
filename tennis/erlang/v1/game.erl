-module(game).
-compile(export_all).

-type state() :: {player:player(), player:player(), atom()}.

-spec create(atom(), atom()) -> state().
create(PlayerName1, PlayerName2) ->
	P1 = player:create(PlayerName1),
	P2 = player:create(PlayerName2),
	{P1, P2, none}.

-spec player_one_scores(state()) -> state().
player_one_scores({P1, _, _} = State) ->
	player_scores(player:get_name(P1), State).

player_two_scores({_, P2, _} = State) ->
	player_scores(player:get_name(P2), State).

player_scores(PlayerName, {P1, P2, _} = State) ->
	ScoreP1 = player:get_score(P1),
	ScoreP2 = player:get_score(P2),
 	NameP1 = player:get_name(P1),
 	NameP2 = player:get_name(P2),

	case {PlayerName, ScoreP1, ScoreP2} of
		{_, 40, 40}      -> handle_deuce(PlayerName, State);
		{NameP1, 40, _}  -> handle_win(P1, State);
		{NameP2, _, 40}  -> handle_win(P2, State);
		_                -> give_point_to_scoring_player(PlayerName, State)
	end.

give_point_to_scoring_player(ScoringPlayerName, {P1, P2, Winner}) ->
	case player:get_name(P1) of
		ScoringPlayerName -> 
			{player:give_point(P1), P2, Winner};
		_ ->    {P1, player:give_point(P2), Winner}
	end.

handle_deuce(PlayerName, {P1, P2, Winner} = State) ->
	AdvantageP1 = player:has_advantage(P1),	
	AdvantageP2 = player:has_advantage(P2),	
	NameP1 = player:get_name(P1),

	case {PlayerName, AdvantageP1, AdvantageP2} of
		{NameP1, false, false} -> {player:give_advantage(P1), P2, Winner};
		{_     , false, false} -> {P1, player:give_advantage(P2), Winner};
		{NameP1, true, _}      -> handle_win(P1, State); 	
		{NameP1, _, true}      -> {P1, player:loose_advantage(P2), Winner};
		{_, true, _}           -> {player:loose_advantage(P1), P2, Winner};
		{_, _, true}           -> handle_win(P2, State)
	end.

handle_win(Player, {P1, P2, _}) ->
	{P1, P2, player:get_name(Player)}.

-spec get_score(state()) -> tuple().
get_score({P1, P2, Winner}) when Winner =:= none ->
	ScoreP1 = player:get_score(P1),
	ScoreP2 = player:get_score(P2),
	AdvP1 = player:has_advantage(P1),	
	AdvP2 = player:has_advantage(P2),	

	case {ScoreP1, ScoreP2, AdvP1, AdvP2} of
		{40, 40, true, _} -> {advantage, 40};
		{40, 40, _, true} -> {40, advantage};
		{40, 40, _, _}    -> {deuce};
		_                 -> {ScoreP1, ScoreP2}
	end;
get_score({_, _, Winner}) ->
	{winner, Winner}.	
