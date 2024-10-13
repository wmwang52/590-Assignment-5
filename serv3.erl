% Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv3).
-export([start/0, loop/1]).
-define(VERSION, 1).

start() ->
    spawn(?MODULE, loop, [0]).

loop(Acc) ->
    receive
        update ->
            io:format("(serv3 v~p) Updating code.~n", [?VERSION]),
            code:purge(?MODULE),          
            compile:file(?MODULE),        
            code:load_file(?MODULE),      
            ?MODULE:loop(Acc);        
        halt ->
            io:format("(serv3) Halting. Unprocessed messages count: ~p~n", [Acc]),
            ok;
        {error, Msg} ->
            io:format("(serv3 v~p) Error: ~p~n", [?VERSION, Msg]),
            loop(Acc);
        Msg ->
            io:format("(serv3) Not handled: ~p~n", [Msg]),
            loop(Acc + 1)
    end.