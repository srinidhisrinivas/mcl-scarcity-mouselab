local:
	cp templates/exp.html index.html
	coffee -o static/js -cb src/*

all: 
	coffee -o static/js -cb src/*

watch:
	coffee -o static/js -cbw src/*

clean:
	rm static/json/*

demo:
	coffee -o static/js -cb src/*
	cp templates/demo.html index.html
	rsync -av --delete-after --copy-links . user@psi.is.tuebingen.mpg.de:experiments/cognitive-tutor-demo/
