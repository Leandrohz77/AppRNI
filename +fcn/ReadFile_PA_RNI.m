function Data_PA_RNI = ReadFile_PA_RNI(app)

            % Caminho relativo do arquivo do PA_RNI
            relativePath_Data_PA_RNI = '\DataBase\PA_RNI\Dados_PA_RNI_ok.csv';
            DirApp = 'C:\P&D\AppRNI';
            
            % Obter o caminho absoluto
            Path_Data_PA_RNI = fullfile(DirApp, relativePath_Data_PA_RNI);

            opts = detectImportOptions(Path_Data_PA_RNI);
            
            % Defini os tipos de variáveis de cada coluna do arquivo do PA_RNI
            opts.VariableTypes = {'string', 'string', 'string', 'string', 'string', 'string', 'string', 'string'};
            
            %Preserva os nomes da colunas da tabela do PA_RNI
            opts.PreserveVariableNames = true;

            %Lê para Data_PA_RNI os dados da tabela do PA_RNI
            Data_PA_RNI = readtable(Path_Data_PA_RNI, opts);

            % Subtui as virgulas das coordendas por pontos 
            Data_PA_RNI.('Latitude da Estação')  = replace(Data_PA_RNI.('Latitude da Estação'),",",".");
            Data_PA_RNI.('Longitude da Estação') = replace(Data_PA_RNI.('Longitude da Estação'),",",".");

            % Identificar os valor Data_PA_RNI ausentes (NaN ou vazio)
            missingIdx = cellfun(@(x) isempty(x) || (ischar(x) && strcmpi(x, 'NaN')), Data_PA_RNI {:,1:8});

            % Substituir valores ausentes do arquivo do PA_RNI por ''
            Data_PA_RNI {:,1:8}(missingIdx) = {''};

            % Criar uma matriz de strings (ou NaNs)
            matrix_nan = strings(height(Data_PA_RNI), numel(class.Constants.GUINewColumns));
            
            % Converter a matriz em uma tabela
            matrix_nan_table = array2table(matrix_nan);

            % Definir novos nomes de colunas
            NewNames = {'Data da Medição', 'Emáx (V/m)', 'Latitude Emáx', 'Longitude Emáx', '> 14 V/M', 'Justificativa (apenas NV)', 'Observações importantes'};
            
            % Definir os nomes das novas colunas
            matrix_nan_table.Properties.VariableNames = NewNames;
            
            % Concatenar a nova tabela com a tabela existente do PA_RNI
            Data_PA_RNI = [Data_PA_RNI matrix_nan_table];
end