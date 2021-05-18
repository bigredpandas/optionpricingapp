%This function is for setting the API Key

%This libary is necessary for requesting html request with header content
import matlab.net.*
import matlab.net.http.*

%Authentication at tradier API
global apikey_header
apikey = 'Bearer PASTEYOURKEYHERE';
apikey_header = matlab.net.http.HeaderField('Authorization', apikey, 'Accept', 'application/json');

