FROM ocaml/opam:alpine
MAINTAINER Anil Madhavapeddy <anil@recoil.org>
RUN opam pin add -n http2https https://github.com/avsm/http2https.git && \
    opam depext -u http2https && \
    opam install -j 2 -y http2https
ENTRYPOINT ["opam","config","exec","--","http2https"]
