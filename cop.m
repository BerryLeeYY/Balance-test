%% load the data
clear
addpath 'D:\files\COP'
addpath 'D:\files\COP'
filenames = dir('D:\files\COP\all');

for n = 1:length(filenames)
    
    try
        subjfile = filenames(n).name;
        subject = subjfile(1:end-4);
        filename = load(filenames(n).name);
        name = filename.(subsref(fieldnames(filename),substruct('{}',{1})));
        %%% store COP position
        FP1_COP_data = name.Force(1).COP(:,15000:75000);
        FP2_COP_data = name.Force(2).COP(:,15000:75000);
        FP3_COP_data = name.Force(3).COP(:,15000:75000);
        FP4_COP_data = name.Force(4).COP(:,15000:75000);
        FP5_COP_data = name.Force(5).COP(:,15000:75000);
        FP6_COP_data = name.Force(6).COP(:,15000:75000);
        FP7_COP_data = name.Force(7).COP(:,15000:75000);
        
        %%% store force signal
        FP1_Force_data = name.Force(1).Force(:,15000:75000);
        FP2_Force_data = name.Force(2).Force(:,15000:75000);
        FP3_Force_data = name.Force(3).Force(:,15000:75000);
        FP4_Force_data = name.Force(4).Force(:,15000:75000);
        FP5_Force_data = name.Force(5).Force(:,15000:75000);
        FP6_Force_data = name.Force(6).Force(:,15000:75000);
        FP7_Force_data = name.Force(7).Force(:,15000:75000);
        
        
        %% COP Processing
        
        %%% calculating the mean of force signal to determine whether the foot step
        %%% on the force platform
        force_mean_all = [nanmean(0-FP1_Force_data(3,:)); nanmean(0-FP2_Force_data(3,:)); nanmean(0-FP3_Force_data(3,:)); nanmean(0-FP4_Force_data(3,:)); nanmean(0-FP5_Force_data(3,:)); nanmean(0-FP6_Force_data(3,:)); nanmean(0-FP7_Force_data(3,:))];
        
        %%% store all force platform signla to the  further use
        force_all = [FP1_Force_data(3,:); FP2_Force_data(3,:); FP3_Force_data(3,:); FP4_Force_data(3,:); FP5_Force_data(3,:); FP6_Force_data(3,:); FP7_Force_data(3,:)];
        COP_x_all = [FP1_COP_data(1,:); FP2_COP_data(1,:); FP3_COP_data(1,:); FP4_COP_data(1,:); FP5_COP_data(1,:); FP6_COP_data(1,:); FP7_COP_data(1,:)];
        COP_y_all = [FP1_COP_data(2,:); FP2_COP_data(2,:); FP3_COP_data(2,:); FP4_COP_data(2,:); FP5_COP_data(2,:); FP6_COP_data(2,:); FP7_COP_data(2,:)];
        [pks, loc] = findpeaks(force_mean_all, "MinPeakHeight", 5);
        
        if length(loc) == 2
            if abs(nanmean(0-force_all(loc(1),:))) > abs(nanmean(0-force_all(loc(2),:)))
                supporting_FP = force_all(loc(1),:);
                swinging_FP = force_all(loc(2),:);
                supporting_x_COP = COP_x_all(loc(1),:);
                swinging_x_COP = COP_x_all(loc(2),:);
                supporting_y_COP = COP_y_all(loc(1),:);
                swinging_y_COP = COP_y_all(loc(2),:);
                for i = 1:length(supporting_FP)
                    if abs(supporting_FP(i)) > 50 && abs(swinging_FP(i)) > 50
                        distribution_supp = abs(supporting_FP(i))/ (abs(supporting_FP(i)) + abs(swinging_FP(i)));
                        distribution_swin = abs(swinging_FP(i))/ (abs(supporting_FP(i)) + abs(swinging_FP(i)));   
                        COP_x_tra = supporting_x_COP(i)*distribution_supp + swinging_x_COP(i)*distribution_swin;
                        COP_y_tra = supporting_y_COP(i)*distribution_supp + swinging_y_COP(i)*distribution_swin;
                    elseif abs(supporting_FP(i)) > 50 && abs(swinging_FP(i)) < 50
                        COP_x_tra = supporting_x_COP(i);
                        COP_y_tra = supporting_y_COP(i);
                    elseif abs(supporting_FP(i)) < 50 && abs(swinging_FP(i)) > 50
                        COP_x_tra = swinging_x_COP(i);
                        COP_y_tra = swinging_y_COP(i);
                    elseif abs(supporting_FP(i)) < 50 && abs(swinging_FP(i))< 50
                        COP_x_tra = nan;
                        COP_y_tra = nan;
                    end
                    final_x_COP(i) = COP_x_tra;
                    final_y_COP(i) = COP_y_tra;
         
                end
            elseif abs(nanmean(0-force_all(loc(1),:))) < abs(nanmean(0-force_all(loc(2),:)))
                supporting_FP = force_all(loc(2),:);
                swinging_FP = force_all(loc(1),:);
                supporting_x_COP = COP_x_all(loc(2),:);
                swinging_x_COP = COP_x_all(loc(1),:);
                supporting_y_COP = COP_y_all(loc(2),:);
                swinging_y_COP = COP_y_all(loc(1),:);
                for i = 1:length(supporting_FP)
                    if abs(supporting_FP(i)) > 50 && abs(swinging_FP(i)) > 50
                        distribution_supp = abs(supporting_FP(i))/ (abs(supporting_FP(i)) + abs(swinging_FP(i)));
                        distribution_swin = abs(swinging_FP(i))/ (abs(supporting_FP(i)) + abs(swinging_FP(i)));   
                        COP_x_tra = supporting_x_COP(i)*distribution_supp + swinging_x_COP(i)*distribution_swin;
                        COP_y_tra = supporting_y_COP(i)*distribution_supp + swinging_y_COP(i)*distribution_swin;
                    elseif abs(supporting_FP(i)) > 50 && abs(swinging_FP(i)) < 50
                        COP_x_tra = supporting_x_COP(i);
                        COP_y_tra = supporting_y_COP(i);
                    elseif abs(supporting_FP(i)) < 50 && abs(swinging_FP(i)) > 50
                        COP_x_tra = swinging_x_COP(i);
                        COP_y_tra = swinging_y_COP(i);
                    elseif abs(supporting_FP(i)) < 50 && abs(swinging_FP(i))< 50
                        COP_x_tra = nan;
                        COP_y_tra = nan;
                    end
                    final_x_COP(i) = COP_x_tra;
                    final_y_COP(i) = COP_y_tra;
         
                end
            end
        elseif length(loc) == 1
            final_x_COP = COP_x_all(loc(1),:);
            final_y_COP = COP_y_all(loc(1),:);
        end
        
        AP_COP = final_x_COP;
        ML_COP = final_y_COP;
        
        %%% mean
        %%% SD
        %%% min
        %%% max
        %%% cumulative sum COP values from 0-60 sec
        %%% range of motion (max - min)
        
        
        %% AP
        AP_mean = round(nanmean(AP_COP), 2);
        AP_SD = round(nanstd(AP_COP), 2);
        AP_min = round(nanmin(AP_COP), 2);
        AP_max = round(nanmax(AP_COP), 2);
        AP_cumulative = string(max(abs(cumsum(AP_COP)))/1000);
        AP_RoM = round(abs(AP_max - AP_min), 2);
        
        %% ML
        ML_mean = round(nanmean(ML_COP), 2);
        ML_SD = round(nanstd(ML_COP), 2);
        ML_min = round(nanmin(ML_COP), 2);
        ML_max = round(nanmax(ML_COP), 2);
        ML_cumulative = string(max(abs(cumsum(ML_COP)))/1000);
        ML_RoM = round(abs(ML_max - ML_min), 2);
        
        %% Save file
        
        col = ["AP_mean", "AP_SD", "AP_min", "AP_max", "AP_cumulative", "AP_RoM", ...
            "ML_mean", "ML_SD", "ML_min", "ML_max", "ML_cumulative", "ML_RoM"];
        infor = [AP_mean, AP_SD, AP_min, AP_max, AP_cumulative, AP_RoM, ...
            ML_mean, ML_SD, ML_min, ML_max, ML_cumulative, ML_RoM];
        save_data = [col;infor];
        
        saved_path_name = "D:\files\COP\excel_new\" + subject + "_COP.xlsx";
        xlswrite(saved_path_name, save_data)
        clear
        addpath 'D:\files\COP'
        addpath 'D:\files\COP'
        filenames = dir('D:\files\COP\all');
    catch
        subjfile
        %clear
        addpath 'D:\files\COP'
        addpath 'D:\files\COP'
        filenames = dir('D:\files\COP\all');
        continue
    end
end        



