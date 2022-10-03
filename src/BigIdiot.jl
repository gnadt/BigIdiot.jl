"""
    BigIdiot: I am a big idiot.
"""
module BigIdiot
    using LinearAlgebra, Plots, ZipFile
    using DelimitedFiles: readdlm, writedlm
    using Images: load
    using Plots: plot, plot!
    using Random: rand, randn, randperm, seed!, shuffle
    using Statistics: cor, cov, mean, median, std, var

    include("hair.jl")
    include("image2kmz.jl")
    include("suitor_check.jl")
    include("util.jl")

    export
    set_hair,set_cuts,
    image2kmz,
    suitor_check,
    linreg,fogm

end # module BigIdiot
