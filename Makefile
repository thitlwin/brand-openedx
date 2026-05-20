.PHONY: build build-tokens build-scss dist clean
build: clean dist build-tokens build-scss
	cp *.svg *.png *.ico dist/
	cp -r paragon/build paragon/images dist/paragon/

dist:
	mkdir -p dist/paragon

build-tokens:
	npx paragon build-tokens --source ./paragon/tokens/ --build-dir ./paragon/build -t light

build-scss: dist
	npx paragon build-scss --corePath ./paragon/core.scss --themesPath ./paragon/build/themes --source

clean:
	rm -rf dist paragon/build
