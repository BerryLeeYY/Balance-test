function step_len = step_length(path, name, time)
    LCAL1_position = find(strcmp( path, 'LCAL1'));
    RCAL1_position = find(strcmp( path, 'RCAL1'));

    LCAL1_data = name.Trajectories.Labeled.Data(LCAL1_position,1:3,:);
    RCAL1_data = name.Trajectories.Labeled.Data(RCAL1_position,1:3,:);
    LCAL1_data_reshape = reshape(LCAL1_data, [3,time]);
    RCAL1_data_reshape = reshape(RCAL1_data, [3,time]);

    step_len = abs(RCAL1_data_reshape(1,:) - LCAL1_data_reshape(1,:));
    %step_width = abs(RCAL2_data_reshape(2,:) - LCAL2_data_reshape(2,:));
end