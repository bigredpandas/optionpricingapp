function correctSymbol = getCorrectSymbol(symbol)

%This function formats the old stock option notation into the new one. For
%more on this please read: https://www.investopedia.com/articles/optioninvestor/10/options-symbol-rules.asp 

if length(symbol) == 19 || length(symbol) == 18 || length(symbol) == 17 || length(symbol) == 16
    correctSymbol = symbol; %If the new notation is used, then it should be
    %passed on directly
else
    symbolBuffer = extractAfter(symbol, '|');
    l = length(symbolBuffer);
    if l == 18
        correctSymbol = [extractBefore(symbol, '|') symbolBuffer(3:8) symbolBuffer(end) symbolBuffer(10:l-13) symbolBuffer(15:16) '0'];
    elseif l < 18
        zer = '00000';
        correctSymbol = [extractBefore(symbol, '|') symbolBuffer(3:8) symbolBuffer(end) zer(1:18-l) symbolBuffer(10:l-4) symbolBuffer(end-2:end-1) '0'];
    else
        correctSymbol = 'Wrong symbol format';
    end
end