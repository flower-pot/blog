---
layout: post
title: How to test RESTful API Clients
---

All my current projects involve a RESTful JSON API that is consumed by multiple
clients. While it is pretty easy to write integration tests for the API itself
it can be tricky to do so for the clients.

In one of my projects ([duse-io](https://github.com/duse-io/)) there are client
libraries for several languages. We first wanted a common approach for testing
all clients. Since the API is documented with apiary, we thougth we can just
test against the generated mock API.

However we soon noticed, that the mock API did not fully statisfy our needs.
The problem with apiarys mock API is that it can only be used for one case for
every route. In other words you can only test one case of each route of the
clients use of the API. No one can really call that tested.

Our next idea was to write a mocked API ourselves and test against those.
But once we started writing the mock API we noticed something else, we were
writing the server all over again.

The current solution is to use something similar to webmock in each language,
which we believe is the best way to tackle the problem, since we can specify
the APIs behaviour for each test.

Even though this approach works it creates a redundancy among all of our client
libraries: we are constantly syncronizing tests between the libaries. One
acronym: DRY. There should be a better way.

Edit: It turns out I am not the only one bothering this. I found
[pact](https://github.com/realestate-com-au/pact), which can be used to specify
how a client wants to use an API and it generates tests for the api as well as
mocks for the client.

