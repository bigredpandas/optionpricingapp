function historicalOptionData = getHistoricalOptionData(symbol)

%This function outputs the historical option data from now until 05.04.2018
%for one option. The data is retrieved from an API from tradier, a US 
%online broker. Tradier fetches the data from several US stock exchanges.
%The API is free but a registration is required to retrieve the API key.

%This libary is necessary for requesting html requests with header content
import matlab.net.*
import matlab.net.http.*
req = RequestMessage;

%Authentication at Tradier API
req = addFields(req, apikey_header);

%The URL is divided into several parts for the sake of clarity
adresse = 'https://sandbox.tradier.com/v1/markets/history?interval=daily&start=';
datestartAPI = '2018-05-04';
dateLink = '&end=';
dateendAPI = datestr(date, 29);
SymbolLink = '&symbol=';
link = [adresse datestartAPI dateLink dateendAPI SymbolLink symbol];

%This sends the html request and packs the answer in resp
uri = URI(link);
[resp,~] = send(req,uri);

S = struct2table(resp.Body.Data.history.day);
historicalOptionData.data = flipud(S);
end