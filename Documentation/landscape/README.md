# ELISA Systems Landscape

The landscape is generated with [CNCF Landscape2](https://github.com/cncf/landscape2).
Project, standards, and event records live in separate YAML files. `build.py`
combines their categories and uses the installed `landscape2` CLI when available.
Otherwise, it falls back to the official Docker image.

## Local preview

Prerequisites: Python 3, PyYAML, and either the Landscape2 CLI or Docker with a
running daemon. With Docker, network access is needed the first time to download
the Landscape2 image. On Linux Mint, install PyYAML with `sudo apt install
python3-yaml`. From the repository root, run:

```sh
cd Documentation/landscape
python3 build.py
python3 -m http.server 8000 --directory build/site
```

Open <http://localhost:8000>. The build validates the data, settings, guide, and
logos as part of generating the site. Landscape2 may show warnings when it cannot
retrieve optional metadata from external services.

To preview with the installed CLI instead, run
`landscape2 serve --landscape-dir build/site` from `Documentation/landscape`.

To use a specific Landscape2 image tag:

```sh
LANDSCAPE2_IMAGE=ghcr.io/cncf/landscape2:<tag> python3 build.py
```

## Data files

- `projects.yml` contains the current ecosystem map.
- `standards.yml` and `events.yml` contain standards and events.
- Each listed item needs a homepage URL and an SVG logo in `hosted_logos/`.
- `placeholder.svg` is a temporary neutral mark; replace it with each project's
  approved logo as those assets are collected. `LLVM.svg` is already available.
- `settings.yml` controls the landscape identity and display, while `guide.yml`
  provides the introduction shown by Landscape2.

The generated site and merged data are written to `build/` and are not source
files.