function mcData = calcMonteCarlo(S0, T, K, r, sigma,n)

% S0 - Current stock price
% T - annualized Time to maturity 
% K - Strike Price
% r - risk free anualized interest rate
% sigma - anualized volatility
% n - number of random variable generation

W_T = sqrt(T)*randn(n, 1);

S = S0*exp((r-sigma^2/2)*T + sigma*W_T);

p = max(S - K, 0);

c = exp(-r*T)*mean(p);

mcData = c;

end
