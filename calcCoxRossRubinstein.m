function [optionPriceCRR_EU,optionPriceCRR_AM] = calcCoxRossRubinstein(S0, T, K, r, sigma,n, putOrCall)

% S0 - Current stock price
% T - annualized Time to maturity 
% K - Strike Price
% r - risk free anualized interest rate
% sigma - anualized volatility
% n - number of timesteps till the expiration date
% putOrCall - boolean variable Put(0)/Call(1);

delta_t = T/n;
beta = exp(-r*delta_t);
u = exp(sigma*sqrt(delta_t));
q = 0.5 + sqrt(delta_t)*(r-(sigma^2)/2)/(2*sigma);

price = S0*(u.^(-n:n));
price = fliplr(price);%fliplr returns the same row vector with columns flipped in the left-right direction.
dimPrice = length(price);

% E is the array for the European option. It will store the value 
%of the stock option for different prices at different points in time.

E = zeros(dimPrice, n+1);

%for i = 1:dimPrice % It is sufficient to calculate a tree structure, see solution below, faster
for i = 1:2:dimPrice
    if putOrCall
    E(i, n+1) = max(price(i)-K, 0); %if call option
    else
    E(i, n+1) = max(K-price(i), 0); %if put option
    end
end
A = E; %Initialization for American and European options is the same

%For the American option, a comparison is made as to whether it is more
%worth triggering the option now or whether the forecasted value is higher.

for j = n:-1:1
    %for i = 1:dimPrice % It is sufficient to calculate a tree structure, see solution below, faster
    for i = (n+2-j):2:(n+j)
        
        E(i, j) = beta*(q*E(max(i-1, 1), j+1) + (1-q)*E(min(i+1,dimPrice), j+1));   
        
        if putOrCall
        A(i, j) = max([price(i)-K, q*beta*A(max(i-1, 1), j+1) + (1-q)*beta*A(min(i+1,dimPrice), j+1)]);%if call option
        else 
        A(i, j) = max([K-price(i), q*beta*A(max(i-1, 1), j+1) + (1-q)*beta*A(min(i+1,dimPrice), j+1)]);%if put option
        end
        
    end
end

optionPriceCRR_EU = E(n+1,1); %middle entry of first column, European option
optionPriceCRR_AM = A(n+1,1); %middle entry of first column, American option

end