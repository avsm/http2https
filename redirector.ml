(*
 * Copyright (c) 2012-2016 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open Lwt
open Printf

let handler dst_uri verbose con_id req body =
  let src_uri = Cohttp.Request.uri req in
  let path = Uri.path src_uri in
  let dst_uri = Uri.of_string (dst_uri ^ path) in
  if verbose then printf "%s -> %s\n%!" (Uri.to_string src_uri) (Uri.to_string dst_uri);
  Cohttp_lwt_unix.Server.respond_redirect ~uri:dst_uri ()

let run host port dst_uri verbose =
  Sys.set_signal Sys.sigpipe Sys.Signal_ignore;
  printf "Listening for HTTP requests on: %s %d\n%!" host port;
  Lwt_unix.run (
    let open Lwt.Infix in
    let mode = `TCP (`Port port) in
    Conduit_lwt_unix.init ~src:host () >>= fun ctx ->
    let ctx = Cohttp_lwt_unix_net.init ~ctx () in
    Cohttp_lwt_unix.Server.(create ~ctx ~mode (make ~callback:(handler dst_uri verbose) ()))
  )

open Cmdliner

let host =
  let doc = "IP address to listen on." in
  Arg.(value & opt string "0.0.0.0" & info ["s"] ~docv:"HOST" ~doc)

let port =
  let doc = "TCP port to listen on." in
  Arg.(value & opt int 80 & info ["p"] ~docv:"PORT" ~doc)

let dst_uri =
  let doc = "URI to redirect requests to." in
  Arg.(required & pos 0 (some string) None & info [] ~docv:"DST_URI" ~doc)

let verb =
  let doc = "Log requests to console." in
  Arg.(value & flag & info ["v"; "verbose"] ~doc)

let cmd =
  let doc = "a simple http-to-https redirector" in
  let man = [
    `S "DESCRIPTION";
    `P "$(tname) sets up a simple HTTP server that redirects all incoming HTTP requests to an HTTPS endpoint instead.";
    `S "BUGS";
    `P "Report them via e-mail to <mirageos-devel@lists.xenproject.org>, or \
        on the issue tracker at <https://github.com/mirage/ocaml-cohttp/issues>";
  ] in
  Term.(pure run $ host $ port $ dst_uri $ verb),
  Term.info "http2https" ~version:"1.0.0" ~doc ~man

let () = match Term.eval cmd with | `Error _ -> exit 1 | _ -> exit 0

