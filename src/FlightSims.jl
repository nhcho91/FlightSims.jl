module FlightSims

# using Debugger  # tmp
using Reexport
using DifferentialEquations
using SimulationLogger
using ComponentArrays, UnPack
using JLD2, FileIO, DataFrames
using NamedTupleTools
using LinearAlgebra, Transducers, Rotations, Random, ForwardDiff
using MatrixEquations
using Combinatorics: multiexponents
using NLopt
using NumericalIntegration: integrate
using DynamicPolynomials: @polyvar, PolyVar, AbstractPolynomialLike
using Flux
using Flux.Data: DataLoader

### APIs
export AbstractEnv, State, Params, Dynamics, Dynamics!, apply_inputs, DatumFormat, save_inputs
export sim, Process, load
@reexport using SimulationLogger
# export @log, @onlylog, @Loggable, @nested_log, __LOG_INDICATOR__
### envs
## basics
export TwoDimensionalNonlinearPolynomialEnv, LinearSystemEnv, ReferenceModelEnv
## controllers
export LQR
# export BacksteppingPositionControllerEnv
## multicopters
export MulticopterEnv
export QuadcopterEnv, IslamQuadcopterEnv, GoodarziQuadcopterEnv
export HexacopterEnv, LeeHexacopterEnv
# # faults
# export FaultSet, LoE
# # control allocator
# export PseudoInverseControlAllocator
### algorithms
# export command
export CTValueIterationADP, BehaviouralCloning, CTLinearIRL
# utils
export AbstractApproximator, LinearApproximator
export PolynomialBasis, euler
export PowerLoop, Command


include("APIs/APIs.jl")
include("utils/utils.jl")
include("environments/environments.jl")
include("algorithms/algorithms.jl")


end
