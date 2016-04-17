all:
	ocamlbuild -pkgs cohttp.lwt,cmdliner redirector.native
