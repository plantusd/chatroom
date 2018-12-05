-module(chat_room_manager_sup).
-export([start_link/0, init/1, add_worker/1, remove_worker/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

add_worker(WorkerId) ->
    supervisor:start_child(?MODULE, spec(WorkerId)).

remove_worker(WorkerId) ->
    supervisor:terminate_child(?MODULE, WorkerId),
    supervisor:delete_child(?MODULE, WorkerId).

init(_Args) ->
    SupSpec = #{strategy => one_for_one,
                                intensity => 10,
                                period => 1000},
    Worker1 = spec(chat_room_manager),
    {ok, {SupSpec, [Worker1]}}.


spec(WorkerId) ->
    #{id => WorkerId,
      start => {chat_room_manager, start_link, [WorkerId]},
      restart => permanent,
      shutdown => 2000,
      type => worker,
      modules => [worker]
     }.