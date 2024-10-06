%Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv1).
-export([start/1, loop/1, update/1]).

start(NextPid) ->
    spawn(serv1, loop, [NextPid]).

update(NextPid) ->
    io:format("(serv1) Updating to new version...~n"),
    spawn(serv1, loop, [NextPid]). 

loop(NextPid) ->
    receive
        halt ->
            NextPid ! halt,
            io:format("(serv1) Halting.~n"),
            ok;
        update ->
            io:format("(serv1) Received update message.~n"),
            update(NextPid);  
        {Op, A, B} when is_atom(Op), is_number(A), is_number(B) ->
            case Op of
                'add' ->
                    Result = A + B,
                    io:format("(serv1) ~p + ~p = ~p~n", [A, B, Result]),
                    loop(NextPid);
                _ ->
                    NextPid ! {Op, A, B},
                    loop(NextPid)
            end;
        Msg ->
            NextPid ! Msg,
            loop(NextPid)
    end.