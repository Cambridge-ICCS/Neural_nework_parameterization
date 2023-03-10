set ( RAD_CAM_SOURCES
abortutils.f90
aer_optics.f90
albedo.f90
cldefrint.f90
CMakeLists.txt
gffgch.f90
pkg_cldoptics.f90
ppgrid.f90
quicksort.f90
radae.f90
radclwmx.f90
radcswmx.f90
raddedmx.f90
rad.f90
rad_full.f90
radini.f90
radinp.f90
radoz2.f90
rad_restart.f90
shr_kind_mod.f90
shr_orb_mod.f90
traceini.f90
trcab.f90
trcabn.f90
trcems.f90
trcplk.f90
trcpth.f90
volcrad.f90
wrap_nf.f90
zenith.f90
)

target_sources( main PRIVATE ${RAD_CAM_SOURCES} )
