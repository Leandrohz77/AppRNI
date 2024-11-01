function Data_Probe  = ReadFile_Meas_Probes(app, TypeFileMeas, fileFullName, Arq_Num, Total_Files)

            %Inicia as vairáveis da barra de progresso
            contsteps = 0;
            count_ocorrencia = {};
            count_ocorrencia{1} = 0;
            corrent_Step = 0;

            %Cria a barra de progresso e calcula os Steps
            numOccurrences = Progressbar(app, fileFullName);
     
            numOccurrences{2}.Message = sprintf('Lendo %dº de %d Arquivo(s)...', Arq_Num, Total_Files);

            % Abrir o arquivo para leitura
            fileID = fopen(fileFullName, 'r');
            
            % Verificar se o arquivo foi aberto com sucesso
            if fileID == -1
                error('Erro ao abrir o arquivo.');
            end

            % Inicializar matriz de dados
            dataTable = [];
            Data_Probe = [];

            % Inicializar variáveis
            lineNumber = 0;

            % Ler e processar o conteúdo a partir da linha desejada
            % switch TypeFileMeas
            %     case 'Narda'
            %         Resposta = fileReader.NardaCSV(fileID);
            %     case 'Monitem'
            %         Resposta = fileReader.MonitemCSV(fileID);
            %     otherwise
            %         error('UnexpectedFileFormat')
            % end


            if TypeFileMeas == "Narda"

                % Procura pelas linhas onde há o padrão '^.................
                % .........................................S............W'
                pattern    = '^..........................................................S............W';
                pattern_SW = '^..........................................................S............W';
                pattern_NE = '^..........................................................N............E';
                
                
                % Ler o arquivo linha por linha
                while ~feof(fileID)
                    
                    % Ler a linha atual
                    currentLine = fgetl(fileID);

                    if ~isempty(currentLine)
                        % Incrementar o contador de linhas
                        lineNumber = lineNumber + 1;
                    end
                   
                    % Ler o conteúdo do arquivo como uma string
                    files = fileread(fileFullName);
                    
                    % Dividir o conteúdo em linhas
                    fileContentall = string(splitlines(files));

                    % Excluir linhas vazias
                    filenonEmptyLines = fileContentall(~cellfun('isempty', fileContentall));

                    % Encontrar todas as linhas que correspondem ao padrão
                    validLines = ~cellfun(@isempty, regexp(filenonEmptyLines, pattern, 'once'));

                    fileContentall  = filenonEmptyLines(validLines);
                    
                    % Verificar se a linha corresponde ao padrão
                    if ~isempty(regexp(fileContentall, pattern_SW, 'once'))
                        % Ler o conteúdo do arquivo como uma string
                        fileContentstring = fscanf(fileID, '%c');

                        % % Ler o conteúdo do arquivo como uma string
                        % files = fileread(File_Sondas);
                        % 
                        % % Dividir o conteúdo em linhas
                        % fileContentall = string(splitlines(files));

                        % % Excluir linhas vazias
                        % filenonEmptyLines = fileContentall(~cellfun('isempty', fileContentall));

                        % Palavra a ser procurada
                        searchWord = 'PAUSED';
                        
                        % Verificar se a palavra existe no conteúdo do arquivo
                        if contains(fileContentstring, searchWord)

                            % Encontrar as linhas que contêm 'PAUSED'
                            contains_PAUSED = contains(fileContentall, 'PAUSED');
                            
                            % Filtrar as linhas que não contêm 'PAUSED'
                            fileContent =  fileContentall(~contains_PAUSED);
                        else
                            fileContent =  fileContentall;
                        end

                        format long;

                        % Filtrar linhas que contêm 'MES=' e ';'
                        validLines = contains(fileContent, 'MES=') & contains(fileContent, ';');
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        FieldValue = extractBetween(fileContent(validLines), 'MES=', ';');

                        % % Extract all data between 'MES=' and ';'
                        % FieldValue = extractBetween(fileContentstring, 'MES=', ';');
                        
                        % Filter the results to keep only those with exactly 4 characters
                        filteredData = FieldValue(strlength(FieldValue) == 4);
                        
                        % Convert filteredData to a cell array if needed
                        extractedVector = cellstr(filteredData);

                        FieldValue = str2double(extractedVector);


                        % Filtrar linhas que contêm 'MES=' e ';'
                        validLines = contains(fileContent, ',A,') & contains(fileContent, ',S,');
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        Latitude_Narda_int = extractBetween(fileContent(validLines), ',A,', ',S,');

                        % % Extract all data between ',A,' and ',S,'
                        % Latitude_Narda_int = extractBetween(fileContentstring, ',A,', ',S,');
                        
                        % Filter the results to keep only those with exactly 9 characters
                        filteredData = Latitude_Narda_int(strlength(Latitude_Narda_int) == 9);
                        
                        % Convert filteredData to a cell array if needed
                        extractedVector = cellstr(filteredData);

                        Latitude = floor(str2double(extractedVector)/100) + (((str2double(extractedVector)/100) - floor(str2double(extractedVector)/100))/0.6);
             

                        % Filtrar linhas que contêm 'MES=' e ';'
                        validLines = contains(fileContent, ',S,') & contains(fileContent, ',W,');
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        Longitude_Narda_int = extractBetween(fileContent(validLines), ',S,', ',W,');

                        % % Extract all data between ',S,' and ',W,'
                        % Longitude_Narda_int = extractBetween(fileContentstring, ',S,', ',W,');
                        
                        % Filter the results to keep only those with exactly 10 characters
                        filteredData = Longitude_Narda_int(strlength(Longitude_Narda_int) == 10);
                        
                        % Convert filteredData to a cell array if needed
                        extractedVector = cellstr(filteredData);

                        Longitude = floor(str2double(extractedVector)/100) + (((str2double(extractedVector)/100) - floor(str2double(extractedVector)/100))/0.6);
                      

                        % Filtrar linhas que contêm 'MES=' e ';'
                        validLines = contains(fileContent, '-->') & contains(fileContent, '*;');
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        Timestamp = extractBetween(fileContent(validLines), '-->', '*;');

                        % % Extract all data between '-->' and '*;'
                        % Timestamp = scrmp(fileContent, extractBetween(fileContent, '-->', '*;'));
                         
                        % Filter the results to keep only those with exactly 17 characters
                        filteredData = Timestamp(strlength(Timestamp) == 17);
                        
                        % Convert filteredData to a cell array if needed
                        extractedVector = cellstr(filteredData);

                        Timestamp = datetime(extractedVector, "InputFormat", "yy/MM/dd HH:mm:ss", "Format", "dd/MM/yy HH:mm:ss");


                        dataRow = timetable(Timestamp, Latitude, Longitude, FieldValue);

                        dataTable = dataRow;

                       break;

                        % 
                        % format long;
                        % FieldValue = str2double(extractBetween(currentLine, 'MES=', ';'));
                        % Latitude_Narda_int = extractBetween(currentLine, ',A,', ',S,');
                        % Latitude = floor(str2double(Latitude_Narda_int)/100) + (((str2double(Latitude_Narda_int)/100) - floor(str2double(Latitude_Narda_int)/100))/0.6);
                        % Longitude_Narda_int = extractBetween(currentLine, ',S,', ',W,');
                        % Longitude = floor(str2double(Longitude_Narda_int)/100) + (((str2double(Longitude_Narda_int)/100) - floor(str2double(Longitude_Narda_int)/100))/0.6);
                        % Timestamp = datetime(extractBetween(currentLine, '-->', '*;'), "InputFormat", "yyyy/MM/dd HH:mm:ss", "Format", "dd/MM/yyyy HH:mm:ss");
                        % dataRow = timetable(Timestamp, Latitude, Longitude, FieldValue);
                        % dataArray = [dataArray; dataRow];
                        % 

                    end
                end
            
            else

                % Procura pelas linhas onde há o padrão ''^................
                % .....................................S..............W'                
                pattern = '^.....................................................S..............W';
             
                % Ler o arquivo linha por linha
                while ~feof(fileID)
                    
                    % Ler a linha atual
                    currentLine = fgetl(fileID);

                    if ~isempty(currentLine)
                        % Incrementar o contador de linhas
                        lineNumber = lineNumber + 1;
                    end
                    
                    files = fileread(fileFullName);
                    
                    % Dividir o conteúdo em linhas
                    fileContentall = string(splitlines(files));

                    % Excluir linhas vazias
                    filenonEmptyLines = fileContentall(~cellfun('isempty', fileContentall));

                    % Encontrar todas as linhas que correspondem ao padrão
                    validLines = ~cellfun(@isempty, regexp(filenonEmptyLines, pattern, 'once'));

                    fileContentall  = filenonEmptyLines(validLines);
                    

                    % Verificar se a linha corresponde ao padrão
                    if ~isempty(regexp(currentLine, pattern, 'once'))
                        
                        % Ler o conteúdo do arquivo como uma string
                        fileContentstring = fscanf(fileID, '%c');

                        % Palavra a ser procurada
                        searchWord = 'PAUSED';
                        
                        % Verificar se a palavra existe no conteúdo do arquivo
                        if contains(fileContentstring, searchWord)

                            % Encontrar as linhas que contêm 'PAUSED'
                            contains_PAUSED = contains(fileContentall, 'PAUSED');
                            
                            % Filtrar as linhas que não contêm 'PAUSED'
                            fileContent =  fileContentall(~contains_PAUSED);
                        else
                            fileContent =  fileContentall;
                        end

                        format long;

                        validLines = contains(fileContent, ',') & contains(fileContent, ',S,');
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        Latitude_Monitem_int = extractBetween(fileContent(validLines), 42, ',S,');
                        
                        % Filter the results to keep only those with exactly 9 characters
                        filteredData = Latitude_Monitem_int(strlength(Latitude_Monitem_int ) == 11);
                        
                        % Convert filteredData to a cell array if needed
                        extractedVector = cellstr(filteredData);
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        Latitude = floor(str2double(extractedVector)/100) + (((str2double(extractedVector)/100) - floor(str2double(extractedVector)/100))/0.6);
                        
                       
                        validLines = contains(fileContent, ',S,') & contains(fileContent, ',W,');
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        Longitude_Monitem_int = extractBetween(fileContent(validLines), ',S,', ',W,');
                        
                        % Filter the results to keep only those with exactly 9 characters
                        filteredData = Longitude_Monitem_int (strlength(Longitude_Monitem_int ) == 12);
                        
                        % Convert filteredData to a cell array if needed
                        extractedVector = cellstr(filteredData);

                        Longitude = floor(str2double(extractedVector)/100) + (((str2double(extractedVector)/100) - floor(str2double(extractedVector)/100))/0.6);

                    
                        validLines = contains(fileContent, ',') & contains(fileContent, ',$GPGGA');

                        % Aplicar extractBetween apenas nas linhas válidas
                        E_Monitem_int = extractBetween(fileContent(validLines), 21, ',$GPGGA');
                        
                        % Filter the results to keep only those with exactly 9 characters
                        filteredData = E_Monitem_int(strlength(E_Monitem_int ) == 4);
                        
                        % Convert filteredData to a cell array if needed
                        extractedVector = cellstr(filteredData);
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        FieldValue = str2double(extractedVector);
                        
                        % % Filter the results to keep only those with exactly 9 characters
                        % filteredData = Latitude_Monitem_int (strlength(Latitude_Monitem_int ) == 4);
                        % 
                        % % Convert filteredData to a cell array if needed
                        % extractedVector = cellstr(filteredData);
                        % 
                        % Longitude = floor(str2double(extractedVector)/100) + (((str2double(extractedVector)/100) - floor(str2double(extractedVector)/100))/0.6);
                        % 
                        % 
                        % FieldValue = str2double(extractBetween(currentLine, ',', ',$GPGGA'));
                        

                        validLines = contains(fileContent, '/') & contains(fileContent, ',');
                        
                        % Aplicar extractBetween apenas nas linhas válidas
                        Timestamp = datetime(extractBetween(fileContent(validLines), 1, 19), "InputFormat", "yyyy/MM/dd,HH:mm:ss", "Format", "dd/MM/yyyy HH:mm:ss");
                        
                        % Timestamp = datetime(extractBetween(currentLine, 1, 19), "InputFormat", "yyyy/MM/dd,HH:mm:ss", "Format", "dd/MM/yyyy HH:mm:ss");
                        dataRow = timetable(Timestamp, Latitude, Longitude, FieldValue);
                        dataTable = [dataTable; dataRow];   

                        if contsteps == count_ocorrencia{1}
                            count_ocorrencia = Comp_Cont_Step(contsteps, count_ocorrencia{1}, corrent_Step, Arq_Num, Total_Files, numOccurrences{1}, numOccurrences{2});
                            corrent_Step = count_ocorrencia{3};
                        end
                         
                        contsteps = contsteps +1;
                    end
                end
            end
            fclose(fileID);
        % fcn.Metadata(app, TypeFileMeas, File_Sondas, height(dataArray));

        [minLatitude,  maxLatitude]  = bounds(dataTable.Latitude);
        [minLongitude, maxLongitude] = bounds(dataTable.Longitude);
        
        Data_Probe = struct('Filename',        fileFullName,                ...
                                    'Measures',        height(dataTable),           ...
                                    'Sensor',          TypeFileMeas,                ...
                                    'Data',            dataTable,                   ...
                                    'LatitudeLimits',  [minLatitude;  maxLatitude], ...
                                    'LongitudeLimits', [minLongitude; maxLongitude]);

        app.MaioresnveisButton.Enable = true;
end

function ProgressoBarraStatus = Progressbar(app, File_Sondas)            
            % Criar o diálogo de progresso
            d = uiprogressdlg(app.UIFigure, 'Title', 'Aguarde a importação dos dados das medições!', ...
                'Message', 'Opening the application', ...
                'Indeterminate', 'off', ... % Para ter uma barra de progresso que aumenta gradualmente
                'Value', 0);  % Valor inicial do progresso
            
            % Ler o conteúdo do arquivo para uma string
            fileContent = fileread(File_Sondas);

            % Encontrar as ocorrências da palavra-chave
            occurrences = numel(strfind(fileContent, sprintf('\n')));

            % Encontrar as ocorrências da palavra-chave 'PAUSED'
            occurrences_PAUSED = numel(strfind(fileContent, 'PAUSED'));

            % Total de linahs com iformações úteis no arquivo
            occurrences = occurrences - occurrences_PAUSED;
                
            StepsProgress = 100;
            % Número do Sterps do Progressbar
            numOccurrences = round(occurrences/StepsProgress);
            ProgressoBarraStatus = {numOccurrences d}; 
end

function Cont_Step = Comp_Cont_Step(contsteps, count_ocorrencia, corrent_Step, Arq_Num, Total_Files, numOccurrences, d)
            corrent_Step = corrent_Step + 1;
            StepsProgress = 100;
            progress = corrent_Step / StepsProgress;
    
            % Atualiza o progresso na barra
            d.Value = progress;
            d.Message = sprintf('Lendo %dº de %d Arquivo(s) / Progresso: %d%%', ...
                Arq_Num, Total_Files, round(progress * 100));
    
            % Atualiza a contagem de ocorrências
            count_ocorrencia = count_ocorrencia + numOccurrences;
    
            Cont_Step = {count_ocorrencia d corrent_Step};
end