% Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv2).
-export([start/1, loop/1]).

start(NextPid) ->
    spawn(serv2, loop, [NextPid]).

loop(NextPid) ->
    receive
        halt ->
            NextPid ! halt,
            io:format("(serv2) Halting.~n"),
            ok;
        Msg when is_list(Msg) ->
            case Msg of
                [Head | _] when is_integer(Head) ->
                    Sum = lists:sum([X || X <- Msg, is_number(X)]),
                    io:format("(serv2) Sum of numbers: ~p~n", [Sum]),
                    loop(NextPid);
                [Head | _] when is_float(Head) ->
                    Product = lists:foldl(fun(X, Acc) when is_number(X) -> X * Acc; (_, Acc) -> Acc end, 1, Msg),
                    io:format("(serv2) Product of numbers: ~p~n", [Product]),
                    loop(NextPid);
                _ ->
                    NextPid ! Msg,
                    loop(NextPid)
            end;
        Msg ->
            NextPid ! Msg,
            loop(NextPid)
    end.