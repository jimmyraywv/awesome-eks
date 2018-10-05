.PHONY: serve
serve: convert server

.PHONY: convert
convert:
	asciidoctor readme.adoc -o index.html

.PHONY: server
server:
	python -m SimpleHTTPServer 8080