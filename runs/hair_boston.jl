### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 24705100-0f32-11eb-180c-174a6e99ffbe
# setup
begin
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
	city  = "boston"
	year  = 365
	dates = vec(readdlm("../data/dates.csv", ',', String))
	temps = readdlm("../data/temperatures/$(lowercase(city)).csv", ',', Float64)
	low   = temps[:,1]
	high  = temps[:,2]
	temp  = (high+low.-minimum(high+low))./(maximum(high+low)-minimum(high+low))
end;

# ╔═╡ 06732818-0f36-11eb-23b2-ffd5b7131faa
# month lengths
begin
	jan = sum(occursin.("Jan",dates))
	feb = sum(occursin.("Feb",dates))
	mar = sum(occursin.("Mar",dates))
	apr = sum(occursin.("Apr",dates))
	may = sum(occursin.("May",dates))
	jun = sum(occursin.("Jun",dates))
	jul = sum(occursin.("Jul",dates))
	aug = sum(occursin.("Aug",dates))
	sep = sum(occursin.("Sep",dates))
	oct = sum(occursin.("Oct",dates))
	nov = sum(occursin.("Nov",dates))
	dec = sum(occursin.("Dec",dates))
	months = [jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec]
end

# ╔═╡ b6f7fd6c-0f36-11eb-27d0-5b543445c97b
# days into year for start of each month (for plotting)
begin
	starts = one.(months)
	for i in eachindex(starts)[2:end]
		starts[i] = starts[i-1] + months[i-1]
	end
end;

# ╔═╡ 828fcae8-0f34-11eb-28a2-7598658b14ac
# plot average high and low temperatures
begin
	plot(xlabel="date",ylabel="temp [F]",xticks=(starts,dates[starts]))
	plot!(dates,high,label="high",color=:red)
	plot!(dates,low,label="low",color=:blue)
end

# ╔═╡ b3619122-929e-11eb-296c-2504cff62391
# INPUTS: minimum number of haircuts, min/max weeks between haircuts
begin
	cut_dist  = :wave
	min_cuts  = 6
	min_weeks = 6
	max_weeks = 12
end;

# ╔═╡ b3bdd14c-0f51-11eb-1593-ef604020c84b
# find optimal haircut date
begin
	hair_temp = zeros(year)
	for i = 1:year
		cuts = set_cuts(i,cut_dist,min_cuts,min_weeks,max_weeks)
		hair = set_hair(cuts)
		hair_temp[i] = sum((hair-temp).^2)
	end
	date1 = findmax(hair_temp)[2]
	cuts = set_cuts(date1,cut_dist,min_cuts,min_weeks,max_weeks)
	hair = set_hair(cuts)
	dates[cuts]
end

# ╔═╡ 1b0c71a8-0f51-11eb-3cac-7fdb1ced8150
# plot optimal haircut dates against average temperatures
begin
	plot(xlabel="date",xticks=(starts,dates[starts]),ylim=[0,1.125])
	plot!(dates,temp,label="temp",color=:green)
	plot!(dates,hair,label="hair",color=:brown)
end

# ╔═╡ Cell order:
# ╟─24705100-0f32-11eb-180c-174a6e99ffbe
# ╟─06732818-0f36-11eb-23b2-ffd5b7131faa
# ╟─b6f7fd6c-0f36-11eb-27d0-5b543445c97b
# ╟─828fcae8-0f34-11eb-28a2-7598658b14ac
# ╠═b3619122-929e-11eb-296c-2504cff62391
# ╟─b3bdd14c-0f51-11eb-1593-ef604020c84b
# ╟─1b0c71a8-0f51-11eb-3cac-7fdb1ced8150
