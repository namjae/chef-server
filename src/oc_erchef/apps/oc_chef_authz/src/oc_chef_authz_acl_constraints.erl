%% -*- erlang-indent-level: 4;indent-tabs-mode: nil; fill-column: 92 -*-
%% ex: ts=4 sw=4 et
%% @author Mark  Mzyk <mm@chef.io>
%% Copyright 2015 Chef, Inc. All Rights Reserved.

-module(oc_chef_authz_acl_constraints).

-export([check_acl_constraints/4]).

check_acl_constraints(AuthzId, Type, AclPerm, Ace) ->
  check_admin_group_removal_from_grant_ace(AuthzId, Type, AclPerm, Ace).

check_admin_group_removal_from_grant_ace(AuthzId, Type, AclPerm, Ace) ->
  case AclPerm of
    <<"grant">> ->
      ActorsAndGroups = ej:get({AclPerm}, Ace),
      _Groups = ej:get({<<"groups">>}, ActorsAndGroups),
      _ExistingAcl = oc_chef_authz_acl:fetch(Type, AuthzId),
      ok;
    _Other ->
      ok
  end.



