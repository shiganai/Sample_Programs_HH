
clear all

d_rad_tmp = 0;
% d_rad_tmp = 5e-2;

% ���_���쐬
All_Bodies = rigidBodyTree('DataFormat','row'); % �ϐ��̏������ɕ��ׂ�Ƃ����ݒ�t��
All_Bodies.BaseName = 'Global_Origin';
All_Bodies.Gravity = [0, 0, -9.81];

% ���_�ɒ��Ԋ֐߂����_1���쐬
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

% �_1�ɒ��Ԋ֐߂����_2���쐬
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

% �_2�ɒ��Ԋ֐߂����_3���쐬
Point3_revolute = rigidBody('Point3');
joint_P1O_S1O = rigidBodyJoint('joint_Point2_Origin_Point3_Origin', 'revolute'); % revolute �����ԂƂ����Ӗ�, ��1�����͖��O
joint_P1O_S1O.JointAxis = [0,0,1]; % ���Ԏ��̐ݒ�
joint_P1O_S1O.HomePosition = d_rad_tmp;
% joint_P1O_S1O.HomePosition = 1/3*pi;
Vec_From_P1O_To_S1O = trvec2tform([0, 0 ,0]); % ���_���璱�Ԃւ̈ʒu�x�N�g������͂���, ��v����Ȃ� [0,0,0], ���[�J�����W�n�ŕ\��
setFixedTransform(joint_P1O_S1O, Vec_From_P1O_To_S1O); % joint_GO_S1O �ɂ��̈ʒu�x�N�g����ݒ肷��
Point3_revolute.Mass = 0; % ���� 0
Point3_revolute.Inertia = [0,0,0,0,0,0]; % �����e���\�����ׂ�0
Point3_revolute.CenterOfMass = [0, 0, 0]; % �d�S�̈ʒu, �ǂ��ł��\��Ȃ����A���Ԃƈ�v�����Ă���, ���[�J�����W�n�ŕ\��
Point3_revolute.Joint = joint_P1O_S1O; % �_1 ��Joint��ݒ肷��

% �_3�̐�ɐڑ����鎿�_1�̍쐬
MassPoint1 = rigidBody('MassPoint1');
joint_P3O_MP1O = rigidBodyJoint('joint_Stick1_Origin_MassPoint1_Origin', 'fixed');
Vec_From_P3O_To_MP1O = trvec2tform([0, 0 ,1]);
setFixedTransform(joint_P3O_MP1O, Vec_From_P3O_To_MP1O);
MassPoint1.Mass = 1;
MassPoint1.Inertia = [0,0,0,0,0,0];
MassPoint1.CenterOfMass = [0, 0, 0];
MassPoint1.Joint = joint_P3O_MP1O;

% ���_1�̐�ɐڑ����鎿�_2�̍쐬
MassPoint2 = rigidBody('MassPoint2');
joint_MP1O_MP2O = rigidBodyJoint('joint_MassPoint1_Origin_MassPoint2_Origin', 'fixed');
Vec_From_MP1O_To_MP2O = trvec2tform([1, 0 , 0]);
setFixedTransform(joint_MP1O_MP2O, Vec_From_MP1O_To_MP2O);
MassPoint2.Mass = 1;
MassPoint2.Inertia = [0,0,0,0,0,0];
MassPoint2.CenterOfMass = [0, 0, 0];
MassPoint2.Joint = joint_MP1O_MP2O;


addBody(All_Bodies, Point1_revolute, 'Global_Origin') % �_1�����_�ɂȂ���
addBody(All_Bodies, Point2_revolute, 'Point1') % �_2��_1�ɂȂ���
addBody(All_Bodies, Point3_revolute, 'Point2') % �_3��_2�ɂȂ���
addBody(All_Bodies, MassPoint1, 'Point3') % ���_1��_3�ɂȂ���
addBody(All_Bodies, MassPoint2, 'MassPoint1') % ���_2�����_1�ɂȂ���

wrench = [0, 0, 0, 0, 0, 0]; % ���_1�ɍ�p������(���m�ɂ͎��_1�̃��[�J�����W���_, ���������[�J�����W�n�ŕ\�����)�ɍ�p������̓x�N�g�� [Tx Ty Tz Fx Fy Fz]

HomeConfig = homeConfiguration(All_Bodies); % �z�[���|�W�V�����̊l��, joint_GO_S1O.HomePosition = 1/4*pi; �̂������� 1/4*pi �o�͂����, ���ɂ��ϐ��������ꍇ [�ϐ�1, �ϐ�2. ...] �Ɨ�x�N�g���ŏo�͂����
VariableNum = size(HomeConfig,2);
fext = externalForce(All_Bodies, 'MassPoint1', wrench, HomeConfig); % q�̕\����Ԃ�, ���_1�ɍ�p������Ƃ����錾

G_Position = centerOfMass(All_Bodies, HomeConfig) % �d�S�̊l��
figure(1)
show(All_Bodies, 'PreservePlot', false); % ��΍��W�n�A���[�J�����W�n�����ꂼ��v���b�g���Ă����
view(2)
hold on
plot3(G_Position(1), G_Position(2), G_Position(3), 'or') % �d�S�̃v���b�g
hold off
qddot = forwardDynamics(All_Bodies, HomeConfig, [], [], fext) % figure(1)�ɕ\������Ă����Ԃł� �����x

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
