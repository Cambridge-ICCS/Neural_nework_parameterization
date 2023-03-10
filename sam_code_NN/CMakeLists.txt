cmake_minimum_required(VERSION 3.2)
#policy CMP0076 - target_sources source files are relative to file where target_sources is run
cmake_policy (SET CMP0076 NEW)

set ( CMAKE_Fortran_COMPILER "ifort" )
project(SAMNN Fortran C)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "" FORCE)
endif()

# Generate the main executable with dirs, libs, and opts
add_executable ( main )
# No header files
# target_include_directories( main PUBLIC )
# No libraries
add_library( main_c ) # The C parts of MiMA, so we can apply different options for them.
target_compile_definitions( main_c PRIVATE __IFC )
target_compile_definitions( main PRIVATE use_libMPI use_netCDF )

# Set to install in bin directory
# if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
#   set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/bin" CACHE PATH "..." FORCE)
# endif()

#Add cmake directory to the environment module variable
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Find MPIb libraries and link
find_package (MPI REQUIRED)
target_link_libraries( main PRIVATE MPI::MPI_Fortran )

# Find the NetCDF installations and set the relevant variables for compilation
# Then link to executables
# Requires more legwork as NetCDF not provided by default
find_package(PkgConfig)
pkg_search_module(NETCDF_FORTRAN netcdf-fortran)
if (NETCDF_FORTRAN_FOUND)
    set(NETCDF_LIBRARIES "${NETCDF_FORTRAN_LDFLAGS}")
    set(NETCDF_INCLUDES "${NETCDF_FORTRAN_INCLUDE_DIRS}")
else()
    set(NETCDF_F90 "YES")
    find_package(NetCDF REQUIRED)
endif()
pkg_search_module(NETCDF_C netcdf)
if (NETCDF_C_FOUND)
    set(NETCDF_LIBRARIES "${NETCDF_LIBRARIES} ${NETCDF_C_LDFLAGS}")
    set(NETCDF_INCLUDES "${NETCDF_LIBRARIES} ${NETCDF_C_INCLUDE_DIRS}")
endif()

target_link_libraries( main PRIVATE main_c ${NETCDF_LIBRARIES} )
target_include_directories( main PRIVATE ${NETCDF_INCLUDES} )

# Add various subdirectories with long lists of source files
add_subdirectory( RAD_CAM )


# Set ifort compile options for executable
target_compile_options( main PRIVATE
# Preprocess
-fpp
-safe-cray-ptr
# Flush to zero - possibly unneccessary if not using IEEE modules?
-ftz
# -assume byterecl
)

# # Set gfortran compile options for executable
# target_compile_options( main PRIVATE
# # Preprocess
# -cpp
# -fcray-pointer
# # Flush to zero - possibly unneccessary if not using IEEE modules?
# -fno-unsafe-math-optimizations
# -frounding-math
# -fsignaling-nans
# # -assume byterecl
# -ffree-line-length-none
# )

set ( MAIN
abcoefs.f90
adams.f90
advect2_mom_xy.f90
advect2_mom_z.f90
advect_mom.f90
advect_scalar2D.f90
advect_scalar3D.f90
advect_scalar.f90
allocate_uwvars.f90
atmosphere.f90
boundaries.f90
bound_duvdt.f90
bound_exchange.f90
buoyancy.f90
cloud.f90
compress3D.f90
coriolis.f90
damping.f90
diagnose.f90
diffuse_mom2D.f90
diffuse_mom3D.f90
diffuse_mom.f90
diffuse_scalar2D.f90
diffuse_scalar3D.f90
diffuse_scalar3D_vert_flag.f90
diffuse_scalar3D_vert_flag_surf_flag.f90
diffuse_scalar.f90
diffuse_scalar_vert_flag.f90
diffuse_scalar_vert_flag_surf_flag.f90
diffusion_solver.f90
domain.f90
fft.f
forcing.f90
# Don't build here as also in RAD_XXX directory
#gffgch.f90
grid.f90
hbuffer.f90
header.f90
imicro_driver.f
IMICRO_MK.f
init.f90
init_linear_wave.f90
isccpDummy.f9000
isccp.f90
isccpHistograms.f90
isccpSimulator.f90
kurant.f90
landflx.f90
linear_wave.f90
main.f90
microscaling.f90
mse.f90
nn_convection_flux.f90
nn_diffusion.f90
nudging.f90
oceflx.f90
omega.f90
params.f90
params.f90.default
periodic.f90
precip_fall.f90
precip_fall_krueger.f90
precip_init.f90
precip_init_krueger.f90
precip_proc.f90
precip_proc_krueger.f90
precip_util.f90
press_grad.f90
press_rhs.f90
pressure_big.f90
pressure.f90
pressure_orig.f90
pressz.f90
printout.f90
radiation.f90
rad_simple_dycoms.f90
random.f90
random_forest_param_diffusion.f90
random_forest_param.f90
random_forest_param_tkh.f90
renewtracer.f90
restart.f90
sat.f90
secondsf.f90
setdata.f90
setforcing.f90
setgrid.f90
#setgrid.f90.v4
setparm.f90
setperturb.f90
setperturb_realtime.f90
settracer.f90
shear_prod2D.f90
shear_prod3D.f90
shear_prod_xy.f90
simple_land.f90
simple_ocean.f90
statistics.f90
stat_mom.f90
stat_precip.f90
stat_sw1.f90
stat_sw2.f90
stat_tke.f90
stat_varscalar.f90
stepout.f90
subsidence.f90
surface.f90
# surface.f90.old
surface_utils.f90
task_assign_bnd.f90
task_boundaries.f90
task_bound_duvdt.f90
task_dispatch.f90
task_exchange.f90
task_init.f90
task_ranks.f90
task_rank_to_index.f90
task_util_MPI.f90
#task_util_NOMPI.f9000
tke_full.f90
upperbound.f90
utils.f90
uwcu.f90
uwpbl.f90
vars.f90
wavesubsidence.f90
write_fields2D.f90
write_fields3D.f90
wv_saturation.f90
zero.f90
)

# The C parts of the code
target_sources ( main_c PRIVATE
systemf.c
gtodfff.c
gammafff.c
)

target_sources( main PRIVATE ${MAIN} )
