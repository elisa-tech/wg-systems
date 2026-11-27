import argparse
import os
from pathlib import Path
import shutil

import yaml


ROOT = Path(__file__).resolve().parent
os.chdir(ROOT)

parser = argparse.ArgumentParser(description="Build the ELISA Systems landscape.")
parser.add_argument("--settings-file", default="settings.yml", help="Settings path relative to the landscape directory.")
options = parser.parse_args()

source_files = ("projects.yml", "standards.yml", "events.yml")
categories = []
for filename in source_files:
    with (ROOT / filename).open(encoding="utf-8") as source:
        document = yaml.safe_load(source)
    categories.extend(document["categories"])

build_dir = ROOT / "build"
build_dir.mkdir(exist_ok=True)
data_file = build_dir / "data.yml"
with data_file.open("w", encoding="utf-8") as output:
    yaml.safe_dump({"categories": categories}, output, allow_unicode=True, sort_keys=False)

arguments = [
    "build",
    "--data-file", "build/data.yml",
    "--settings-file", options.settings_file,
    "--guide-file", "guide.yml",
    "--logos-path", "hosted_logos",
    "--output-dir", "build/site",
]


def find_executable(command):
    if os.sep in command:
        path = Path(command)
        return str(path) if path.is_file() and os.access(path, os.X_OK) else None
    return shutil.which(command)


landscape2 = find_executable(os.environ.get("LANDSCAPE2_BIN", "landscape2"))
if landscape2:
    os.execv(landscape2, [landscape2, *arguments])

docker = find_executable(os.environ.get("DOCKER_BIN", "docker"))
if not docker:
    raise SystemExit("Install landscape2 or Docker to build the landscape.")

image = os.environ.get("LANDSCAPE2_IMAGE", "ghcr.io/cncf/landscape2:latest")
os.execv(
    docker,
    [
        docker, "run", "--rm",
        "--user", f"{os.getuid()}:{os.getgid()}",
        "-e", "HOME=/tmp",
        "-v", f"{ROOT}:/workspace",
        "-w", "/workspace",
        image,
        "landscape2",
        *arguments,
    ],
)