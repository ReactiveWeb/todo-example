#!/usr/bin/env bash
cd deps/reactive_api/
mix run gencjs.exs ../../lib/todo/api.ex ../../../todo_client/api.gen.js
cd ../..
