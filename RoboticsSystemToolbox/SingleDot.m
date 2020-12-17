
% 原点を作成
Global_Origin = rigidBodyTree('DataFormat','row'); % 変数の情報を横に並べるという設定付き
Global_Origin.Gravity = [0, -9.81, 0];

% 原点に蝶番関節をもつ質量の無い棒1を作成
Stick1_without_mass = rigidBody('Stick1');
joint_GO_S1O = rigidBodyJoint('joint_Global_Origin_Stick1_Origin', 'revolute'); % revolute が蝶番という意味, 第1引数は名前
joint_GO_S1O.JointAxis = [0,0,1]; % 蝶番軸の設定
joint_GO_S1O.HomePosition = 1/4*pi; % 座標軸の回転, 蝶番軸に対して回転させる, JointAxis = [0,0,1] で HomePosition = 1/4*pi だと x軸正から y軸正方向に45°回転した座標系になる
Vec_From_GO_To_S1O = trvec2tform([0, 0 ,0]); % 原点から蝶番への位置ベクトルを入力する, 一致するなら [0,0,0]
setFixedTransform(joint_GO_S1O, Vec_From_GO_To_S1O); % joint_GO_S1O にその位置ベクトルを設定する
Stick1_without_mass.Mass = 0; % 質量 0
Stick1_without_mass.Inertia = [0,0,0,0,0,0]; % 慣性テンソルすべて0
Stick1_without_mass.CenterOfMass = [0, 0, 0]; % 重心の位置, どこでも構わないが、蝶番と一致させておく
Stick1_without_mass.Joint = joint_GO_S1O; % 棒1 にJointを設定する

% 棒1の先に接続する質点1の作成
MassPoint1_No_Inertia = rigidBody('MassPoint1');
joint_S1O_MP1O = rigidBodyJoint('joint_Stick1_Origin_MassPoint1_Origin', 'fixed');
Vec_From_S1O_To_MP1O = trvec2tform([1, 0 ,0]);
setFixedTransform(joint_S1O_MP1O, Vec_From_S1O_To_MP1O);
MassPoint1_No_Inertia.Mass = 1;
MassPoint1_No_Inertia.Inertia = [0,0,0,0,0,0];
MassPoint1_No_Inertia.CenterOfMass = [0, 0, 0];
MassPoint1_No_Inertia.Joint = joint_S1O_MP1O;

addBody(Global_Origin, Stick1_without_mass, Global_Origin.BaseName) % 棒1を原点につなげる
addBody(Global_Origin, MassPoint1_No_Inertia, 'Stick1') % 質点1を棒1につなげる

wrench = [0, 0, 0, 0, 0, 0]; % 質点1に作用させる(正確には質点1のローカル座標原点, 方向もローカル座標系で表される)に作用させる力ベクトル [Tx Ty Tz Fx Fy Fz]

q = homeConfiguration(Global_Origin); % ホームポジションの獲得, joint_GO_S1O.HomePosition = 1/4*pi; のおかげで 1/4*pi 出力される, 他にも変数がった場合 [変数1, 変数2. ...] と列ベクトルで出力される
fext = externalForce(Global_Origin, 'MassPoint1', wrench, q); % qの表す状態で, 質点1に作用させるという宣言

G_Position = centerOfMass(Global_Origin, q) % 重心の獲得
figure(1)
show(Global_Origin); % 絶対座標系、ローカル座標系をそれぞれプロットしてくれる
view(2)
hold on
plot3(G_Position(1), G_Position(2), G_Position(3), 'or') % 重心のプロット
hold off
qddot = forwardDynamics(Global_Origin, q, [], [], fext) % figure(1)に表示されている状態での 加速度

% 色々な角度での加速度を出してみる
q_Range = 0:1e-2:2*pi;
qddot = NaN(size(q_Range));
for ii = 1:size(q_Range,2)
    fext = externalForce(Global_Origin, 'MassPoint1', wrench, q);
    qddot(ii) = forwardDynamics(Global_Origin, q_Range(ii), [], [], fext);
end
figure(2)
plot(q_Range, qddot) % cosカーブになる

% y方向に重力分だけ力を発揮してみる
qddot = NaN(size(q_Range));
for ii = 1:size(q_Range,2)
    % 絶対座標で表してもだめ
%     wrench = [0, 0, 0, 0, 9.81, 0];

    % base から MassPoint1 への同次変換, 先の3成分が変換される
    wrench_F = getTransform(Global_Origin, q_Range(ii), 'base', 'MassPoint1') * ([0, 9.81, 0, 1])';
    wrench = [0;0;0; wrench_F(1:3)];
    
    % ローカル座標系で表す
%     wrench = [0, 0, 0, 9.81 * MassPoint1_No_Inertia.Mass * sin(q_Range(ii)), 9.81 * MassPoint1_No_Inertia.Mass * cos(q_Range(ii)), 0];
    fext = externalForce(Global_Origin, 'MassPoint1', wrench, q);
    qddot(ii) = forwardDynamics(Global_Origin, q_Range(ii), [], [], fext);
end
figure(3)
plot(q_Range, qddot) % ほぼ0












































