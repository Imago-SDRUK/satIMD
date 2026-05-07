.PHONY: build_site build_jlite build_jlite_env serve_jlite

serve_site:
	quarto preview --port 4000 --host 0.0.0.0
build_site:
	# Render slides
	cd slides && quarto render imago_embeddings_workshop.qmd
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
	cd jupyterlite && mamba run -n jlite jupyter lite build \
		--XeusAddon.environment_file=environment.yaml \
		--contents content/ \
		--output-dir=_output

serve_jlite:
	mamba run -n jlite jupyter lite serve --output-dir jupyterlite/_output
