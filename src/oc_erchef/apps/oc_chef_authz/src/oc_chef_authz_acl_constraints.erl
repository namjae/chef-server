%% -*- erlang-indent-level: 4;indent-tabs-mode: nil; fill-column: 92 -*-
%% ex: ts=4 sw=4 et
%% @author Mark  Mzyk <mm@chef.io>
%% Copyright 2015 Chef, Inc. All Rights Reserved.

-module(oc_chef_authz_acl_constraints).

-export([check_acl_constraints/2]).

check_acl_constraints(AclPerm, Ace) ->
  check_admin_group_removal_from_grant_ace(AclPerm, Ace).

check_admin_group_removal_from_grant_ace(AclPerm, Ace) ->
  case AclPerm of
    <<"grant">> ->
      ok;
    _Other ->
      ok
  end.

