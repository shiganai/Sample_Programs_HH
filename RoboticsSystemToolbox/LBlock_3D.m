
clear all

d_rad_tmp = 0;
% d_rad_tmp = 5e-2;

% 原点を作成
All_Bodies = rigidBodyTree('DataFormat','row'); % 変数の情報を横に並べるという設定付き
All_Bodies.BaseName = 'Global_Origin';
All_Bodies.Gravity = [0, 0, -9.81];

% 原点に蝶番関節を持つ点1を作成
Point1_revolute = rigidBody('Point1');
joint_GO_P1O = rigidBodyJoint('joint_Global_Origin_Point1_Origin', 'revolute');
joint_GO_P1O.JointAxis = [1,0,0];
joint_GO_P1O.HomePosition = d_rad_tmp;
joint_GO_P1O.HomePosition = 1/3*pi;
Vec_From_GO_To_P1O = trvec2tform([0,0,0]);
setFixedTransform(joint_GO_P1O, Vec_From_GO_To_P1O);
Point1_revolute.Mass = 0;
Point1_revolute.Inertia = [0,0,0,0,0,0];
Point1_revolute.CenterOfMass = [0,0,0];
Point1_revolute.Joint = joint_GO_P1O;

% 点1に蝶番関節を持つ点2を作成
Point2_revolute = rigidBody('Point2');
joint_P1O_P2O = rigidBodyJoint('joint_Point1_Origin_Point2_Origin', 'revolute');
joint_P1O_P2O.JointAxis = [0,1,0];
joint_P1O_P2O.HomePosition = d_rad_tmp;
% joint_P1O_P2O.HomePosition = 1/3*pi;
Vec_From_P1O_To_P2O = trvec2tform([0,0,0]);
setFixedTransform(joint_P1O_P2O, Vec_From_P1O_To_P2O);
Point2_revolute.Mass = 0;
Point2_revolute.Inertia = [0,0,0,0,0,0];
Point2_revolute.CenterOfMass = [0,0,0];
Point2_revolute.Joint = joint_P1O_P2O;

% 点2に蝶番関節をもつ点3を作成
Point3_revolute = rigidBody('Point3');
joint_P1O_S1O = rigidBodyJoint('joint_Point2_Origin_Point3_Origin', 'revolute'); % revolute が蝶番という意味, 第1引数は名前
joint_P1O_S1O.JointAxis = [0,0,1]; % 蝶番軸の設定
joint_P1O_S1O.HomePosition = d_rad_tmp;
% joint_P1O_S1O.HomePosition = 1/3*pi;
Vec_From_P1O_To_S1O = trvec2tform([0, 0 ,0]); % 原点から蝶番への位置ベクトルを入力する, 一致するなら [0,0,0], ローカル座標系で表示
setFixedTransform(joint_P1O_S1O, Vec_From_P1O_To_S1O); % joint_GO_S1O にその位置ベクトルを設定する
Point3_revolute.Mass = 0; % 質量 0
Point3_revolute.Inertia = [0,0,0,0,0,0]; % 慣性テンソルすべて0
Point3_revolute.CenterOfMass = [0, 0, 0]; % 重心の位置, どこでも構わないが、蝶番と一致させておく, ローカル座標系で表示
Point3_revolute.Joint = joint_P1O_S1O; % 棒1 にJointを設定する

% 点3の先に接続する質点1の作成
MassPoint1 = rigidBody('MassPoint1');
joint_P3O_MP1O = rigidBodyJoint('joint_Stick1_Origin_MassPoint1_Origin', 'fixed');
Vec_From_P3O_To_MP1O = trvec2tform([0, 0 ,1]);
setFixedTransform(joint_P3O_MP1O, Vec_From_P3O_To_MP1O);
MassPoint1.Mass = 1;
MassPoint1.Inertia = [0,0,0,0,0,0];
MassPoint1.CenterOfMass = [0, 0, 0];
MassPoint1.Joint = joint_P3O_MP1O;

% 質点1の先に接続する質点2の作成
MassPoint2 = rigidBody('MassPoint2');
joint_MP1O_MP2O = rigidBodyJoint('joint_MassPoint1_Origin_MassPoint2_Origin', 'fixed');
Vec_From_MP1O_To_MP2O = trvec2tform([1, 0 , 0]);
setFixedTransform(joint_MP1O_MP2O, Vec_From_MP1O_To_MP2O);
MassPoint2.Mass = 1;
MassPoint2.Inertia = [0,0,0,0,0,0];
MassPoint2.CenterOfMass = [0, 0, 0];
MassPoint2.Joint = joint_MP1O_MP2O;


addBody(All_Bodies, Point1_revolute, 'Global_Origin') % 棒1を原点につなげる
addBody(All_Bodies, Point2_revolute, 'Point1') % 点2を点1につなげる
addBody(All_Bodies, Point3_revolute, 'Point2') % 点3を点2につなげる
addBody(All_Bodies, MassPoint1, 'Point3') % 質点1を点3につなげる
addBody(All_Bodies, MassPoint2, 'MassPoint1') % 質点2を質点1につなげる

wrench = [0, 0, 0, 0, 0, 0]; % 質点1に作用させる(正確には質点1のローカル座標原点, 方向もローカル座標系で表される)に作用させる力ベクトル [Tx Ty Tz Fx Fy Fz]

HomeConfig = homeConfiguration(All_Bodies); % ホームポジションの獲得, joint_GO_S1O.HomePosition = 1/4*pi; のおかげで 1/4*pi 出力される, 他にも変数がった場合 [変数1, 変数2. ...] と列ベクトルで出力される
VariableNum = size(HomeConfig,2);
fext = externalForce(All_Bodies, 'MassPoint1', wrench, HomeConfig); % qの表す状態で, 質点1に作用させるという宣言

G_Position = centerOfMass(All_Bodies, HomeConfig) % 重心の獲得
figure(1)
show(All_Bodies, 'PreservePlot', false); % 絶対座標系、ローカル座標系をそれぞれプロットしてくれる
view(2)
hold on
plot3(G_Position(1), G_Position(2), G_Position(3), 'or') % 重心のプロット
hold off
qddot = forwardDynamics(All_Bodies, HomeConfig, [], [], fext) % figure(1)に表示されている状態での 加速度

% P_MP1_tmp = (getTransform(Global_Origin, HomeConfig, 'MassPoint1', 'base') * ([0, 0, 0, 1])')'
% P_MP2_tmp = (getTransform(Global_Origin, HomeConfig, 'MassPoint2', 'base') * ([0, 0, 0, 1])')'

%{/
% q_input_0_3 = 0;

time = 0:1e-2:10;
q_0 = [HomeConfig, zeros(size(HomeConfig))]';
wrench = [0,0,0,0,0,0]';
ExternalForce_Origin_Name = 'MassPoint2';
ode_fnc = @(t,q) ddt_3D(t,q,All_Bodies, ExternalForce_Origin_Name, wrench);
[time, q] = ode45(ode_fnc, time, q_0);

figure(2)
plot(time, q(:,1:VariableNum))

% Anime_Fig_Show = AnimeAndData_Show(time, Global_Origin, q(:,1:VariableNum));

MP1_x = NaN(size(time));
MP1_y = NaN(size(time));
MP1_z = NaN(size(time));

MP2_x = NaN(size(time));
MP2_y = NaN(size(time));
MP2_z = NaN(size(time));

for ii = 1:size(time,1)
    P_MP1_tmp = getTransform(All_Bodies, q(ii,1:VariableNum), 'MassPoint1', 'Global_Origin') * ([0, 0, 0, 1])';
    MP1_x(ii) = P_MP1_tmp(1);
    MP1_y(ii) = P_MP1_tmp(2);
    MP1_z(ii) = P_MP1_tmp(3);
    
    P_MP2_tmp = getTransform(All_Bodies, q(ii,1:VariableNum), 'MassPoint2', 'Global_Origin') * ([0, 0, 0, 1])';
    MP2_x(ii) = P_MP2_tmp(1);
    MP2_y(ii) = P_MP2_tmp(2);
    MP2_z(ii) = P_MP2_tmp(3);
end

xArray = [zeros(size(time)), MP1_x, MP2_x];
yArray = [zeros(size(time)), MP1_y, MP2_y];
zArray = [zeros(size(time)), MP1_z, MP2_z];

Anime_Fig = AnimeAndData(time, xArray, yArray, zArray);
xlim(Anime_Fig.axAnime, [-2, 2])
ylim(Anime_Fig.axAnime, [-2, 2])
zlim(Anime_Fig.axAnime, [-2, 2])
grid(Anime_Fig.axAnime, 'on')
%}

%{
figure(3)
for ii = 1:size(time)
    show(Global_Origin, q(ii, 1:VariableNum), 'PreservePlot', true)
    pause(0.2)
end
%}












































