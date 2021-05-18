function stockData = getStockData(symbol)

%This function outputs the historical stockdata from now until 05.04.2018
%for one stock. The data is retrieved from an API from tradier, a US 
%online broker. Trader fetches the data from several US stock exchanges.
%The API is free but a registration is required to retrieve the API key.

%This libary is necessary for requesting html request with header content
%import matlab.net.*
%import matlab.net.http.*
%req = RequestMessage;

%Authentication at tradier API
req = addFields(req, apikey_header);

%The URL is divided into several parts for the sake of clarity
adresse = 'https://sandbox.tradier.com/v1/markets/history?interval=daily&start=';
datestartAPI = '2018-05-04';
dateLink = '&end=';
dateendAPI = datestr(date, 29);%outputs the current date in yyyy-mm-dd format
SymbolLink = '&symbol=';
link = [adresse datestartAPI dateLink dateendAPI SymbolLink symbol];

%This sends the html request and packs the answer in resp
uri = URI(link);
[resp,~] = send(req,uri); 

S = struct2table(resp.Body.Data.history.day);
S = flipud(S); % Flips the rows up-down direction (because in all other calculations
%the first entry is the latest date

%This is used to calculate the volatility later
S.shiftedclose = [S.close(2:end);0]; 
S.rollingdelta = log(S.close./S.shiftedclose);

stockData = S;
end