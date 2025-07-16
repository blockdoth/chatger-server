-module(main).
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    %% Your code here, e.g. spawn TCP listener
    {ok, ListenSocket} = gen_tcp:listen(1234, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]),
    spawn(fun() -> accept(ListenSocket) end),
    {ok, self()}.

stop(_State) ->
    ok.

accept(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> handle(Socket) end),
    accept(ListenSocket).

handle(Socket) ->
    case gen_tcp:recv(Socket, 0) of
        {ok, Data} ->
            io:format("Received: ~p~n", [Data]),
            gen_tcp:send(Socket, <<"Echo: ", Data/binary>>),
            handle(Socket);
        {error, closed} ->
            gen_tcp:close(Socket)
    end.
