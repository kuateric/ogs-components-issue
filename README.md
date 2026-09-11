# OpenGeoSys ComponentTransport reaction mass-lumping correction

This public repository contains a complete OpenGeoSys source snapshot with a correction to the ComponentTransport/PHREEQC reaction projection.

## Corrected source state

- Source basis: OpenGeoSys 6.5.8 development line used during the investigation.
- Validated corrected source origin: `kuateric/ogs@5e0c4c0971996d36112e30508074d8f56fb2a60d`.
- The ComponentTransport correction is integrated directly in `ProcessLib/ComponentTransport/ComponentTransportFEM.h`.
- No patch script and no second OGS repository are required.
- The correction does not require changes to model chemistry, physics, boundary conditions, or time stepping.

The correction uses an RHS-consistent, row-sum-lumped reaction projection for the ComponentTransport/PHREEQC coupling. It addresses projection-induced negative nodal concentrations and resulting NaN behaviour while preserving the element-integrated reaction mass.

Detailed source provenance is recorded in [`SOURCE_PROVENANCE.md`](SOURCE_PROVENANCE.md).

## 1. Clone

```bash
git clone https://github.com/kuateric/ogs-components-issue.git
cd ogs-components-issue
```

## 2. Install build prerequisites (Ubuntu 24.04)

```bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  build-essential cmake ninja-build git python3
```

OGS obtains the remaining third-party dependencies through its normal CMake/CPM mechanism during configuration.

## 3. Configure a focused ComponentTransport build

```bash
cmake --preset release \
  -DOGS_BUILD_GUI=OFF \
  -DOGS_BUILD_UTILS=OFF \
  -DOGS_BUILD_TESTING=OFF \
  '-DOGS_BUILD_PROCESSES=ComponentTransport'
```

## 4. Build OGS

A low parallelism is recommended on memory-limited machines:

```bash
cmake --build --preset release --parallel 2 --target ogs
```

If compilation runs out of memory, repeat with:

```bash
cmake --build --preset release --parallel 1 --target ogs
```

With the standard preset layout, the executable is normally located under:

```text
../build/release/bin/ogs
```

Check the executable with:

```bash
../build/release/bin/ogs --version
```

Because this repository is a self-contained source snapshot with its own Git history, `ogs --version` reports the current repository snapshot commit. The exact validated source origin is documented above and in `SOURCE_PROVENANCE.md`.

## 5. Run a ComponentTransport/PHREEQC project

Keep project-specific input data outside the public repository when those files are not intended for publication. From the directory containing a project file, run for example:

```bash
/path/to/build/release/bin/ogs \
  project.prj \
  -o results
```

## Build verification

This public source snapshot has been independently configured and compiled on a GitHub-hosted Ubuntu 24.04 runner. Verification run `34542043880` completed successfully and produced the corrected ComponentTransport-enabled `ogs` executable.

## Reproducibility note

The source snapshot is intentionally distributed as a directly buildable repository. A repository-local GitHub Actions build check verifies that the public snapshot still configures and builds the corrected ComponentTransport executable on Ubuntu 24.04.

## License

OpenGeoSys is distributed under the Modified BSD License. The original `LICENSE.txt` is retained in this repository.

## OpenGeoSys

OpenGeoSys is an open-source scientific project for coupled thermo-hydro-mechanical-chemical processes in porous and fractured media. General documentation is available at https://www.opengeosys.org/docs/.
