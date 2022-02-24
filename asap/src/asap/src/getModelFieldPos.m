function fieldpos = getModelFieldPos(field, modelPose)

fieldpos = 'trash_zone';
fields = fieldnames(field);

try
    x = modelPose.position.x;
    y = modelPose.position.y;
catch
    x = modelPose.x;
    y = modelPose.y;
end

for i = 1:length(fields)
    xref = field.(fields{i}).area.x;
    yref = field.(fields{i}).area.y;
    if (x > xref(1) && x < xref(2) && y > yref(1) && y < yref(2))
        fieldpos = fields{i};
    end
end

end