# http2https

This is a simple redirector that issues HTTP 302 responses to incoming HTTP
requests.  It's useful to use as a listener on port 80 to redirect traffic to
the corresponding HTTPS port on 443.

## Installation

- Use the [OPAM](https://opam.ocaml.org) package manager and run `opam install http2https`
- Or use the Docker endpoint at `docker pull avsm/http2https`

## Usage

See `http2https --help`

```
NAME
       http2https - a simple http-to-https redirector

SYNOPSIS
       http2https [OPTION]... DST_URI

DESCRIPTION
       http2https sets up a simple HTTP server that redirects all incoming
       HTTP requests to an HTTPS endpoint instead.

ARGUMENTS
       DST_URI
           URI to redirect requests to.

OPTIONS
       --help[=FMT] (default=pager)
           Show this help in format FMT (pager, plain or groff).

       -p PORT (absent=80)
           TCP port to listen on.

       -s HOST (absent=0.0.0.0)
           IP address to listen on.

       -v, --verbose
           Log requests to console.

       --version
           Show version information.

BUGS
       Report them via e-mail to <mirageos-devel@lists.xenproject.org>, or on
       the issue tracker at <https://github.com/mirage/ocaml-cohttp/issues>
```
