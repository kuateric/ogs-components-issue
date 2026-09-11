# Source provenance

This repository is a public, directly buildable source snapshot for the NUMO reactive-transport reproduction case.

## Validated origin

The snapshot was created from the exact corrected OGS source state used in the NUMO investigation:

- Source repository: `kuateric/ogs`
- Exact validated source commit: `5e0c4c0971996d36112e30508074d8f56fb2a60d`
- ComponentTransport correction commit included in that source state: `c31898e2de9a29fa131b959cf52455986c69e98e`
- Correction location: `ProcessLib/ComponentTransport/ComponentTransportFEM.h`
- Correction marker: `NUMO: positivity-preserving row-sum lumping of the reaction projection`

The public snapshot intentionally has its own Git history so that NUMO only needs to clone `kuateric/ogs-numo`. Consequently, `ogs --version` reports the current `ogs-numo` snapshot commit rather than the historical `kuateric/ogs` commit above. The source provenance is therefore recorded explicitly here and in `README.md`.

## Build verification

The snapshot was independently configured and built on a GitHub-hosted Ubuntu 24.04 runner using:

```bash
cmake --preset release \
  -DOGS_BUILD_GUI=OFF \
  -DOGS_BUILD_UTILS=OFF \
  -DOGS_BUILD_TESTING=OFF \
  '-DOGS_BUILD_PROCESSES=ComponentTransport'

cmake --build --preset release --parallel 2 --target ogs
```

GitHub Actions verification run `34542043880` completed successfully on 2026-09-10/11. The build produced `../build/release/bin/ogs`, and the workflow also verified that `LICENSE.txt`, `CMakeLists.txt`, and the NUMO correction marker are present.

## Dependencies and submodules

No Git submodules are required by this snapshot (`.gitmodules` is empty). Third-party dependencies required by the focused build are resolved through the normal OGS CMake/CPM mechanism. The successful hosted build fetched and built those dependencies without using the BGE/AWS self-hosted runner.

## NUMO model files

The original NUMO project, mesh, PHREEQC input/output, and database files are not published in this public repository. They must be supplied locally by NUMO exactly as described in `README.md`.
