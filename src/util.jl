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

"""
    fogm(sigma, tau, dt, N)

First-order Gauss-Markov stochastic process. 
Represents unmeasureable time-correlated errors.

**Arguments:**
- `sigma`: FOGM catch-all bias
- `tau`:   FOGM catch-all time constant [s]
- `dt`:    measurement time step [s]
- `N`:     number of samples (instances)

**Returns:**
- `x`: FOGM data
"""
function fogm(sigma, tau, dt, N)

    x    = zeros(N)
    x[1] = sigma*randn()
    Phi  = exp(-dt/tau)
    Q    = 2*sigma^2/tau
    Qd   = Q*dt

    for i = 2:N
        x[i] = Phi*x[i-1] + sqrt(Qd)*randn()
    end

    return (x)
end # function fogm
