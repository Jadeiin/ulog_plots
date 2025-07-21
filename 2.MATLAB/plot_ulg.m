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

% X轴位置
figure(1);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((local_position.timestamp-t0)*1e-6, local_position.x, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.x, 'r--', 'LineWidth', 1);
grid on;
%title('X轴位置', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('X轴位置 (m)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'x_position.png'));

% Y轴位置
figure(2);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((local_position.timestamp-t0)*1e-6, local_position.y, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.y, 'r--', 'LineWidth', 1);
grid on;
%title('Y轴位置', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('Y轴位置 (m)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'y_position.png'));

% Z轴位置
figure(3);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((local_position.timestamp-t0)*1e-6, local_position.z, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.z, 'r--', 'LineWidth', 1);
grid on;
%title('Z轴位置', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('Z轴位置 (m)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'z_position.png'));

% 滚转角
figure(4);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.roll_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.roll_body), 'r--', 'LineWidth', 1);
grid on;
%title('滚转角', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('滚转角 (deg)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'roll_angle.png'));

% 俯仰角
figure(5);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.pitch_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.pitch_body), 'r--', 'LineWidth', 1);
grid on;
%title('俯仰角', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('俯仰角 (deg)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'pitch_angle.png'));

% 偏航角
figure(6);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((attitude.timestamp-t0)*1e-6, rad2deg(attitude.yaw_body), 'b-', ...
    (attitude_setpoint.timestamp-t0)*1e-6, rad2deg(attitude_setpoint.yaw_body), 'r--', 'LineWidth', 1);
grid on;
%title('偏航角', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('偏航角 (deg)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'yaw_angle.png'));

% X轴角速度
figure(7);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((angular_velocity.timestamp-t0)*1e-6, rad2deg(angular_velocity.xyz_0), 'b-', ...
    (rates_setpoint.timestamp-t0)*1e-6, rad2deg(rates_setpoint.roll), 'r--', 'LineWidth', 1);
grid on;
%title('滚转角速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('滚转角速度 (deg/s)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'roll_rate.png'));

% Y轴角速度
figure(8);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((angular_velocity.timestamp-t0)*1e-6, rad2deg(angular_velocity.xyz_1), 'b-', ...
    (rates_setpoint.timestamp-t0)*1e-6, rad2deg(rates_setpoint.pitch), 'r--', 'LineWidth', 1);
grid on;
%title('俯仰角速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('俯仰角速度 (deg/s)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'pitch_rate.png'));

% Z轴角速度
figure(9);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((angular_velocity.timestamp-t0)*1e-6, rad2deg(angular_velocity.xyz_2), 'b-', ...
    (rates_setpoint.timestamp-t0)*1e-6, rad2deg(rates_setpoint.yaw), 'r--', 'LineWidth', 1);
grid on;
%title('偏航角速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('偏航角速度 (deg/s)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'yaw_rate.png'));

% % RC输入
% figure(10);
% set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
% plot(rc_channels.timestamp*1e-6, rc_channels.data, 'LineWidth', 1);
% grid on;
% %title('遥控器输入', 'FontSize', titleSize);
% xlabel('时间 (s)', 'FontSize', labelSize);
% ylabel('遥控器值', 'FontSize', labelSize);
% legend('滚转', '俯仰', '油门', '偏航', 'FontSize', legendSize);
% saveas(gcf, fullfile(plotFolder, 'rc_input.png'));

% PWM输出
figure(11);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((actuator_outputs.timestamp-t0)*1e-6, actuator_outputs.output_0, 'b-', ...
    (actuator_outputs.timestamp-t0)*1e-6, actuator_outputs.output_1, 'r--', ...
    (actuator_outputs.timestamp-t0)*1e-6, actuator_outputs.output_2, 'g--', ...
    (actuator_outputs.timestamp-t0)*1e-6, actuator_outputs.output_3, 'm--', 'LineWidth', 1);
grid on;
%title('电机PWM输出', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('PWM值', 'FontSize', labelSize);
legend('电机1', '电机2', '电机3', '电机4', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'pwm_output.png'));

% X轴速度
figure(13);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((local_position.timestamp-t0)*1e-6, local_position.vx, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.vx, 'r--', 'LineWidth', 1);
grid on;
%title('X轴速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('X轴速度 (m/s)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'x_velocity.png'));

% Y轴速度
figure(14);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((local_position.timestamp-t0)*1e-6, local_position.vy, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.vy, 'r--', 'LineWidth', 1);
grid on;
%title('Y轴速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('Y轴速度 (m/s)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'y_velocity.png'));

% Z轴速度
figure(15);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((local_position.timestamp-t0)*1e-6, local_position.vz, 'b-', ...
    (local_position_setpoint.timestamp-t0)*1e-6, local_position_setpoint.vz, 'r--', 'LineWidth', 1);
grid on;
%title('Z轴速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('Z轴速度 (m/s)', 'FontSize', labelSize);
legend('实际值', '期望值', 'FontSize', legendSize);
saveas(gcf, fullfile(plotFolder, 'z_velocity.png'));

% X轴加速度
figure(16);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((acceleration.timestamp-t0)*1e-6, acceleration.xyz_0, 'b-', 'LineWidth', 1);
grid on;
%title('X轴加速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('X轴加速度 (m/s²)', 'FontSize', labelSize);
saveas(gcf, fullfile(plotFolder, 'x_acceleration.png'));

% Y轴加速度
figure(17);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((acceleration.timestamp-t0)*1e-6, acceleration.xyz_1, 'b-', 'LineWidth', 1);
grid on;
%title('Y轴加速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('Y轴加速度 (m/s²)', 'FontSize', labelSize);
saveas(gcf, fullfile(plotFolder, 'y_acceleration.png'));

% Z轴加速度
figure(18);
set(gcf, 'Position', [100, 100, figureWidth, figureHeight], 'Color', 'white');
plot((acceleration.timestamp-t0)*1e-6, acceleration.xyz_2, 'b-', 'LineWidth', 1);
grid on;
%title('Z轴加速度', 'FontSize', titleSize);
xlabel('时间 (s)', 'FontSize', labelSize);
ylabel('Z轴加速度 (m/s²)', 'FontSize', labelSize);
saveas(gcf, fullfile(plotFolder, 'z_acceleration.png'));

disp(['所有图表已保存至文件夹: ', plotFolder]);
