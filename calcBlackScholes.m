function bsData = calcBlackScholes(S0, T, K, r, sigma)

% S0 - Current stock price
% T - annualized Time to maturity 
% K - Strike Price
% r - risk free anualized interest rate
% sigma - anualized volatility

cumDistrNorm = @(x) 0.5*(1-erf(-x/sqrt(2)));

d1 = (log(S0./K)+(r+(sigma.^2)/2).*T)./(sigma.*sqrt(T));
d2 = (log(S0./K)+(r-(sigma.^2)/2).*T)./(sigma.*sqrt(T));

c1 = S0 .* cumDistrNorm(d1) - K*exp(-r.*T) .* cumDistrNorm(d2);
%c2 = S0 .* normcdf(d1) - K*exp(-r.*T) .* normcdf(d2);

bsData = c1;

end
