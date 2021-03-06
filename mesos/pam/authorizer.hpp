// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef __PAM_AUTHORIZER_HPP__
#define __PAM_AUTHORIZER_HPP__

#include <mesos/authorizer/authorizer.hpp>

#include <process/future.hpp>
#include <process/once.hpp>

#include <stout/nothing.hpp>
#include <stout/option.hpp>
#include <stout/try.hpp>

namespace eos {
namespace mesos {

// Forward declaration.
class PAMAuthorizerProcess;

// This Authorizer is constructed with all the required ACLs upfront.
class PAMAuthorizer : public ::mesos::Authorizer
{
public:
  // Creates a PAMAuthorizer.
  // Never returns a nullptr, instead sets the Try to error.
  //
  // This factory needs to return a raw pointer so it can be
  // used in typed tests.
  static Try<::mesos::Authorizer*> create(const ::mesos::ACLs& acls);

  // Creates a PAMAuthorizer.
  // Never returns a nullptr, instead sets the Try to error.
  //
  // This factory needs to return a raw pointer so it can be
  // used in typed tests.
  //
  // It extracts its ACLs from a parameter with key 'acls'.
  // If such key does not exists or its contents cannot be
  // parse, an error is returned.
  static Try<::mesos::Authorizer*> create(const ::mesos::Parameters& parameters);

  virtual ~PAMAuthorizer();

  virtual process::Future<bool> authorized(
      const ::mesos::authorization::Request& request);

private:
  PAMAuthorizer();

  PAMAuthorizerProcess* process;
};

} // namespace mesos {
} // namespace eos {

#endif // __PAM_AUTHORIZER_HPP__
