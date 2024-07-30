function Type_Meas_Probe = SearchTypeProbe(app, File_Sondas)

            % Nome do arquivo
            % Caminho do diretório
            % directoryPath = 'C:\P&D\AppRNI\DataBase\Meas_Sondas';
            
            % Nome do arquivo
            % fileName = File_Sondas;  % Substitua pelo nome do arquivo real
            
            % Construir o caminho completo para o arquivo usando sprintf
            % fullFilePath = sprintf('%s\\%s', directoryPath, fileName);

            % Abrir o arquivo para leitura
            fileID = fopen(File_Sondas, 'r');
            
            % Verificar se o arquivo foi aberto com sucesso
            if fileID == -1
                error('Erro ao abrir o arquivo.');
            end
            
            % Ler o conteúdo do arquivo como uma string
            fileContent = fscanf(fileID, '%c');
            
            % Fechar o arquivo
            fclose(fileID);
            
            % Palavra a ser procurada
            searchWord = 'AMB-8059-00';
            
            % Verificar se a palavra existe no conteúdo do arquivo
            if contains(fileContent, searchWord)
                Type_Meas_Probe = 'Narda';
            else
                Type_Meas_Probe = 'Monitem';
            end