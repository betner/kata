-module(player_tests).
-include_lib("eunit/include/eunit.hrl").


create_player_test() ->
	Player = player:create(p1),
	?assert(player:get_score(Player) =:= 0),
	?assert(player:get_name(Player) =:= p1),
	?assert(player:has_advantage(Player) =:= false).

give_point_test() ->
	Player = player:create(p1),
	P15 = player:give_point(Player),
	?assert(player:get_score(P15) =:= 15),

	P30 = player:give_point(P15),
	?assert(player:get_score(P30) =:= 30),

	P40 = player:give_point(P30),
	?assert(player:get_score(P40) =:= 40),

	PAdv = player:give_advantage(P40),
	?assert(player:get_score(PAdv) =:= 40),
	?assert(player:has_advantage(PAdv) =:= true),

	?assertError(max_points_reached, player:give_point(P40)),
	?assertError(max_points_reached, player:give_point(PAdv)).

advantage_test() ->
	Player = player:create(p1),
	P40 = player:give_point(player:give_point(player:give_point(Player))),
	PAdv = player:give_advantage(P40),
	?assert(true =:= player:has_advantage(PAdv)).
