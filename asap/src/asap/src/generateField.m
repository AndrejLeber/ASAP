function generateField(fieldSize, numOfFields, plotField)

% fieldSize = Size of the complete squared field (without goal position) in meters
% numOfFields: Number of squared fields, that the whole field with squared
%              fieldSize is seperated in
% plotField = if true, generated field is visualized in MATLAB

if (nargin < 3)
    plotField = false;
end

characterlist = 'abcdefghijklmnopqrstuvwxyz';
w = fieldSize/sqrt(numOfFields);

%% Create empty struct with the right size
fieldnames = string(zeros(numOfFields+1,1));
for i=1:sqrt(numOfFields)
    for j=1:sqrt(numOfFields)
        idx = (i-1)*sqrt(numOfFields)+j;
        fieldnames(idx) = convertCharsToStrings(characterlist(i)) + num2str(j);
        command = "field" + "." + fieldnames(idx) + ".area.x = [" + ...
            num2str(w*(i-1)) + " " + num2str(w*(i-1)+w) + "];";
        eval(command);
        command = "field" + "." + fieldnames(idx) + ".area.y = [" + ...
            num2str(fieldSize-w*j) + " " + num2str(fieldSize-w*j+w) + "];";
        eval(command);
        command =  "field" + "." + fieldnames(idx) + ".center.x = " + ...
            num2str(w*(i-1) + fieldSize/sqrt(numOfFields)/2) + ";";
        eval(command);
        command =  "field" + "." + fieldnames(idx) + ".center.y = " + ...
            num2str(fieldSize-w*j + fieldSize/sqrt(numOfFields)/2) + ";";
        eval(command);
    end
end

fieldnames(end) = "trash_zone";
field.trash_zone.area.x = [fieldSize/2-w, fieldSize/2+w];
field.trash_zone.area.y = [fieldSize, fieldSize+w];
field.trash_zone.center.x = fieldSize/2;
field.trash_zone.center.y = fieldSize + w/2;


%% Visualize field
if (plotField == true)
    figure();
    hold on;
    
    for i=1:length(fieldnames)-1
        command = "rectangle('Position', [field." + fieldnames(i) + ".area.x(1)," +  ...
            " field." + fieldnames(i) + ".area.y(1)," + " w, w], 'EdgeColor', 'b', 'LineWidth', 2);";
        eval(command);
        command = "text(field." + fieldnames(i) + ".center.x, field." + fieldnames(i) + ".center.y, '" + ...
            fieldnames(i) + "','HorizontalAlignment','center')";
        eval(command);
    end
    
    rectangle('Position', [field.trash_zone.area.x(1), field.trash_zone.area.y(1), 2*w, w/2], 'EdgeColor', 'b', 'FaceColor', 'green', 'LineWidth', 2);
    text(field.trash_zone.center.x, field.trash_zone.center.y, 'trash zone', 'HorizontalAlignment','center');
end

%% Save the generated field as workspace variable
save field.mat field;

end