function sigma_implied = calcImpliedVolatilityBS(S0, T, K, r, c)

% This function calculates the implied volatility by inserting the option
%value 'c' and all other parameters into the Black-Scholes model. Since it 
%cannot be solved for sigma, it must be determined numerically iteratively. 
%The vpasolve method is used for this.
a = 0.0001;
b = 5;

syms sigmas


d1 = (log(S0/K)+(r+(sigmas^2)/2)*T)/(sigmas*sqrt(T));
d2 = (log(S0/K)+(r-(sigmas^2)/2)*T)/(sigmas*sqrt(T));

eqn = c == S0 * normcdf(d1) - K*exp(-r*T) * normcdf(d2); 

sigma_implied = double(vpasolve(eqn,sigmas, [a b]));
if  isempty(sigma_implied)
    errordlg({'Implied volatility solver does not find a solution. Check search range a and b in function calcImpliedVolatilityBS'});
end
end
