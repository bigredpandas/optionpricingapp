# optionpricingapp
A tool in Matlab for calculating the "fair" price of a put or call option using the Black-Scholes-Equation, Monte-Carlo-Simulation and the Cox-Ross-Rubinstein-Model.

The app uses the [tradier API](https://documentation.tradier.com) for real-time US stock information and the [xml-endpoint from the U.S. Department of Treasury](https://www.treasury.gov/resource-center/data-chart-center/interest-rates/pages/textview.aspx?data=yield).

Getting started:
1. Make sure you use a recent Matlab version. The app was developed in matlab R2019b 9.7.0, newer version could work.
2. Add your tradier API-key to the file [defAPIKeys.m](defAPIKeys.m). 
3. Start the matlab app [OptionPricingApp.mlapp](OptionPricingApp.mlapp) and paste in the Option Data Symbol the name of a current option. The notation has to be the one from Yahoo finance ([here an example for Tesla options](https://finance.yahoo.com/quote/TSLA/options/)).
4. Have fun!

![image2](https://user-images.githubusercontent.com/40469812/118652559-04c0ba80-b7e7-11eb-9142-e75ba2574b71.png)

![image](https://user-images.githubusercontent.com/40469812/118652568-07bbab00-b7e7-11eb-95fc-178f24497dc8.png)

