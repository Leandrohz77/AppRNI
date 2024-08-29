function Data_PA_RNI = ReadFile_PA_RNI(app)

            % Caminho relativo do arquivo do PA_RNI
            relativePath_Data_PA_RNI = '\DataBase\PA_RNI\Dados_PA_RNI_ok.csv';
            DirApp = 'C:\P&D\AppRNI';
            
            % Obter o caminho absoluto
            Path_Data_PA_RNI = fullfile(DirApp, relativePath_Data_PA_RNI);

            opts = detectImportOptions(Path_Data_PA_RNI);
            
            % Defini os tipos de variáveis de cada coluna do arquivo do PA_RNI
            opts.VariableTypes = {'double', 'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string'};

            Data_PA_RNI = readtable(Path_Data_PA_RNI, opts);

            Data_PA_RNI{:,8} = replace(string(table2array(Data_PA_RNI(:,8))),",",".");
            Data_PA_RNI{:,9} = replace(string(table2array(Data_PA_RNI(:,9))),",",".");

            % Identificar os valor app.Data_PA_RNIs ausentes (NaN ou vazio)
            missingIdx = cellfun(@(x) isempty(x) || (ischar(x) && strcmpi(x, 'NaN')), Data_PA_RNI {:,1:9});

            % Substituir valores ausentes do arquivo do PA_RNI por ''
            Data_PA_RNI {:,1:9}(missingIdx) = {''};
end