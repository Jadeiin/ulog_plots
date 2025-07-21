%% 实现读取PX4日志（.ulg）数据并绘图

%% 读取数据并进行错误处理
file = 'log001.ulg';
try
    fds = ulgReader(file);
    % 位置和位置期望数据
    local_position_setpoint = fds.logs.vehicle_local_position_setpoint_0;
    local_position = fds.logs.vehicle_local_position_0;
    % 加速度
    acceleration = fds.logs.vehicle_acceleration_0;
    % 姿态和姿态期望数据
    attitude_setpoint = fds.logs.vehicle_attitude_setpoint_0;
    attitude = fds.logs.vehicle_attitude_0;
    % 角速度期望和遥控器数据
    rates_setpoint = fds.logs.vehicle_rates_setpoint_0;
    angular_velocity = fds.logs.vehicle_angular_velocity_0;
    % 遥控器数据
    % rc_channels = fds.logs.rc_channels_0;
    % PWM输出数据
    actuator_outputs = fds.logs.actuator_outputs_0;
catch ME
    error('数据导入失败: %s', ME.message);
end

% 选择使用相对时间还是绝对时间
useRelativeTime = true; % true=相对时间，false=绝对时间

% 统一时间基准
if useRelativeTime
    t0 = min([
        local_position.timestamp(1), ...
        local_position_setpoint.timestamp(1), ...
        attitude.timestamp(1), ...
        attitude_setpoint.timestamp(1), ...
        angular_velocity.timestamp(1), ...
        rates_setpoint.timestamp(1), ...
        actuator_outputs.timestamp(1), ...
        acceleration.timestamp(1)
    ]);
else
    t0 = 0;
end

%% 绘图

% 创建保存图片的文件夹
plotFolder = 'plots';
if ~exist(plotFolder, 'dir')
    mkdir(plotFolder);
    disp(['已创建文件夹: ', plotFolder]);
end

% 设置图形参数
titleSize = 20;     % 标题字号
labelSize = 18;     % 坐标轴标签字号
legendSize = 14;    % 图例字号
figureWidth = 640;  % 图像宽度
figureHeight = 480;  % 图像高度


% Create 2x3 subplots for position and attitude
figure(20);
set(gcf, 'Position', [100, 100, 1280, 960], 'Color', 'white');

% Find peak acceleration times
[~, x_peak_idx] = max(abs(acceleration.xyz_0));
[~, y_peak_idx] = max(abs(acceleration.xyz_1));
peak_time1 = (acceleration.timestamp(x_peak_idx)-t0)*1e-6;
peak_time2 = (acceleration.timestamp(y_peak_idx)-t0)*1e-6;
highlight_start = min(peak_time1, peak_time2);
highlight_end = max(peak_time1, peak_time2);

% X Position
subplot(2,3,1);
% Get data range first
plot((local_position.timestamp-t0)*1e-6, local_position.y, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.y, 'm:', 'LineWidth', 1);
ylims = ylim;
% Add light pink background for peak acceleration period
patch([highlight_start highlight_end highlight_end highlight_start], [ylims(1)-100 ylims(1)-100 ylims(2)+100 ylims(2)+100], [1 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot((local_position.timestamp-t0)*1e-6, local_position.y, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.y, 'm:', 'LineWidth', 1);
ylim([ylims(1), ylims(2)]); % Restore original y-limits
hold off;
grid on;
title('X Position', 'FontSize', titleSize);
xlabel('Time (s)', 'FontSize', labelSize);
ylabel('X Position (m)', 'FontSize', labelSize);
legend('Actual', 'Desired', 'FontSize', legendSize, 'Location', 'northwest');

% Y Position
subplot(2,3,2);
plot((local_position.timestamp-t0)*1e-6, -local_position.x, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, -local_position_setpoint.x, 'm:', 'LineWidth', 1);
ylims = ylim;
% Add light pink background for peak acceleration period
patch([highlight_start highlight_end highlight_end highlight_start], [ylims(1)-100 ylims(1)-100 ylims(2)+100 ylims(2)+100], [1 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot((local_position.timestamp-t0)*1e-6, -local_position.x, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, -local_position_setpoint.x, 'm:', 'LineWidth', 1);
ylim([ylims(1), ylims(2)]); % Restore original y-limits
hold off;
grid on;
title('Y Position', 'FontSize', titleSize);
xlabel('Time (s)', 'FontSize', labelSize);
ylabel('Y Position (m)', 'FontSize', labelSize);
legend('Actual', 'Desired', 'FontSize', legendSize, 'Location', 'northwest');

% Z Position
subplot(2,3,3);
plot((local_position.timestamp-t0)*1e-6, local_position.z, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.z, 'm:', 'LineWidth', 1);
ylims = ylim;
% Add light pink background for peak acceleration period
patch([highlight_start highlight_end highlight_end highlight_start], [ylims(1)-100 ylims(1)-100 ylims(2)+100 ylims(2)+100], [1 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot((local_position.timestamp-t0)*1e-6, local_position.z, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.z, 'm:', 'LineWidth', 1);
ylim([ylims(1), ylims(2)]); % Restore original y-limits
hold off;
grid on;
title('Z Position', 'FontSize', titleSize);
xlabel('Time (s)', 'FontSize', labelSize);
ylabel('Z Position (m)', 'FontSize', labelSize);
legend('Actual', 'Desired', 'FontSize', legendSize, 'Location', 'northwest');

% Roll
subplot(2,3,4);
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.roll_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.roll_body), 'm:', 'LineWidth', 1);
ylims = ylim;
% Add light pink background for peak acceleration period
patch([highlight_start highlight_end highlight_end highlight_start], [ylims(1)-100 ylims(1)-100 ylims(2)+100 ylims(2)+100], [1 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.roll_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.roll_body), 'm:', 'LineWidth', 1);
ylim([ylims(1), ylims(2)]); % Restore original y-limits
hold off;
grid on;
title('Roll Angle', 'FontSize', titleSize);
xlabel('Time (s)', 'FontSize', labelSize);
ylabel('Roll (deg)', 'FontSize', labelSize);
legend('Actual', 'Desired', 'FontSize', legendSize, 'Location', 'northwest');

% Pitch
subplot(2,3,5);
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.pitch_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.pitch_body), 'm:', 'LineWidth', 1);
ylims = ylim;
% Add light pink background for peak acceleration period
patch([highlight_start highlight_end highlight_end highlight_start], [ylims(1)-100 ylims(1)-100 ylims(2)+100 ylims(2)+100], [1 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.pitch_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.pitch_body), 'm:', 'LineWidth', 1);
ylim([ylims(1), ylims(2)]); % Restore original y-limits
hold off;
grid on;
title('Pitch Angle', 'FontSize', titleSize);
xlabel('Time (s)', 'FontSize', labelSize);
ylabel('Pitch (deg)', 'FontSize', labelSize);
legend('Actual', 'Desired', 'FontSize', legendSize, 'Location', 'northwest');

% Yaw
subplot(2,3,6);
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.yaw_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.yaw_body), 'm:', 'LineWidth', 1);
ylims = ylim;
% Add light pink background for peak acceleration period
patch([highlight_start highlight_end highlight_end highlight_start], [ylims(1)-100 ylims(1)-100 ylims(2)+100 ylims(2)+100], [1 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
hold on;
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.yaw_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.yaw_body), 'm:', 'LineWidth', 1);
ylim([ylims(1), ylims(2)]); % Restore original y-limits
hold off;
grid on;
title('Yaw Angle', 'FontSize', titleSize);
xlabel('Time (s)', 'FontSize', labelSize);
ylabel('Yaw (deg)', 'FontSize', labelSize);
legend('Actual', 'Desired', 'FontSize', legendSize, 'Location', 'northwest');

% Save the combined plot
saveas(gcf, fullfile(plotFolder, 'combined_position_attitude.png'));
