"""
    BigIdiot: I am a big idiot.
"""
module BigIdiot
    using LinearAlgebra, Plots
    using DelimitedFiles: readdlm, writedlm
    using Plots: plot, plot!
    using Random: rand, randn, randperm, seed!, shuffle
    using Statistics: cor, cov, mean, median, std, var

    include("hair.jl")
    include("suitor_check.jl")

    export
    set_hair,set_cuts,suitor_check

end # module BigIdiot
