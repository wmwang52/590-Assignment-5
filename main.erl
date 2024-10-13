% Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(main).
-export([start/0]).

start() ->
    Serv3Pid = serv3:start(),
    Serv2Pid = serv2:start(Serv3Pid),
    Serv1Pid = serv1:start(Serv2Pid),
    loop(Serv1Pid, Serv2Pid, Serv3Pid).

loop(Serv1Pid, Serv2Pid, Serv3Pid) ->
    io:format("Enter a message (or 'all_done' to exit):~n"),
    Input = io:get_line("> "),
    StrippedInput = string:trim(Input),
    case StrippedInput of
        "all_done" ->
            Serv1Pid ! halt,
            io:format("Main process exiting.~n"),
            ok;
        "update1" ->
            Serv1Pid ! update, 
            io:format("Sent update to serv1.~n"),
            loop(Serv1Pid, Serv2Pid, Serv3Pid);
        "update2" ->
            Serv2Pid ! update, 
            io:format("Sent update to serv2.~n"),
            loop(Serv1Pid, Serv2Pid, Serv3Pid);
        "update3" ->
            Serv3Pid ! update,
            io:format("Sent update to serv3.~n"),
            loop(Serv1Pid, Serv2Pid, Serv3Pid);
        _ ->
            case parse_input(StrippedInput) of
                {ok, Message} ->
                    Serv1Pid ! Message,
                    loop(Serv1Pid, Serv2Pid, Serv3Pid);
                {error, Reason} ->
                    io:format("Error parsing input: ~p~n", [Reason]),
                    loop(Serv1Pid, Serv2Pid, Serv3Pid)
            end
    end.

parse_input(Input) ->
    case erl_scan:string(Input++".") of
        {ok, Tokens, _} ->
            case erl_parse:parse_exprs(Tokens) of
                {ok, [Expr]} ->
                    {value, Term, _} = erl_eval:expr(Expr, []),
                    {ok, Term};
                {error, Error} ->
                    {error, Error}
            end;
        {error, Error, _} ->
            {error, Error}
    end.