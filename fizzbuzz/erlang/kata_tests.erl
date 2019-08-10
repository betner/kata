-module(kata_tests).

-include_lib("eunit/include/eunit.hrl").

fizzbuzz_test_() ->
	[?_assert(kata:fizzbuzz(3) =:= fizz),
	 ?_assert(kata:fizzbuzz(5) =:= buzz),
	 ?_assert(kata:fizzbuzz(15) =:= fizzbuzz),
	 ?_assert(kata:fizzbuzz(4) =:= 4),
	 ?_assert(kata:fizzbuzz(31) =:= 31),
	 ?_assert(kata:fizzbuzz(52) =:= 52)].
