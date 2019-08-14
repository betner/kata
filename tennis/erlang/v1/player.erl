-module(player).
-compile(export_all).

-type score() :: 0 | 15 | 30 | 40.
-type player() :: #{name => atom(), score => score(), has_advantage => true | false}.
-export_type([player/0]).

create(Name) ->
	#{name => Name, score => 0, has_advantage => false}.

-spec get_score(player()) -> score().
get_score(#{score := Score}) ->
	Score.

-spec get_name(player()) -> atom().
get_name(#{name := Name}) ->
	Name.

-spec has_advantage(player()) -> true | false.
has_advantage(#{has_advantage := Advantage}) ->
	Advantage.

-spec give_advantage(player()) -> player().
give_advantage(#{score := 40} = Player) ->
	Player#{has_advantage := true}.

-spec loose_advantage(player()) -> player().
loose_advantage(#{has_advantage := true} = Player) ->
	Player#{has_advantage := false}.

-spec give_point(player()) -> player() | no_return().
give_point(#{has_advantage := false, score := 0} = Player) ->
	Player#{score := 15};
give_point(#{has_advantage := false, score := 15} = Player) ->
	Player#{score := 30};
give_point(#{has_advantage := false, score := 30} = Player) ->
	Player#{score := 40};
give_point(#{score := 40}) ->
	erlang:error(max_points_reached).

