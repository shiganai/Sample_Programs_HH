

clear all

% 原点を作成
All_Bodies = rigidBodyTree('DataFormat','row'); % 変数の情報を横に並べるという設定付き
All_Bodies.BaseName = 'Global_Origin';
All_Bodies.Gravity = [0, 0, -9.81];

% 原点に蝶番関節を持つ点を作成
Point1_revolute = rigidBody('Point1');
joint_GO_P1O = rigidBodyJoint('joint_Global_Origin_Point1_Origin', 'revolute');
joint_GO_P1O.JointAxis = [0,0,1];
joint_GO_P1O.HomePosition = 0;
% joint_GO_P1O.HomePosition = 1/3*pi;
Vec_From_GO_To_P1O = trvec2tform([0,0,0]);
setFixedTransform(joint_GO_P1O, Vec_From_GO_To_P1O);
Point1_revolute.Mass = 0;
Point1_revolute.Inertia = [0,0,0,0,0,0];
Point1_revolute.CenterOfMass = [0,0,0];
Point1_revolute.Joint = joint_GO_P1O;

% 原点に蝶番関節をもつ質量の無い棒1を作成
Stick1_without_mass = rigidBody('Stick1');
joint_P1O_S1O = rigidBodyJoint('joint_Point1_Origin_Stick1_Origin', 'revolute'); % revolute が蝶番という意味, 第1引数は名前
joint_P1O_S1O.JointAxis = [0,1,0]; % 蝶番軸の設定
% joint_P1O_S1O.HomePosition = 1e-1;
joint_P1O_S1O.HomePosition = 1/3*pi;
Vec_From_P1O_To_S1O = trvec2tform([0, 0 ,0]); % 原点から蝶番への位置ベクトルを入力する, 一致するなら [0,0,0], ローカル座標系で表示
setFixedTransform(joint_P1O_S1O, Vec_From_P1O_To_S1O); % joint_GO_S1O にその位置ベクトルを設定する
Stick1_without_mass.Mass = 0; % 質量 0
Stick1_without_mass.Inertia = [0,0,0,0,0,0]; % 慣性テンソルすべて0
Stick1_without_mass.CenterOfMass = [0, 0, 0]; % 重心の位置, どこでも構わないが、蝶番と一致させておく, ローカル座標系で表示
Stick1_without_mass.Joint = joint_P1O_S1O; % 棒1 にJointを設定する

% 棒1の先に接続する質点1の作成
MassPoint1_No_Inertia = rigidBody('MassPoint1');
joint_S1O_MP1O = rigidBodyJoint('joint_Stick1_Origin_MassPoint1_Origin', 'fixed');
Vec_From_S1O_To_MP1O = trvec2tform([1, 0 ,0]);
setFixedTransform(joint_S1O_MP1O, Vec_From_S1O_To_MP1O);
MassPoint1_No_Inertia.Mass = 1;
MassPoint1_No_Inertia.Inertia = [0,0,0,0,0,0];
MassPoint1_No_Inertia.CenterOfMass = [0, 0, 0];
MassPoint1_No_Inertia.Joint = joint_S1O_MP1O;

addBody(All_Bodies, Point1_revolute, 'Global_Origin') % 棒1を原点につなげる
addBody(All_Bodies, Stick1_without_mass, 'Point1') % 棒1を原点につなげる
addBody(All_Bodies, MassPoint1_No_Inertia, 'Stick1') % 質点1を棒1につなげる

wrench = [0, 0, 0, 0, 0, 0]; % 質点1に作用させる(正確には質点1のローカル座標原点, 方向もローカル座標系で表される)に作用させる力ベクトル [Tx Ty Tz Fx Fy Fz]

q = homeConfiguration(All_Bodies); % ホームポジションの獲得, joint_GO_S1O.HomePosition = 1/4*pi; のおかげで 1/4*pi 出力される, 他にも変数がった場合 [変数1, 変数2. ...] と列ベクトルで出力される
% q = [0,0];
fext = externalForce(All_Bodies, 'MassPoint1', wrench, q); % qの表す状態で, 質点1に作用させるという宣言

G_Position = centerOfMass(All_Bodies, q) % 重心の獲得
figure(1)
show(All_Bodies); % 絶対座標系、ローカル座標系をそれぞれプロットしてくれる
view(2)
hold on
plot3(G_Position(1), G_Position(2), G_Position(3), 'or') % 重心のプロット
hold off
qddot = forwardDynamics(All_Bodies, q, [], [], fext) % figure(1)に表示されている状態での 加速度

%{/
q_input_0_3 = sqrt(9.81 / 1 / cos(1/6*pi));

time = 0:1e-2:10;
q_input_0 = [q, q_input_0_3,0]';
wrench = [0,0,0,0,0,0]';
ExternalForce_Origin_Name = 'MassPoint1';
ode_fnc = @(t,q) ddt_3D(t,q,All_Bodies, ExternalForce_Origin_Name, wrench);

[time, q_input] = ode45(ode_fnc, time, q_input_0);

figure(2)
plot(time, q_input(:,1:2))

MP1_x = NaN(size(time));
MP1_y = NaN(size(time));
MP1_z = NaN(size(time));

for ii = 1:size(time,1)
    P_MP1_tmp = getTransform(All_Bodies, q_input(ii,1:2), 'MassPoint1', 'Global_Origin') * ([0, 0, 0, 1])';
    MP1_x(ii) = P_MP1_tmp(1);
    MP1_y(ii) = P_MP1_tmp(2);
    MP1_z(ii) = P_MP1_tmp(3);
end

xArray = [zeros(size(time)), MP1_x];
yArray = [zeros(size(time)), MP1_y];
zArray = [zeros(size(time)), MP1_z];

Anime_Fig = AnimeAndData(time, xArray, yArray, zArray);
xlim(Anime_Fig.axAnime, [-1, 1])
ylim(Anime_Fig.axAnime, [-1, 1])
zlim(Anime_Fig.axAnime, [-1, 1])
grid(Anime_Fig.axAnime, 'on')
%}

% figure(3)
% for ii = 1:size(time)
%     G_Position = centerOfMass(Global_Origin, q_input(ii,1:2));
%     plot3([0, G_Position(1)], [0, G_Position(2)], [0, G_Position(3)], 'or') % 重心のプロット
%     drawnow
%     xlim([-1. 1])
%     ylim([-1. 1])
%     zlim([-1. 1])
%     
%     pause(0.2)
% end












































