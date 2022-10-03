## analysis based on The Happiness Hypothesis
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

## import raw data 
hh1c = readdlm("../data/hh/hh1c.csv",',');
hh1p = readdlm("../data/hh/hh1p.csv",',');
hh2c = readdlm("../data/hh/hh2c.csv",',');
hh2p = readdlm("../data/hh/hh2p.csv",',');

## plot raw data
# p1 = plot(xlab="time [months]",ylab="intensity [❤]")
# plot!(p1,hh1c[:,1],hh1c[:,2],lab="companionate")
# plot!(p1,hh1p[:,1],hh1p[:,2],lab="passionate")

p1 = plot(xlab="time [years]",ylab="intensity [❤]")
plot!(p1,hh1c[:,1]*24/12,hh1c[:,2],lab="companionate")
plot!(p1,hh1p[:,1]*24/12,hh1p[:,2],lab="passionate")

p2 = plot(xlab="time [years]",ylab="intensity [❤]")
plot!(p2,hh2c[:,1],hh2c[:,2],lab="companionate")
plot!(p2,hh2p[:,1],hh2p[:,2],lab="passionate")
plot!(p2,hh2c[:,1],model(hh2c[:,1],coef_c))
plot!(p2,hh2p[:,1],model(hh2p[:,1],coef_p).+10)

display(p1)
display(p2)

## create 
hh3 = []

p3 = plot(xlab="time [months]",ylab="intensity [❤]")
plot!(p3,hh3[:,1],hh3[:,2],lab="")

# ## 
# pc = plot(xlab="time [months]",ylab="intensity [❤]")
# plot!(pc,hh1c[:,1],hh1c[:,2],lab="companionate")
# plot!(pc,hh2c[1:3,1]*12,hh2c[1:3,2],lab="companionate")

# scale = linreg(hh1c[:,2],hh1c[:,1]) / linreg(hh2c[1:3,2],hh2c[1:3,1]*12)

# ## 
# pp = plot(xlab="time [months]",ylab="intensity [❤]")
# plot!(pp,hh1p[:,1],hh1p[:,2],lab="passionate")
# plot!(pp,hh2p[1:3,1]*12,hh2p[1:3,2],lab="passionate")

# scale = linreg(hh1p[:,2],hh1p[:,1]) / linreg(hh2p[1:3,2],hh2p[1:3,1]*12)

## 
@. model_c(x, p) = p[1]*exp(x*p[2]) + p[3]*exp(-x*p[4])
@. model_p(x, p) = p[1]*exp(x*p[2]) + p[3]*exp(-x*p[4])
p0_c = [50,0.0,-50,50]
p0_p = [100,-0.5,-50,10]
fit_c  = curve_fit(model_c,hh2c[:,1],hh2c[:,2],p0_c)
fit_p  = curve_fit(model_p,hh2p[:,1],hh2p[:,2].-10,p0_p)
coef_c = coef(fit_c)
coef_p = coef(fit_p)
