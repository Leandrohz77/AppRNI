function Data_Monitem_Narda  = ReadFile_Meas_Sondas(app, TypeFileMeas, File_Sondas, Arq_Num, Total_Files)

            %Inicia as vairáveis da barra de progresso
            contsteps = 0;
            count_ocorrencia = {};
            count_ocorrencia{1} = 0;
            corrent_Step = 0;

            %Cria a barra de progresso e calcula os Steps
            numOccurrences = Progressbar(app, File_Sondas);

            % Abrir o arquivo para leitura
            fileID = fopen(File_Sondas, 'r');
            
            % Verificar se o arquivo foi aberto com sucesso
            if fileID == -1
                error('Erro ao abrir o arquivo.');
            end

            % Ler e processar o conteúdo a partir da linha desejada
            dataArray = {};
            Data_Monitem_Narda = {};

            % Inicializar variáveis
            lineNumber = 0;

            if TypeFileMeas == "Narda"

                % Procura pelas linhas onde há o padrão '^.................
                % .........................................S............W'
                pattern = '^..........................................................S............W';
                
                % Ler o arquivo linha por linha
                while ~feof(fileID)
                    % Ler a linha atual
                    currentLine = fgetl(fileID);

                    if ~isempty(currentLine)
                        % Incrementar o contador de linhas
                        lineNumber = lineNumber + 1;
                    end
                    
                    % Verificar se a linha corresponde ao padrão
                    if ~isempty(regexp(currentLine, pattern, 'once'))
                        format long;
                        E_Narda = extractBetween(currentLine, 'MES=', ';');
                        Latitude_Narda_int = extractBetween(currentLine, ',A,', ',S,');
                        Latitude_Narda = floor(str2double(Latitude_Narda_int)/100) + (((str2double(Latitude_Narda_int)/100) - floor(str2double(Latitude_Narda_int)/100))/0.6);
                        Longitude_Narda_int = extractBetween(currentLine, ',S,', ',W,');
                        Longitude_Narda = floor(str2double(Longitude_Narda_int)/100) + (((str2double(Longitude_Narda_int)/100) - floor(str2double(Longitude_Narda_int)/100))/0.6);
                        DataTime_Narda = extractBetween(currentLine, '-->', '*;');
                        dataRow = [DataTime_Narda Latitude_Narda Longitude_Narda E_Narda];
                        dataArray = [dataArray; dataRow];

                        if contsteps == count_ocorrencia{1}
                            count_ocorrencia = Comp_Cont_Step(contsteps, count_ocorrencia{1}, corrent_Step, Arq_Num, Total_Files, numOccurrences{1}, numOccurrences{2});
                            corrent_Step = count_ocorrencia{3};
                        end                         
                        contsteps = contsteps +1; 
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
                    
                    % Verificar se a linha corresponde ao padrão
                    if ~isempty(regexp(currentLine, pattern, 'once'))
                        format long;
                        Latitude_Monitem_int = extractBetween(currentLine, 42, ',S,');
                        Latitude_Monitem = floor(str2double(Latitude_Monitem_int)/100) + (((str2double(Latitude_Monitem_int)/100) - floor(str2double(Latitude_Monitem_int)/100))/0.6);
                        Longitude_Monitem_int = extractBetween(currentLine, ',S,', ',W,');
                        Longitude_Monitem = floor(str2double(Longitude_Monitem_int)/100) + (((str2double(Longitude_Monitem_int)/100) - floor(str2double(Longitude_Monitem_int)/100))/0.6);
                        E_Monitem = extractBetween(currentLine, 21, ',$GPGGA');
                        DataTime_Monitem = extractBetween(currentLine, 1, 19);
                        dataRow = [DataTime_Monitem Latitude_Monitem Longitude_Monitem E_Monitem];
                        dataArray = [dataArray; dataRow];   

                        if contsteps == count_ocorrencia{1}
                            count_ocorrencia = Comp_Cont_Step(contsteps, count_ocorrencia{1}, corrent_Step, Arq_Num, Total_Files, numOccurrences{1}, numOccurrences{2});
                            corrent_Step = count_ocorrencia{3};
                        end
                         
                        contsteps = contsteps +1;
                    end
                end
            end
        % fcn.Metadata(app, TypeFileMeas, File_Sondas, height(dataArray));
        
        Data_Monitem_Narda  = {File_Sondas, contsteps, TypeFileMeas, dataArray};
        % Fechar a barra de progresso
        close(numOccurrences{3});
        app.MaioresnveisButton.Enable = true;
end

function ProgressoBarraStatus = Progressbar(app, File_Sondas)
            % Criar a figura da barra de progresso
            % Tamanho da tela
            screenSize = get(0, 'ScreenSize');
            screenWidth = screenSize(3);
            screenHeight = screenSize(4);
            
            % Define o tamanho da figura
            figWidth = 400;
            figHeight = 110;
            
            % Calcula a posição para centralizar a figura na tela
            figLeft = (screenWidth - figWidth) / 2;
            figBottom = (screenHeight - figHeight) / 2;
            
            % Cria a figura centralizada e desabilita a maximização
            fig = uifigure('Position', [figLeft, figBottom, figWidth, figHeight], 'Resize', 'off');
            
            % Criar o diálogo de progresso
            d = uiprogressdlg(fig, 'Title', 'Aguarde a importação dos dados das medições!', ...
                'Message', 'Opening the application', ...
                'Indeterminate', 'off', ... % Para ter uma barra de progresso que aumenta gradualmente
                'Value', 0);  % Valor inicial do progresso           
            drawnow
            
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
            ProgressoBarraStatus = {numOccurrences d fig}; 
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