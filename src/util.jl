"""
    linreg(y, x; λ=0)

Linear regression with input data matrix.

**Arguments:**
- `y`: observed data
- `x`: input data
- `λ`: (optional) ridge parameter

**Returns:**
- `coef`: linear regression coefficients
"""
function linreg(y, x; λ=0)
    coef = (x'*x + λ*I) \ (x'*y)
    length(coef) > 1 && (coef = vec(coef))
    return (coef)
end # function linreg
