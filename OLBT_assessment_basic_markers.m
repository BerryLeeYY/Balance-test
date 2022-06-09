%% load the data
clear
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis\data\OLBT\all'
addpath 'C:\Users\a1003\OneDrive\桌面\Thesis'
subject = ('sub14.2_11-limb-eyecl-wl_0003');%%%%%
subjfile = [(subject),'.mat'];
save_file_name = "sub14.2_OLBT_wl_03_basic.csv";%%%%%
load(subjfile);
sub = "sub14.2\";                         %%%%%%
%R_data = load(subject);
name = qtm_1_limb_eyecl_wl_0003; %%%%%%%
label = name.Trajectories.Labeled.Labels; 
path = name.Trajectories.Labeled.Labels;



%% trajectory 

desired_markers = ["RDM1", "LDM1", "RCAL1", "LCAL1", "RFLE", "LFLE", "RASI", "LASI", "STRN", "RELL", "LELL", "RELM", "LELM", "RFTC", "LFTC", "RLMAL", "LLMAL", "RMMAL", "LMMAL"];
count = 1;
for i = desired_markers
    marker_position = find(strcmp( path, i));
    markers_position(count) = marker_position;
    count = count + 1;
end

trajectory = name.Trajectories.Labeled.Data(markers_position,1:3,:);
x_traj = trajectory(:,1,:);
x_traj = reshape(x_traj, [size(x_traj,1), (length(x_traj))]);
y_traj = trajectory(:,2,:);
y_traj = reshape(y_traj, [size(y_traj,1), (length(y_traj))]);
z_traj = trajectory(:,3,:);
z_traj = reshape(z_traj, [size(z_traj,1), (length(z_traj))]);

for i  = 1:size(x_traj,1)
    mean_x_traj(i) = nanmean(x_traj(i,:));
    mean_y_traj(i) = nanmean(y_traj(i,:));
    mean_z_traj(i) = nanmean(z_traj(i,:));
    
    std_x_traj(i) = nanstd(x_traj(i,:));
    std_y_traj(i) = nanstd(y_traj(i,:));
    std_z_traj(i) = nanstd(z_traj(i,:));
    
    max_x_traj(i) = nanmax(x_traj(i,:));
    max_y_traj(i) = nanmax(y_traj(i,:));
    max_z_traj(i) = nanmax(z_traj(i,:));
    
    min_x_traj(i) = nanmin(x_traj(i,:));
    min_y_traj(i) = nanmin(y_traj(i,:));
    min_z_traj(i) = nanmin(z_traj(i,:));
end

%% velocity
for marker = 1:size(x_traj,1)
    for i = 1:(length(x_traj)-1)
        x_velocity(marker,i) = (x_traj(marker,i+1) - x_traj(marker,i))/(1/length(x_traj));
        y_velocity(marker,i) = (y_traj(marker,i+1) - y_traj(marker,i))/(1/length(y_traj));
        z_velocity(marker,i) = (z_traj(marker,i+1) - z_traj(marker,i))/(1/length(z_traj));
    end
end
x_velocity(93,1,end) = 0;
y_velocity(93,1,end) = 0;
z_velocity(93,1,end) = 0;

for i  = 1:size(x_velocity,1)
    mean_x_v(i) = nanmean(x_velocity(i,:));
    mean_y_v(i) = nanmean(y_velocity(i,:));
    mean_z_v(i) = nanmean(z_velocity(i,:));
    
    std_x_v(i) = nanstd(x_velocity(i,:));
    std_y_v(i) = nanstd(y_velocity(i,:));
    std_z_v(i) = nanstd(z_velocity(i,:));
    
    max_x_v(i) = nanmax(x_velocity(i,:));
    max_y_v(i) = nanmax(y_velocity(i,:));
    max_z_v(i) = nanmax(z_velocity(i,:));
    
    min_x_v(i) = nanmin(x_velocity(i,:));
    min_y_v(i) = nanmin(y_velocity(i,:));
    min_z_v(i) = nanmin(z_velocity(i,:));
end
%% acceleration 
for marker = 1:size(x_velocity,1)
    for i = 1:(length(x_velocity)-1)
        x_acc(marker,i) = (x_velocity(marker,i+1) - x_velocity(marker,i))/(1/length(x_velocity));
        y_acc(marker,i) = (y_velocity(marker,i+1) - y_velocity(marker,i))/(1/length(y_velocity));
        z_acc(marker,i) = (z_velocity(marker,i+1) - z_velocity(marker,i))/(1/length(z_velocity));
    end
end
x_acc(93,1,end) = 0;
y_acc(93,1,end) = 0;
z_acc(93,1,end) = 0;

for i  = 1:size(x_acc,1)
    mean_x_acc(i) = nanmean(x_acc(i,:));
    mean_y_acc(i) = nanmean(y_acc(i,:));
    mean_z_acc(i) = nanmean(z_acc(i,:));
    
    std_x_acc(i) = nanstd(x_acc(i,:));
    std_y_acc(i) = nanstd(y_acc(i,:));
    std_z_acc(i) = nanstd(z_acc(i,:));
    
    max_x_acc(i) = nanmax(x_acc(i,:));
    max_y_acc(i) = nanmax(y_acc(i,:));
    max_z_acc(i) = nanmax(z_acc(i,:));
    
    min_x_acc(i) = nanmin(x_acc(i,:));
    min_y_acc(i) = nanmin(y_acc(i,:));
    min_z_acc(i) = nanmin(z_acc(i,:));
end

%%
final_df = [mean_x_traj, mean_y_traj, mean_z_traj, std_x_traj, std_y_traj, std_z_traj, max_x_traj, max_y_traj, max_z_traj, min_x_traj, min_y_traj, min_y_traj, mean_x_v, mean_y_v, mean_z_v, std_x_v, std_y_v, std_z_v, max_x_v, max_y_v, max_z_v, min_x_v, min_y_v, min_y_v, mean_x_acc, mean_y_acc, mean_z_acc, std_x_acc, std_y_acc, std_z_acc, max_x_acc, max_y_acc, max_z_acc, min_x_acc, min_y_acc, min_y_acc ];
saved_path_name = "C:\Users\a1003\OneDrive\桌面\Thesis\data\OLBT\basic_marker\" + sub + save_file_name;
writematrix(final_df, saved_path_name)