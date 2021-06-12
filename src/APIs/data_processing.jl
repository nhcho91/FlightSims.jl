"""
Datum format function compatible with `sim` and `SavingCallback` in `DifferetialEquations.jl`.
# Notes
As written in the [description](https://diffeq.sciml.ai/stable/features/callback_library/#saving_callback),
this should allocate the output (not as a view to `x`).
"""
function DatumFormat(env::AbstractEnv)
    return function (x, t, integrator::DiffEqBase.DEIntegrator; kwargs...)
        (; state=copy(x), kwargs...)
    end
end

"""
Post processing function (default).
# Notes
- It would be deprecated.
"""
function Process()
    return function (prob::DiffEqBase.DEProblem, sol::DESolution; Δt=0.01)
        t0, tf = prob.tspan
        ts = t0:Δt:tf
        xs = ts |> Map(t -> sol(t)) |> collect
        DataFrame(time=ts, state=xs)
    end
end

function Process(env::AbstractEnv)
    Process()
end

# save and load
"""
    save(path::String,
    env::AbstractEnv, prob::DiffEqBase.DEProblem, sol::DESolution;
    process=nothing)
"""
function FileIO.save(path::String,
        env::AbstractEnv, prob::DiffEqBase.DEProblem, sol::DESolution;
        process=nothing,)
    will_be_saved = Dict("env" => env, "prob" => prob, "sol" => sol)
    if process != nothing
        will_be_saved["process"] = process
    end
    FileIO.save(path, will_be_saved)
end

"""
    load(path::String; with_process=false)
"""
function JLD2.load(path::String; with_process=false)
    strs = [:env, :prob, :sol]
    if with_process
        push!(strs, :process)
    end
    saved_data = FileIO.load(path, String.(strs)...)
    (; (zip(strs, saved_data) |> Dict)...)  # NamedTuple
end
