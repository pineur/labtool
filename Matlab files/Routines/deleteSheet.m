function deleteSheet(excelFilePath, sheetName )
if nargin<2
    error('must have at least 2 arguments\n');
end


% Open Excel file.
objExcel = actxserver('Excel.Application');
objExcel.Workbooks.Open(excelFilePath); % Full path is necessary!

% Delete sheets.
try
% Throws an error if the sheets do not exist.
objExcel.ActiveWorkbook.Worksheets.Item(sheetName).Delete;

catch
; % Do nothing.
end

% Save, close and clean up.
objExcel.ActiveWorkbook.Save;
objExcel.ActiveWorkbook.Close;
objExcel.Quit;
end

