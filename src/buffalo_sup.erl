
-module(buffalo_sup).

-behaviour(supervisor).

-include("../include/buffalo.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    ets:new(buffalo, [set, named_table, public, {keypos, #buffalo_entry.key}]),
    Children = [?CHILD(buffalo_worker_sup, supervisor),
                ?CHILD(buffalo_queuer, worker)],
    {ok, { {one_for_one, 5, 10}, Children} }.

