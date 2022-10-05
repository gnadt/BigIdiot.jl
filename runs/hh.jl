## analysis and case study based on The Happiness Hypothesis by Jonathan Haidt
cd(@__DIR__)
using Pkg; Pkg.activate("../"); Pkg.instantiate()
using Revise
using BigIdiot
using BenchmarkTools, LinearAlgebra, Plots
using CSV
using DelimitedFiles: readdlm, writedlm
using LsqFit: coef, curve_fit
using Plots: plot, plot!
using Random: rand, randn, randperm, seed!, shuffle
using Statistics: cor, cov, mean, median, std, var

save_plot = false

## import raw data
hh1p = readdlm("../data/hh/hh1p.csv",',');
hh1c = readdlm("../data/hh/hh1c.csv",',');
hh2p = readdlm("../data/hh/hh2p.csv",',');
hh2c = readdlm("../data/hh/hh2c.csv",',');

## fit exponential coefficients to models
@. model_p(x, p) = p[1]*exp(x*p[2]) + p[3]*exp(-x*p[4])
@. model_c(x, p) = p[1]*exp(x*p[2]) + p[3]*exp(-x*p[4])
p0_p = [100,-0.1,-200,10]
p0_c = [50,0.0,-50,50]
fit_p  = curve_fit(model_p,hh2p[:,1],hh2p[:,2],p0_p)
fit_c  = curve_fit(model_c,hh2c[:,1],hh2c[:,2],p0_c)
coef_p = coef(fit_p)
coef_c = coef(fit_c)

## plot raw data - 6 months
p0 = plot(xlab="time [months]",ylab="intensity [❤]",dpi=300)
plot!(p0,hh1p[:,1],hh1p[:,2],lab="passionate")
plot!(p0,hh1c[:,1],hh1c[:,2],lab="companionate")
save_plot && png(p0,"raw_6_months")

## plot raw data - 6 months scaled to 12 years
p1 = plot(xlab="time [years]",ylab="intensity [❤]",dpi=300)
plot!(p1,hh1p[:,1]*24/12,hh1p[:,2],lab="passionate")
plot!(p1,hh1c[:,1]*24/12,hh1c[:,2],lab="companionate")
save_plot && png(p1,"raw_12_years")

## plot raw data - 6 months scaled to 12 years
p1 = plot(xlab="time [years]",ylab="intensity [❤]",dpi=300)
plot!(p1,hh1p[:,1]*24/12,hh1p[:,2],lab="passionate (Short Run, rescaled)")
plot!(p1,hh1c[:,1]*24/12,hh1c[:,2],lab="companionate (Short Run, rescaled)")
plot!(p1,hh2p[:,1],hh2p[:,2],lab="passionate (Long Run)")
plot!(p1,hh2c[:,1],hh2c[:,2],lab="companionate (Long Run)")
save_plot && png(p1,"raw_12_years_both")

## plot raw data - 60 years
p2 = plot(xlab="time [years]",ylab="intensity [❤]",dpi=300)
plot!(p2,hh2p[:,1],hh2p[:,2],lab="passionate")
plot!(p2,hh2c[:,1],hh2c[:,2],lab="companionate")
save_plot && png(p2,"raw_60_years")

## model with fit
seed!(2)
dt        = 0.1
tt_max    = 60
tt        = 0:dt:tt_max
hh3p      = [tt tt]
hh3c      = [tt tt]
hh3p[:,2] = model_p(hh3p[:,1],coef_p) .+ 10
hh3c[:,2] = model_c(hh3c[:,1],coef_c)

## plot raw data + fit - 60 years
p3 = plot(xlab="time [years]",ylab="intensity [❤]",dpi=300)
plot!(p3,hh2p[:,1],hh2p[:,2],lab="passionate")
plot!(p3,hh2c[:,1],hh2c[:,2],lab="companionate")
plot!(p3,hh3p[:,1],hh3p[:,2],lab="passionate fit")
plot!(p3,hh3c[:,1],hh3c[:,2],lab="companionate fit")
save_plot && png(p3,"fit_60_years_1")

## model with fit + fogm
hh3p[:,2] = hh3p[:,2] .+ fogm(2.5, 2,dt,length(tt))
hh3c[:,2] = hh3c[:,2] .+ fogm(0.5,10,dt,length(tt))

## plot raw data + fit - 60 years
p3 = plot(xlab="time [years]",ylab="intensity [❤]",dpi=300)
plot!(p3,hh2p[:,1],hh2p[:,2],lab="passionate")
plot!(p3,hh2c[:,1],hh2c[:,2],lab="companionate")
plot!(p3,hh3p[:,1],hh3p[:,2],lab="passionate fit")
plot!(p3,hh3c[:,1],hh3c[:,2],lab="companionate fit")
save_plot && png(p3,"fit_60_years_2")

## create case study
seed!(2)
hh4p = [tt tt] / 60 / 3
hh5p = [tt tt] / 60 / 3
hh4p[:,2] = model_p(hh4p[:,1],coef_p) .+ fogm(2.5, 2,dt/60/3,length(tt)) .+ 10
hh5p[:,2] = model_p(hh5p[:,1],coef_p) .+ fogm(125,10,dt/60/3,length(tt)) .+ 10

p4 = plot(xlab="time [months]",ylab="intensity [❤]",dpi=300,legend=:topleft)
plot!(p4,hh4p[:,1]*12,hh4p[:,2],lab="predicted")
plot!(p4,hh5p[:,1]*12,hh5p[:,2],lab="observed")
save_plot && png(p4,"case_study")
