.PHONY: serve
serve: convert server

.PHONY: convert
convert:
	asciidoctor readme.adoc -o index.html

.PHONY: server
server:
	python3 -m http.server 8080