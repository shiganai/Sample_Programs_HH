
time = (0:1e-2:10)';

theta_1 = [time * 1/10 * 2*pi, time * 1/5 * 2*pi - 2*pi, time * 1/7 * 2*pi];

theta_2 = [time * 1/10 * 2*pi, time * 1/5 * 2*pi - 2*pi, time * 1/5 * 2*pi];
% theta_2 =  2*pi - time * 1/10 * 2*pi;

% theta_3 = time * 1/5 * 2*pi;
% theta_4 =  2*pi - time * 1/10 * 2*pi;

% スティックピクチャを載せる横軸の値の初期化
% cell配列だと，配列の形が制御しやすい（遅いので注意）
Stick_Pics_X = cell(1,1);

Stick_Pics_X{1} = [
%     0
%     10
    ];
Stick_Pics_X{2} = [
%     0
%     10
    ];
Stick_Pics_X{3} = [
    5
    ];


% 載せるスティックピクチャのx座標の初期化
Stick_Pics_Data_X = cell(size(Stick_Pics_X));

% 載せるスティックピクチャのy座標の初期化
Stick_Pics_Data_Y = cell(size(Stick_Pics_X));

for Stick_Pics_X_Index = 1:size(Stick_Pics_X, 2)
    
    Stick_Pics_X_tmp = Stick_Pics_X{Stick_Pics_X_Index}; % 縦ベクトル
    
    theta_1_tmp = interp1q(time, theta_1(:,Stick_Pics_X_Index), Stick_Pics_X_tmp); % 縦ベクトル
    theta_2_tmp = interp1q(time, theta_2(:,Stick_Pics_X_Index), Stick_Pics_X_tmp);
    
    % 後で使うplotの性質上，横に時間，縦につなぐ点，という風に並んでいてほしい
    Stick_Pics_Data_X_tmp = [zeros(size(theta_1_tmp)), cos(theta_1_tmp), cos(theta_1_tmp) + cos(theta_2_tmp)]';
    Stick_Pics_Data_Y_tmp = [zeros(size(theta_1_tmp)), sin(theta_1_tmp), sin(theta_1_tmp) + sin(theta_2_tmp)]';
    
    % cell配列に格納
    Stick_Pics_Data_X{Stick_Pics_X_Index} = Stick_Pics_Data_X_tmp;
    Stick_Pics_Data_Y{Stick_Pics_X_Index} = Stick_Pics_Data_Y_tmp;
end

% 主データの横軸のどれくらいの幅に一つのスティックピクチャを入れるのか，スティックピクチャの大きさを制御
XTick_For_One_Stick_Pics = 1;

% 1つのスティックピクチャの横の幅
Stick_Pics_Width = 4;

% 二つ以上の種類のスティックピクチャを載せる場合の，上下の幅
Stick_Pics_Height = 4;

% スティックピクチャの説明
% Stick_Pics_Legend_Labels = {'Pendulum1'};
Stick_Pics_Legend_Labels = {'Pendulum1'
    'Pendulum2'
    'Pendulum3'};

XLabel_Str = '時間';
YLabel_Str = {
    '\theta_1'
    '\theta_2'
    };
Title_Str = '角度[rad]';
Legend_Labels = {
    '場合1'
    '場合2'
    '場合3'
    };
XAxisLocation = 'origin';
% XAxisLocation = 'bottom';

X = time;
Y = {
    theta_1
    theta_2
    };

figure(1)

% [ax_Subplot, ax_Stick, ax_BackGround] で各座標系へのハンドルを取得
[ax_Subplot, ax_Stick, ax_BackGround] = Subplot_With_Stick_Pics(X, Y, XLabel_Str, YLabel_Str, Title_Str, Legend_Labels, XAxisLocation, ...
    Stick_Pics_X, Stick_Pics_Data_X, Stick_Pics_Data_Y, Stick_Pics_Legend_Labels, XTick_For_One_Stick_Pics, Stick_Pics_Width, Stick_Pics_Height);









































