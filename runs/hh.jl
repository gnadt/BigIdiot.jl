## analysis based on The Happiness Hypothesis
cd(@__DIR__)
using Pkg; Pkg.activate("../"); Pkg.instantiate()
using Revise
using BigIdiot
using BenchmarkTools, LinearAlgebra, Plots
using CSV
using DelimitedFiles: readdlm, writedlm
using Plots: plot, plot!
using Random: rand, randn, randperm, seed!, shuffle
using Statistics: cor, cov, mean, median, std, var

## import raw data 
hh1c = readdlm("../data/hh/hh1c.csv",',')
hh1p = readdlm("../data/hh/hh1p.csv",',')
hh2c = readdlm("../data/hh/hh2c.csv",',')
hh2p = readdlm("../data/hh/hh2p.csv",',')

## plot raw data
p1 = plot(xlab="time [months]",ylab="intensity [❤]")
plot!(p1,hh1c[:,1],hh1c[:,2],lab="companionate")
plot!(p1,hh1p[:,1],hh1p[:,2],lab="passionate")

p2 = plot(xlab="time [years]",ylab="intensity [❤]")
plot!(p2,hh2c[:,1],hh2c[:,2],lab="companionate")
plot!(p2,hh2p[:,1],hh2p[:,2],lab="passionate")
