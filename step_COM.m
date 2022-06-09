clear
addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW\raw_data'
addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW'
filenames = dir('C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW\raw_data');
for n = 1:length(filenames)
    
    try
        subjfile = filenames(n).name;
        subject = subjfile(1:end-4);
        filename = load(filenames(n).name);
        name = filename.(subsref(fieldnames(filename),substruct('{}',{1})));
        label = filename.(subsref(fieldnames(filename),substruct('{}',{1}))).Trajectories.Labeled.Labels;
        path = filename.(subsref(fieldnames(filename),substruct('{}',{1}))).Trajectories.Labeled.Labels;
        sub = subjfile(1:5) + "\";
        FP1_data = name.Force(1).COP;
        data_len = length(FP1_data);
        FP = zeros(6, data_len);
        % corresponding time
        frq = length(FP1_data) / length(name.Trajectories.Labeled.Data(26,1,:));
        time = data_len / frq;
        %% step length
        step_len = step_length(path, name, time);
        %% COM calculation
        %%% Calculate the COM
        %%%find the marker
        
        LPSI_position = find(strcmp( path, 'LPSI'));
        RPSI_position = find(strcmp( path, 'RPSI'));
        LASI_position = find(strcmp( path, 'LASI'));
        RASI_position = find(strcmp( path, 'RASI'));
        LSHO_position = find(strcmp( path, 'LSHO'));
        RSHO_position = find(strcmp( path, 'RSHO'));
        LELL_position = find(strcmp( path, 'LELL'));
        RELL_position = find(strcmp( path, 'RELL'));
        LWRR_position = find(strcmp( path, 'LWRR'));
        RWRR_position = find(strcmp( path, 'RWRR'));
        LFLE_position = find(strcmp( path, 'LFLE'));
        RFLE_position = find(strcmp( path, 'RFLE'));
        LLMAL_position = find(strcmp( path, 'LLMAL'));
        RLMAL_position = find(strcmp( path, 'RLMAL'));


        %%%
        %coordination = 2 ;% 1: anterior-posterior, 2: medial-lateral, 3: up and down
        LPSI_data = name.Trajectories.Labeled.Data(LPSI_position,1:3,:);
        RPSI_data = name.Trajectories.Labeled.Data(RPSI_position,1:3,:);
        LASI_data = name.Trajectories.Labeled.Data(LASI_position,1:3,:);
        RASI_data = name.Trajectories.Labeled.Data(RASI_position,1:3,:);
        LSHO_data = name.Trajectories.Labeled.Data(LSHO_position,1:3,:);
        RSHO_data = name.Trajectories.Labeled.Data(RSHO_position,1:3,:);
        LELL_data = name.Trajectories.Labeled.Data(LELL_position,1:3,:);
        RELL_data = name.Trajectories.Labeled.Data(RELL_position,1:3,:);
        %LWRR_data = name.Trajectories.Labeled.Data(LWRR_position,1:3,:);
        %RWRR_data = name.Trajectories.Labeled.Data(RWRR_position,1:3,:);
        LFLE_data = name.Trajectories.Labeled.Data(LFLE_position,1:3,:);
        RFLE_data = name.Trajectories.Labeled.Data(RFLE_position,1:3,:);
        LLMAL_data = name.Trajectories.Labeled.Data(LLMAL_position,1:3,:);
        RLMAL_data = name.Trajectories.Labeled.Data(RLMAL_position,1:3,:);


        %%%
        LPSI_data = reshape(LPSI_data, [3, time]);
        RPSI_data = reshape(RPSI_data, [3,time]);
        LASI_data = reshape(LASI_data, [3,time]);
        RASI_data = reshape(RASI_data, [3,time]);
        LSHO_data = reshape(LSHO_data, [3,time]);
        RSHO_data = reshape(RSHO_data, [3,time]);
        LELL_data = reshape(LELL_data, [3,time]);
        RELL_data = reshape(RELL_data, [3,time]);
        %LWRR_data = reshape(LWRR_data, [3,time]);
        %RWRR_data = reshape(RWRR_data, [3,time]);
        LFLE_data = reshape(LFLE_data, [3,time]);
        RFLE_data = reshape(RFLE_data, [3,time]);
        LLMAL_data = reshape(LLMAL_data, [3,time]);
        RLMAL_data = reshape(RLMAL_data, [3,time]);


        %%%
        LASI = LASI_data;
        LPSI = LPSI_data;
        RASI = RASI_data;
        RPSI = RPSI_data;

        [hip_center, L_hip_center, R_hip_center] = hip_markers(LASI, LPSI, RASI, RPSI);

        L_shoulder  = LSHO_data;
        R_shoulder  = RSHO_data;
        L_elbow     = LELL_data;
        R_elbow     = RELL_data;
        L_hand      = "missing_marker";
        R_hand	    = "missing_marker";
        L_knee	    = LFLE_data;
        R_knee      = RFLE_data;
        L_ankle	    = LLMAL_data;
        R_ankle     = RLMAL_data;
        hip_center = hip_center;
        L_hip_center = L_hip_center;
        R_hip_center = R_hip_center;


        New_COM = COM_function(time, L_shoulder, R_shoulder, L_elbow, R_elbow, L_hand, R_hand, L_knee, R_knee, L_ankle, R_ankle,hip_center, L_hip_center, R_hip_center, 1);
        %% XCOM
        % w0 = sqrt(g / l)
        % xCOM = COM + Vcom / w0
        % l = pendulum length, leg length
        COM = New_COM ./ 1000;
        dt = 1 / 200;


        %%% the code below is to form the velocity data in different axis for different marker
        % SHO = axis_v_data(1,:), ELL = axis_v_data(2,:), ELM = axis_v_data(3,:), WRR = axis_v_data(4,:), WRU = axis_v_data(5,:)


        x_v_data = zeros(1, time );
        for i = 1:(time-1)
            x_v_data(1,i) = ((COM(1, i+1) - COM(1, i)) / dt);
        end


        y_v_data = zeros(1, time );
        for i = 1:(time-1)
            y_v_data(1,i) = ((COM(2, i+1) - COM(2, i)) / dt);
        end

        z_v_data = zeros(1, time );
        for i = 1:(time-1)
            z_v_data(1,i) = ((COM(3, i+1) - COM(3, i)) / dt);
        end

        total = zeros(3,time);
        for i = 1:(time-1)
            total(1,i) = x_v_data(1,i);
            total(2,i) = y_v_data(1,i);
            total(3,i) = z_v_data(1,i);
        end

        % plot the velocity
        %plot(total(1,:))
        %hold on 
        % plot the trajectory
        %plot(WRR(3,:))


        duration = 10;
        g = 9.81;
        l = (nanmean(COM(3,:)));
        w0 = sqrt( g / l);
        Vcom = x_v_data(1,:);
        XCOM = (COM) + (total/ w0);
        count = 1;
        [v,p] = findpeaks(step_len, "MinPeakProminence", 20);
        for index_num = 1:length(p)
            try 
                step_XCOM = XCOM(:, p(index_num):p(index_num+1));
                x_std(count) = nanstd(step_XCOM(1,:));
                y_std(count) = nanstd(step_XCOM(2,:));
                z_std(count) = nanstd(step_XCOM(3,:));
                count = count + 1;
            catch
                continue
            end
        end
        col = ["x_step_std_xcom", "y_step_std_xcom", "z_step_std_xcom"];
        info = transpose([x_std; y_std; z_std]);
        save_data = [col; info];
        
        saved_path_name = "C:/Users/a1003/OneDrive/桌面/Project_Review/side_walk_new/SW/csv_file/step_XCOM/SW/" + subject + "_step_XCOM.csv";
        writematrix(save_data, saved_path_name)
        clear
        addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW\raw_data'
        addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW'
        filenames = dir('C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW\raw_data');
    catch
        [subjfile,n]
        %clear
        addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW\raw_data'
        addpath 'C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW'
        filenames = dir('C:\Users\a1003\OneDrive\桌面\Project_Review\side_walk_new\SW\raw_data');
        continue
    end
end
