-module(game).
-compile(export_all).

-type player() :: {Name :: atom(), Point :: non_neg_integer(), Advantage :: true | false}.
-type state() :: {player(), player(), Winner :: atom()}.

-spec create(atom(), atom()) -> state().
create(PlayerName1, PlayerName2) ->
	{{PlayerName1, 0, false}, {PlayerName2, 0, false}, game}.

get_score({_, _, Winner}) when Winner =/= game ->
	{winner, Winner};
get_score({Player1, Player2, _}) ->
	case {Player1, Player2} of
		{{_, 40,    true}, {_, 40,       _}} -> {advantage ,40};
		{{_, 40,       _}, {_, 40, true   }} -> {40, advantage};
		{{_, 40,       _}, {_, 40,       _}} -> {deuce};
		{{_, 15,       _}, {_, PointsP2, _}} -> {love, PointsP2};
		{{_, PointsP1, _}, {_, 15, _      }} -> {PointsP1, love};
		{{_, PointsP1, _}, {_, PointsP2, _}} -> {PointsP1, PointsP2}
	end.

player_scores(PlayerName, {{NameP1, PointsP1, _}, {NameP2, PointsP2, _}, _} = State) ->
	case {PlayerName, PointsP1, PointsP2} of
		{_,      40, 40} -> handle_deuce(PlayerName, State);
		{NameP1, 40, _ } -> handle_win(NameP1, State);
		{NameP2, _,  40} -> handle_win(NameP2, State);
		_Else            -> give_point_to_scoring_player(PlayerName, State)
	end.

handle_deuce(PlayerName, 
	     {{NameP1, _, AdvantageP1} = Player1, 
	      {NameP2, _, AdvantageP2} = Player2, 
	      Winner} = State) ->
	case {PlayerName, AdvantageP1, AdvantageP2} of
		{NameP1, false, false} -> {give_advantage(Player1), Player2, Winner};
		{NameP2, false, false} -> {Player1, give_advantage(Player2), Winner};
		{NameP1, _,      true} -> {Player1, loose_advantage(Player2), Winner};
		{NameP2, true,      _} -> {loose_advantage(Player1), Player2, Winner};
		{NameP1, true,      _} -> handle_win(NameP1, State); 	
		{NameP2, _,      true} -> handle_win(NameP2, State)
	end.

give_point_to_scoring_player(PlayerName, {{NameP1, _, _} = Player1, 
					  Player2, 
					  Winner}) ->
	case PlayerName of
		NameP1 -> {give_point(Player1), Player2, Winner};
		_      -> {Player1, give_point(Player2), Winner}
	end.

give_point({_, Score, _} = Player) ->
	case Score of
		0 ->  set_point(Player, 15);
		15 -> set_point(Player, 30);
		30 -> set_point(Player, 40)
	end.

set_point({Name, _, Advantage}, Point) ->
	{Name, Point, Advantage}.

handle_win(PlayerName, {Player1, Player2, _}) ->
	{Player1, Player2, PlayerName}.


give_advantage({Name, Score, false}) ->
	{Name, Score, true}.

loose_advantage({Name, Score, true}) ->
	{Name, Score, false}.
