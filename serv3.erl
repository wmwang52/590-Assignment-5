% Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv3).
-export([start/0, loop/1]).

start() ->
    spawn(serv3, loop, [0]).

loop(Acc) ->
    receive
        update ->
            io:format("(serv3) Updating code.~n"),
            serv3:loop(Acc); 
        halt ->
            io:format("(serv3) Halting. Unprocessed messages count: ~p~n", [Acc]),
            ok;
        {error, Msg} ->
            io:format("(serv3) Error: ~p~n", [Msg]),
            loop(Acc);
        Msg ->
            io:format("(serv3) Not handled: ~p~n", [Msg]),
            loop(Acc + 1)
    end.