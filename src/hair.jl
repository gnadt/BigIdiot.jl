# function to set hair length vector (0 to 1)
function set_hair(cuts = [1,183]; year = 365)

	hair = zeros(year)

	if length(cuts) > 1
		year_end = year-(cuts[end]-cuts[1])
		cuts_max = maximum([[cuts[i+1]-cuts[i] for i=1:(length(cuts)-1)];year_end])
		lim_end  = year_end/cuts_max
		for i = 1:(length(cuts)-1)
			lim = (cuts[i+1]-cuts[i])/cuts_max
			hair[cuts[i]:(cuts[i+1]-1)] = LinRange(0,lim,cuts[i+1]-cuts[i])
		end
	else
		year_end = year
		lim_end  = 1.0
	end

	hair[cuts[end]:end] = LinRange(0,lim_end,year_end)[1:(year-cuts[end]+1)]
	hair[1:(cuts[1]-1)] = LinRange(0,lim_end,year_end)[(year-cuts[end]+2):end]

	return(hair)
end # function set_hair

# function to set haircut date vector
function set_cuts(date1     = 1,
	              cut_dist  = :constant,
				  min_cuts  = 6,
				  min_weeks = 6,
				  max_weeks = 12;
				  year      = 365)

	num_cuts = max(min_cuts,ceil(Int64,year/(7*(min_weeks+max_weeks)/2)))

	if (cut_dist == :constant) || (num_cuts <= 1)
		vals = ones(num_cuts)
	elseif cut_dist == :triangle
		mid_cuts = floor(Int64,num_cuts/2+1)
		vals = vcat(LinRange(min_weeks,max_weeks,mid_cuts),
				    LinRange(max_weeks,min_weeks,mid_cuts)[2:(end-1+mod(num_cuts,2))])
	elseif cut_dist == :wave
		vals = cos.(LinRange(0,2*pi,num_cuts+1))[1:(end-1)] .* 
		       (max_weeks-min_weeks)/2 .+ (max_weeks+min_weeks)/2
	end

	year_part = year/sum(vals).*(vcat(0,vals[1:end-1]))
	cuts = mod.(date1.+cumsum(round.(Int64,year_part)),year)
	cuts[cuts.==0] .= year
	cuts = sort(cuts)

	return (cuts)
end # function set_cuts
