%Team Members:
% - [Cora Rogers, Dylan Nicks, William Wang]

-module(main).
-export([start/0]).

start() ->
    Serv3Pid = serv3:start(),
    Serv2Pid = serv2:start(Serv3Pid),
    Serv1Pid = serv1:start(Serv2Pid),
    loop(Serv1Pid).

loop(Serv1Pid) ->
    io:format("Enter a message (or 'all_done' to exit):~n"),
    Input = io:get_line("> "),
    StrippedInput = string:trim(Input),
    case StrippedInput of
        "all_done" ->
            Serv1Pid ! halt,
            io:format("Main process exiting.~n"),
            ok;
        _ ->
            case parse_input(StrippedInput) of
                {ok, Message} ->
                    Serv1Pid ! Message,
                    loop(Serv1Pid);
                {error, Reason} ->
                    io:format("Error parsing input: ~p~n", [Reason]),
                    loop(Serv1Pid)
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