function risklessYieldData = getRisklessYieldData(actDate, maturity)

% This function outputs the interest on US Treasury Bills from
%day actDate. The type of US Treasury Bill, whether with 1, 2 or 6 months 
%maturity, is determined by the days between the date actDate and the 
%expiration date 'maturity'. The function can give interest for only one 
%'actDate' date and one 'maturity' date, as well as for n 'actDate' dates
%and one 'maturity' date.
%Then the output will be given as a vector with n entries.
%The data is fetched from the website of the US Treasury Department.

%The input actDate is to be given as a vector with x >= 1 data.
%The input maturity is to be passed as a single date
%The output is given as a timetable.


%2 API calls are needed to fetch data for 2021 and 2020 from the US
%Treasury Department website. Needs to be updated each year
%  2019 call
%url = 'https://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData?$filter=year(NEW_DATE)%20eq%202019';
%r_data2019 = webread(url);
%r_curve2019= struct2table(r_data2019.d);
% 2020 call
url = 'https://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData?$filter=year(NEW_DATE)%20eq%202020';
r_data2020 = webread(url);
% 2021 call
url = 'https://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData?$filter=year(NEW_DATE)%20eq%202021';
r_data2021 = webread(url);

%The 2020 and 2021 data is combined in one table.
r_curve = [struct2table(r_data2020.d);struct2table(r_data2021.d)];

%The dates in the NEW_DATE column need to be formatted into the standard
%Matlab date format
r_curve.NEW_DATE = extractBetween(r_curve.NEW_DATE ,'(',')');
T = datetime(1970,1,1,0,0,0,0,'TimeZone','UTC','F','uuuu-MM-dd');
addMS = milliseconds(str2double(r_curve.NEW_DATE));
r_curve.NEW_DATE = T + addMS;

%Here only entries on the actual dates are extracted from the whole dataset
%of the yield curve data (whole data includes all of 2019 and days up to now in 2020)
%Missing dates, due to different holidays of the US Treasury Department and 
%stock exchanges (US Treasury Department has more)
r_curve = table2timetable(r_curve);
r_curve_selection = r_curve(actDate, :);
missingDates = find(~ismember(actDate, r_curve_selection.NEW_DATE)).';


%% Calculate correct maturity of US Treasury bonds
%The appropriate US treasury bond must be selected. As the basis for
%calculating the price of an option with an expiration date in 1 year, you
%must choose a US Treasury bond with a term of one year. For an option 
%with an expiration date in 1 month, choose a US Treasury bond with a term 
%of one month.


NumDays = days(datetime(maturity)-datetime(actDate));
Matrix = NumDays*0;
dYear = 365;
MatrixDimen = length(NumDays);

for i = 1:MatrixDimen
if NumDays(i) < 1.5/12*dYear
        Matrix(i) = 3;
elseif NumDays(i) < 2.5/12*dYear
        Matrix(i) = 4;           
elseif NumDays(i) < 4.5/12*dYear
        Matrix(i) = 5;           
elseif NumDays(i) < 9/12*dYear
        Matrix(i) = 6;
elseif NumDays(i) < 1.5*dYear
        Matrix(i) = 7;
elseif NumDays(i) < 2.5*dYear
        Matrix(i) = 8;
elseif NumDays(i) < 4*dYear
        Matrix(i) = 9;
else
    Matrix(i) = 10;
end
end

%This generates a timetable with the actDates which is then filled with 
%the corresponding return rates in the next step
r =zeros(MatrixDimen, 1);
risklessYieldPre = timetable(datetime(actDate),r);


if isempty(r_curve_selection) %If a single query takes place on a public holiday
    risklessYieldPre.r = cell2mat(table2cell(r_curve(end,Matrix)))./100;
    risklessYieldData = risklessYieldPre;
else
counter = 0; %This counter is necessary so that the missing entries, due to
%the above mentioned differences in holidays between stock exchanges and US
%Treasury Department, are filled up
for i = 1:MatrixDimen
    if ismember(i, missingDates)==1
        counter = counter+1;
        risklessYieldPre(i, 1)= r_curve_selection(i, Matrix(i));
    else
        risklessYieldPre(i, 1)= r_curve_selection(i-counter, Matrix(i));
    end
end
risklessYieldPre.r =risklessYieldPre.r ./100;
risklessYieldData = risklessYieldPre;
end
end