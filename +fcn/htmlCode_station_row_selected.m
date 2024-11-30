function htmlcontent = htmlCode_station_row_selected(Data_Meas_cache_Select, EditFieldRow)


                dataStruct    = struct('group', 'ESTAÇÃO',   'value', struct('Station', Data_Meas_cache_Select.('N° da Estacao')(EditFieldRow), ...
                                                                             'Location', strcat(Data_Meas_cache_Select.Municipio(EditFieldRow),"/",Data_Meas_cache_Select.UF(EditFieldRow)), ...
                                                                             'Latitude', Data_Meas_cache_Select.('Latitude da Estação')(EditFieldRow), ...
                                                                             'Longitude',Data_Meas_cache_Select.('Longitude da Estação')(EditFieldRow)));
                
                
                dataStruct(2) = struct('group', 'Análise',        'value', struct('Timestamp',  Data_Meas_cache_Select.('Data da Medição')(EditFieldRow), ...
                                                                                  'Field', Data_Meas_cache_Select.('Emáx (V/m)')(EditFieldRow), ...
                                                                                  'Lat_Emax', Data_Meas_cache_Select.('Latitude Emáx')(EditFieldRow), ...
                                                                                  'Long_Emax', Data_Meas_cache_Select.('Longitude Emáx')(EditFieldRow), ...
                                                                                  'Maior_14VM', Data_Meas_cache_Select.('> 14 V/M')(EditFieldRow), ...
                                                                                  'Justificativa', Data_Meas_cache_Select.('Justificativa (apenas NV)')(EditFieldRow), ...
                                                                                  'Observacoes', Data_Meas_cache_Select.('Observações importantes')(EditFieldRow)));

                htmlcontent = textFormatGUI.struct2PrettyPrintList(dataStruct, "print -1", "12px", "11px");


end