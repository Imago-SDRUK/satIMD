import os, sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

class Handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        super().end_headers()
    def log_message(self, fmt, *args):
        pass  # suppress per-request noise

port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
root = sys.argv[2] if len(sys.argv) > 2 else "."
os.chdir(root)
print(f"Serving {root} on http://0.0.0.0:{port}")
HTTPServer(("0.0.0.0", port), Handler).serve_forever()
