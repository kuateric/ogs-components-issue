# OGS-NUMO reproducible source package

This public repository contains a complete OpenGeoSys source snapshot prepared for reproducing the NUMO reactive-transport calculation discussed with BGE TECHNOLOGY.

## Validated source state

- Source basis: OpenGeoSys 6.5.8 development line used for the NUMO investigation.
- Validated corrected source commit in `kuateric/ogs`: `5e0c4c0971996d36112e30508074d8f56fb2a60d`.
- The ComponentTransport correction is already integrated directly in `ProcessLib/ComponentTransport/ComponentTransportFEM.h`.
- No patch script and no second OGS repository are required.
- The NUMO chemistry, physics, boundary conditions and time stepping are not modified by this repository.

The correction uses an RHS-consistent, row-sum-lumped reaction projection for the ComponentTransport/PHREEQC coupling. It removes the projection-induced negative nodal concentration/NaN behaviour found in the original calculation while preserving the element-integrated reaction mass.

Detailed source provenance is recorded in [`SOURCE_PROVENANCE.md`](SOURCE_PROVENANCE.md).

## 1. Clone

```bash
git clone https://github.com/kuateric/ogs-numo.git
cd ogs-numo
```

## 2. Install build prerequisites (Ubuntu 24.04)

```bash
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  build-essential cmake ninja-build git python3
```

OGS obtains the remaining third-party dependencies through its normal CMake/CPM mechanism during configuration.

## 3. Configure the focused ComponentTransport build

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

Because this repository is a self-contained source snapshot with its own Git history, `ogs --version` reports the current `ogs-numo` snapshot commit. The exact validated source origin remains `kuateric/ogs@5e0c4c0971996d36112e30508074d8f56fb2a60d` as documented above and in `SOURCE_PROVENANCE.md`.

## 5. Place the original NUMO input files locally

The NUMO project files are intentionally **not published in this public repository**. Use the original files already available to NUMO and place them together in a local directory, for example `numo-case/`.

The calculation used the following original filenames:

```text
shotcrete4_linear_closed_fixed_primary_D1e-12.prj
shotcrete4_linear5nodes.vtu
fixed_groundwater.vtu
shotcrete4_linear_closed_fixed_primary_D1e-12_phreeqc.inp
shotcrete4_linear_closed_fixed_primary_D1e-12_phreeqc.out
PHREEQC17v108_beta_with_exchange_cvode_knobs1e-12_kin1e-12_cells1-100_d2u.dat
```

If the local copies contain download suffixes such as `(2)` or `(3)`, keep the file contents unchanged but use the filenames referenced by the `.prj` and PHREEQC input files.

## 6. Run the unchanged NUMO project

From the directory containing the NUMO files:

```bash
/path/to/build/release/bin/ogs \
  shotcrete4_linear_closed_fixed_primary_D1e-12.prj \
  -o results
```

For example, when the local case is stored at `ogs-numo/numo-case/` and the standard preset was used:

```bash
cd numo-case
mkdir -p results
../../build/release/bin/ogs \
  shotcrete4_linear_closed_fixed_primary_D1e-12.prj \
  -o results
```

## Build verification

The public source snapshot has been independently configured and compiled on a GitHub-hosted Ubuntu 24.04 runner. Verification run `34542043880` completed successfully and produced the corrected ComponentTransport-enabled `ogs` executable. The AWS/BGE self-hosted runner was not used for this packaging verification.

## Reproducibility note

The source snapshot is intentionally distributed as a directly buildable repository. A small repository-local GitHub Actions build check verifies that the public snapshot still configures and builds the corrected ComponentTransport executable on Ubuntu 24.04.

## License

OpenGeoSys is distributed under the Modified BSD License. The original `LICENSE.txt` is retained in this repository.

## OpenGeoSys

OpenGeoSys is an open-source scientific project for coupled thermo-hydro-mechanical-chemical processes in porous and fractured media. General OGS documentation is available at https://www.opengeosys.org/docs/.
