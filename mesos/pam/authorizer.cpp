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

#include "authorizer.hpp"

extern "C" {
#include <security/pam_appl.h>
}

#include <string>
#include <vector>

#include <mesos/mesos.hpp>
#include <mesos/authorizer/acls.hpp>

#include <process/dispatch.hpp>
#include <process/future.hpp>
#include <process/id.hpp>
#include <process/process.hpp>
#include <process/protobuf.hpp>

#include <stout/foreach.hpp>
#include <stout/option.hpp>
#include <stout/path.hpp>
#include <stout/protobuf.hpp>
#include <stout/try.hpp>

using process::Failure;
using process::Future;
using process::dispatch;

using std::string;
using std::vector;

namespace eos {
namespace mesos {

struct pam_response *reply;

//function used to get user input
int input(int num_msg,
    const struct pam_message **msg,
    struct pam_response **resp,
    void *appdata_ptr)
{
  *resp = reply;
  return PAM_SUCCESS;
};


class PAMAuthorizerProcess : public ProtobufProcess<PAMAuthorizerProcess>
{
public:
  PAMAuthorizerProcess()
    : ProcessBase(process::ID::generate("pam")) {}

  virtual void initialize() { }

  Future<bool> authorized(const ::mesos::authorization::Request& request)
  {
    const struct pam_conv conversation = { input, NULL };
    pam_handle_t *handler = 0;

    const char* username = request.subject().value().c_str();

    int retval;
    retval = pam_start("login", username, &conversation, &handler);

    if (retval != PAM_SUCCESS) {
      return 0;
    }

    ::eos::mesos::reply = (struct pam_response *)malloc(sizeof(struct pam_response));

    ::eos::mesos::reply->resp = strdup("test");
    ::eos::mesos::reply->resp_retcode = 0;

    retval = pam_authenticate(handler, 0);

    if (retval != PAM_SUCCESS) {
      return 0;
    }

    retval = pam_end(handler, retval);

    if (retval != PAM_SUCCESS) {
      return 0;
    }

    return 1;
  }
};


Try<::mesos::Authorizer*> PAMAuthorizer::create(const ::mesos::ACLs& acls)
{
  Authorizer* local = new PAMAuthorizer();

  return local;
}


Try<::mesos::Authorizer*> PAMAuthorizer::create(const ::mesos::Parameters& parameters)
{
  return new eos::mesos::PAMAuthorizer();
}


PAMAuthorizer::PAMAuthorizer()
    : process(new PAMAuthorizerProcess())
{
  spawn(process);
}


PAMAuthorizer::~PAMAuthorizer()
{
  if (process != NULL) {
    terminate(process);
    wait(process);
    delete process;
  }
}


process::Future<bool> PAMAuthorizer::authorized(
  const ::mesos::authorization::Request& request)
{
  typedef Future<bool> (PAMAuthorizerProcess::*F)(
      const ::mesos::authorization::Request&);

  return dispatch(
      process,
      static_cast<F>(&PAMAuthorizerProcess::authorized),
      request);
}

} // namespace mesos {
} // namespace eos {
