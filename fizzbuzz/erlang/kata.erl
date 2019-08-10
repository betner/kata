-module(kata).
-compile(export_all).

do() ->
	[io:format("~p\n", [fizzbuzz(Elem)]) || Elem <- lists:seq(0, 100)].

fizzbuzz(Number) when Number rem (3 * 5) == 0 ->
	fizzbuzz;
fizzbuzz(Number) when Number rem 3 == 0 ->
	fizz;
fizzbuzz(Number) when Number rem 5 == 0 ->
	buzz;
fizzbuzz(Number) ->
	Number.
