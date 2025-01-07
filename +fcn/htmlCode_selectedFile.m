function htmlContent = htmlCode_selectedFile(measData)    
    dataStruct    = struct('group', 'ARQUIVO', 'value', measData.Filename);
    dataStruct(2) = struct('group', 'SENSOR',  'value', measData.MetaData);
    
    dataStruct(3) = struct('group', 'ROTA',    'value', struct('LatitudeLimits',   sprintf('[%.6f, %.6f]', measData.LatitudeLimits(:)),  ...
                                                               'LongitudeLimits',  sprintf('[%.6f, %.6f]', measData.LongitudeLimits(:)), ...
                                                               'Latitude',         measData.Latitude,        ...
                                                               'Longitude',        measData.Longitude,       ...
                                                               'Location',         measData.Location,        ...
                                                               'CoveredDistance',  sprintf('%.1f km', measData.CoveredDistance)));


    dataStruct(4) = struct('group', 'MEDIDAS', 'value', struct('Measures',         measData.Measures,        ...
                                                               'ObservationTime',  measData.ObservationTime, ...
                                                               'FieldValueLimits', sprintf('[%.1f - %.1f] V/m', measData.FieldValueLimits(:))));

    htmlContent   = [sprintf('<p style="font-family: Helvetica, Arial, sans-serif; font-size: 10px; margin: 5px; color: white; background-color: red; display: inline-block; vertical-align: middle; padding: 5px; border-radius: 5px;">%s</p>', upper(measData.Sensor)) ...
                     textFormatGUI.struct2PrettyPrintList(dataStruct, 'delete')];
end