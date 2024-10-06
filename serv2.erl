%Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv2).
-export([start/1, loop/1, update/1]).

start(NextPid) ->
    spawn(serv2, loop, [NextPid]).

update(NextPid) ->
    io:format("(serv2) Updating to new version...~n"),
    spawn(serv2, loop, [NextPid]).

loop(NextPid) ->
    receive
        halt ->
            NextPid ! halt,
            io:format("(serv2) Halting.~n"),
            ok;
        update ->
            io:format("(serv2) Received update message.~n"),
            update(NextPid); 
        Msg when is_list(Msg) ->
            case Msg of
                [Head | _] when is_integer(Head) ->
                    Sum = lists:sum([X || X <- Msg, is_number(X)]),
                    io:format("(serv2) Sum of numbers: ~p~n", [Sum]),
                    loop(NextPid);
                _ ->
                    NextPid ! Msg,
                    loop(NextPid)
            end;
        Msg ->
            NextPid ! Msg,
            loop(NextPid)
    end.