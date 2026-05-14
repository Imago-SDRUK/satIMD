.PHONY: build_site build_jlite build_jlite_env serve_jlite

serve_site:
	quarto preview --port 4000 --host 0.0.0.0
build_site:
	# Render slides
	cd slides && quarto render lab_setup.qmd
	# Render site
	quarto render
	# Post-render provision
	rm -rf docs/slides
	cp -r slides/ docs/slides/
	rm -rf docs/assets/jupyterlite
	cp -r jupyterlite/_output docs/assets/jupyterlite

build_jlite_env:
	mamba create -yn jlite
	mamba install -n jlite -c conda-forge jupyterlite-core jupyterlite-xeus micromamba jupyterlab-geojson jupyter_server

build_jlite:
	# Clean previous build
	rm -rf jupyterlite/_output jupyterlite/.jupyterlite.doit.db
	# Build JupyterLite
	cd jupyterlite && /opt/conda/condabin/mamba run -n jlite jupyter lite build \
		--XeusAddon.environment_file=environment.yaml \
		--XeusAddon.mount_jupyterlite_content=True \
		--contents content/ \
		--output-dir=_output \
		2>&1 | tee build_jlite.log
	# Register mount_0.tar.gz in empack_env_meta.json (workaround for jupyterlite-xeus bug)
	/opt/conda/condabin/mamba run -n jlite python -c "\
import json; \
f='jupyterlite/_output/xeus/xeus-lite-wasm/empack_env_meta.json'; \
d=json.load(open(f)); \
d.setdefault('mounts',[{'filename':'mount_0.tar.gz'}]); \
json.dump(d,open(f,'w'),indent=2) \
"

serve_jlite:
	/opt/conda/condabin/mamba run -n jlite python jupyterlite/serve.py 8000 jupyterlite/_output \
		2>&1 | tee jupyterlite/serve_jlite.log
