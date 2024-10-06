%Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(serv1).
-export([start/1, loop/1]).

start(NextPid) ->
    spawn(serv1, loop, [NextPid]).

loop(NextPid) ->
    receive
        halt ->
            NextPid ! halt,
            io:format("(serv1) Halting.~n"),
            ok;
        {Op, A, B} when is_atom(Op), is_number(A), is_number(B) ->
            case Op of
                'add' ->
                    Result = A + B,
                    io:format("(serv1) ~p + ~p = ~p~n", [A, B, Result]),
                    loop(NextPid);
                'sub' ->
                    Result = A - B,
                    io:format("(serv1) ~p - ~p = ~p~n", [A, B, Result]),
                    loop(NextPid);
                'mult' ->
                    Result = A * B,
                    io:format("(serv1) ~p * ~p = ~p~n", [A, B, Result]),
                    loop(NextPid);
                'div' when B =/= 0 ->
                    Result = A / B,
                    io:format("(serv1) ~p / ~p = ~p~n", [A, B, Result]),
                    loop(NextPid);
                'div' ->
                    io:format("(serv1) Error: division by zero~n"),
                    loop(NextPid);
                _ ->
                    NextPid ! {Op, A, B},
                    loop(NextPid)
            end;
        {Op, A} when is_atom(Op), is_number(A) ->
            case Op of
                'neg' ->
                    Result = -A,
                    io:format("(serv1) neg ~p = ~p~n", [A, Result]),
                    loop(NextPid);
                'sqrt' when A >= 0 ->
                    Result = math:sqrt(A),
                    io:format("(serv1) sqrt ~p = ~p~n", [A, Result]),
                    loop(NextPid);
                'sqrt' ->
                    io:format("(serv1) Error: sqrt of negative number~n"),
                    loop(NextPid);
                _ ->
                    NextPid ! {Op, A},
                    loop(NextPid)
            end;
        Msg ->
            NextPid ! Msg,
            loop(NextPid)
    end.