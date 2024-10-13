% Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv2).
-export([start/1, loop/1]).
-define(VERSION, 1). 

start(NextPid) ->
    spawn(?MODULE, loop, [NextPid]).

loop(NextPid) ->
    receive
        update ->
            io:format("(serv2 v~p) Updating code.~n", [?VERSION]),
            code:purge(?MODULE),          
            compile:file(?MODULE),        
            code:load_file(?MODULE),      
            ?MODULE:loop(NextPid);        

        halt ->
            NextPid ! halt,
            io:format("(serv2) Halting.~n"),
            ok;
        Msg when is_list(Msg) ->
            case Msg of
                [Head | _] when is_integer(Head) ->
                    Sum = lists:sum([X || X <- Msg, is_number(X)]),
                    io:format("(serv2 v~p) Sum of numbers: ~p~n", [?VERSION, Sum]),
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