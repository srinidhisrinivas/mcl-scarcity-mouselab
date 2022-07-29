local:
	coffee -o static/js -cb src/*.coffee

all: 
	coffee -o static/js -cb src/*.coffee

watch:
	coffee -o static/js -cbw src/*.coffee

clean:
	rm static/json/*
