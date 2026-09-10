# OGS-NUMO

Reproducible OGS build for the NUMO ComponentTransport / PHREEQC validation case.

This repository provides a reproducible installer for the exact corrected OGS source used in the NUMO investigation. The numerical correction is a positivity-preserving, RHS-consistent row-sum lumping of the ComponentTransport reaction projection.

## Exact validated source

- Source repository: `kuateric/ogs`
- Branch used during validation: `agent/numo-reaction-mass-lumping-6.5.8`
- Exact validated commit: `5e0c4c0971996d36112e30508074d8f56fb2a60d`
- Core correction commit: `c31898e2de9a29fa131b959cf52455986c69e98e`

## Important scope

The correction removes the previously observed negative-concentration / NaN projection problem in the NUMO case. It does **not** modify the NUMO chemistry, physics, boundary conditions, stabilization, or time stepping.

The original NUMO project/input files are intentionally **not redistributed here**. Place the original files supplied by NUMO into `numo-case/` and keep their original filenames. This avoids publishing project data while still allowing an exact reproduction with the corrected executable.

## Build and run

On a Linux machine with the normal OGS build prerequisites:

```bash
git clone https://github.com/kuateric/ogs-numo.git
cd ogs-numo
./scripts/install_ogs_numo.sh
```

This clones the exact validated OGS commit and builds the `ComponentTransport` process.

Then copy the original NUMO case files into `numo-case/` and run:

```bash
./scripts/run_numo.sh
```

The wrapper refuses to run if the expected project file is missing.

## NUMO case filename expected

`shotcrete4_linear_closed_fixed_primary_D1e-12.prj`

The investigation established that the corrected transport formulation remains finite through time step 40. The very long Step40 runtime is dominated by PHREEQC chemistry in local chemical system 7; Step41 subsequently fails during initial aqueous speciation of the same local system. Those chemistry diagnostics are separate from the ComponentTransport mass-lumping correction.

## License

The OGS source cloned by the installer remains under the OpenGeoSys BSD-3-Clause license. See the upstream OGS license for details.
