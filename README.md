# vsh_docker_proj

A minimal Python HTTP server that listens on a configurable port and prints/returns a message for every request it receives.

## Requirements

None — uses only the Python standard library. `requirements.txt` is included (empty) for tooling that expects one.

## Running locally

```bash
python app.py
```

By default it listens on port `8080`. Set the `PORT` environment variable to use a different port:

```bash
PORT=9000 python app.py
```

Then visit `http://localhost:8080/` (or whichever port you chose) in a browser or with `curl`.

## Running with Docker

Build the image:

```bash
docker build . -t vsh_docker_proj
```

Run the container:

```bash
docker run --rm -p 8080:8080 vsh_docker_proj
```

To use a different port, set `PORT` and map it accordingly:

```bash
docker run --rm -e PORT=9000 -p 9000:9000 vsh_docker_proj
```
