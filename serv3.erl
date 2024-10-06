%Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv3).
-export([start/0, loop/1, update/1]).

start() ->
    spawn(serv3, loop, [0]).

update(Acc) ->
    io:format("(serv3) Updating to new version...~n"),
    spawn(serv3, loop, [Acc]).

loop(Acc) ->
    receive
        halt ->
            io:format("(serv3) Halting. Unprocessed messages count: ~p~n", [Acc]),
            ok;
        update ->
            io:format("(serv3) Received update message.~n"),
            update(Acc); 
        Msg ->
            io:format("(serv3) Not handled: ~p~n", [Msg]),
            loop(Acc + 1)
    end.