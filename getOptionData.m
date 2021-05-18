function OptionData = getOptionData(symbol)

%This function outputs the option data for one option. It gives information
%about the last price, bid, ask, option type and maturity. It does not give
%information for historical prices (see 'getHistoricalOptionData').
%The data is retrieved from an API from tradier, a US online broker. Tradier
%fetches the data from several US stock exchanges.
%The API is free but a registration is required to retrieve the API key.

%This libary is necessary for requesting html request with header content
import matlab.net.*
import matlab.net.http.*
req = RequestMessage;

%Authentication at tradier API
req = addFields(req, apikey_header);
adresse = 'https://sandbox.tradier.com/v1/markets/quotes?';
SymbolLink = 'symbols=';

link = [adresse SymbolLink symbol];

uri = URI(link);
[resp,~,~] = send(req,uri);

S_meta = resp.Body.Data.quotes.quote; 

OptionData.K = S_meta.strike;
OptionData.description = S_meta.description;
OptionData.underlyingStock = S_meta.root_symbol;
OptionData.maturity = S_meta.expiration_date;
OptionData.option_type = S_meta.option_type;
OptionData.c_last_price = S_meta.last;
OptionData.c_last_bid = S_meta.bid;
OptionData.c_last_ask = S_meta.ask;

end