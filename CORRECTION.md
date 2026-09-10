# ComponentTransport correction used for NUMO

The validated OGS source contains the correction directly in:

`ProcessLib/ComponentTransport/ComponentTransportFEM.h`

Core correction commit:

`c31898e2de9a29fa131b959cf52455986c69e98e`

Exact validated source/runtime commit:

`5e0c4c0971996d36112e30508074d8f56fb2a60d`

## Numerical purpose

For the reaction projection, let `M_C` be the consistent reaction mass matrix, `M_L` its row-sum lumped counterpart, and `C_old` the nodal concentration vector. Replacing only `M_C` by `M_L` would make the already assembled reaction source inconsistent. The implemented correction therefore uses row-sum lumping together with the matching RHS compensation

`b_L = b + (M_C - M_L) C_old / dt`.

For the reaction-only limit this gives

`M_L C_new = F_post`,

which removes the sign-changing nodal projection that caused the observed negative concentration / NaN behavior while retaining element-integrated mass.

## Scope

This is a targeted experimental correction used for the NUMO validation. It is not presented here as an upstream OGS release. No NUMO chemistry, material parameters, boundary conditions, stabilization settings, meshes or time stepping are modified by this correction.
