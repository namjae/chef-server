%% -*- erlang-indent-level: 4;indent-tabs-mode: nil; fill-column: 92 -*-
%% ex: ts=4 sw=4 et
%% @author Mark  Mzyk <mm@chef.io>
%% Copyright 2015 Chef, Inc. All Rights Reserved.

-module(oc_chef_authz_acl_constraints).

-export([check_acl_constraints/4]).

check_acl_constraints(AuthzId, Type, AclPerm, Ace) ->
  check_admin_group_removal_from_grant_ace(AuthzId, Type, AclPerm, Ace).

check_admin_group_removal_from_grant_ace(AuthzId, Type, AclPerm, NewAce) ->
  case AclPerm of
    <<"grant">> ->
      check_admin_group_removal(AuthzId, Type, AclPerm, NewAce);
    _Other ->
      ok
  end.

check_admin_group_removal(AuthzId, Type, AclPerm, NewAce) ->
      NewGroups = extract_acl_groups(AclPerm, NewAce),
      CurrentAce = oc_chef_authz_acl:fetch(Type, AuthzId),
      CurrentGroups = extract_acl_groups(AclPerm, CurrentAce),

      %% Check if the CurrentGroups contains the admin group -
      %% if it doesn't, there is nothing to do. If it does,
      %% then check if the admin group is present in the
      %% new group. If it isn't, fail.
      %% This will have the effect that if a group doesn't have the
      %% admin group on the grant ace, but then it is later added, that admin group
      %% will never be able to be removed.
      %% Should we restrict this check to only the grant aces of certain objects
      %% to prevent this being an issue?
      case contains_admin_group(CurrentGroups) of
        false ->
          ok;
        true ->
          case contains_admin_group(NewGroups) of
            true ->
              ok;
            false ->
              ok %% Actually, not okay, need to return something else
          end
      end.

contains_admin_group(Groups) ->
  case lists:filter(fun(X) -> X =:= <<"admins">> end, Groups) of
    [] ->
        false;
    _NonEmpty ->
        true
    end.

extract_acl_groups(AclPerm, Ace) ->
      ActorsAndGroups = ej:get({AclPerm}, Ace),
      ej:get({<<"groups">>}, ActorsAndGroups).


