-module(chat_room_sup).
-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link(?MODULE, []).

init(_Args) ->
    SupSpec = #{strategy => one_for_one,
                                intensity => 10,
                                period => 1000},
    ChildSpec = #{id => chat_room,
                 start => {chat_room, start_link, [1]},
                 restart => permanent,
                 shutdown => 2000,
                 type => worker,
                 modules => [worker]
                },
    {ok, {SupSpec, [ChildSpec]}}.