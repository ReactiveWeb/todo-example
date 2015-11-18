all: 
	cd todo_server; ./gen_api.sh; mix deps.get; mix deps.compile; mix compile
	cd todo_client; npm install; webpack index.js index-compiled.js

run:
	echo Open web browser at http://localhost:8880/
	cd todo_server; mix run --no-halt
