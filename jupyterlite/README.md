# Build instructions

## 1. Install host-side dependencies

```bash
mamba install -c conda-forge jupyterlite-core jupyterlite-xeus micromamba
```

## 2. Build

```bash
jupyter lite build \
  --XeusAddon.environment_file=environment.yaml \
  --contents content/ \
  --output-dir=_output
```

The static site is placed in `_output/`.

## 3. Serve locally (optional)

```bash
python -m http.server 8000 --directory _output
```

Then open `http://localhost:8000`.

## Rebuild after changes

```bash
rm -rf _output .jupyterlite.doit.db
jupyter lite build \
  --XeusAddon.environment_file=environment.yaml \
  --contents content/ \
  --output-dir=_output
```
