function [ax_Subplot, ax_Stick, ax_BackGround] = Subplot_With_Stick_Pics(X, Y, XLabel_Str, YLabel_Str, Title_Str, Legend_Labels, XAxisLocation, ...
    Stick_Pics_X, Stick_Pics_Data_X, Stick_Pics_Data_Y, Stick_Pics_Legend_Labels, XTick_For_One_Stick_Pics, Stick_Pics_Width, Stick_Pics_Height)
%CALL_FIGURE_NEW ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

clf('reset')

Subplot_Num = size(Y, 1);
ax_Subplot = matlab.graphics.axis.Axes.empty(Subplot_Num,0);

for Subplot_Index = 1:Subplot_Num
    ax_Subplot(Subplot_Index, 1) = subplot(Subplot_Num,1,Subplot_Index);
    
    ax_Subplot_tmp = gca;
    Y_tmp = Y{Subplot_Index};
    YLabel_Str_tmp = YLabel_Str{Subplot_Index};
    
    for Legend_Labels_Index = 1:size(Legend_Labels, 1)
        hold on
        plot(X, Y_tmp(:, Legend_Labels_Index))
        hold off
    end
    
    ylabel(YLabel_Str_tmp)
    ax_Subplot_tmp.Box = 'off';
    ax_Subplot_tmp.XTickLabel = [];
    ax_Subplot_tmp.Color = 'none';
    
    ax_Subplot_tmp.XAxisLocation = XAxisLocation;

end

ax_Subplot_Top = ax_Subplot(1, 1);

ax_Stick = axes('Position', ax_Subplot_Top.Position);

% ������f�[�^�̉����̈�ԍ��ƈ�ԉE�ɃX�e�B�b�N�s�N�`�����ڂ���Ƃ�����C�ǂ̂��炢��x���̕��ɂȂ�̂����v�Z
% �Ⴆ�� diff(ax_Subplot_Top.XLim) = 2 �̎���
% XTick_For_One_Stick_Pics = 1 ���Ƃ��傤��2���̃X�e�B�b�N�s�N�`�������ԂȂ����ׂ�ƒ[����[�܂ł̑傫���ɂȂ�C���̂悤�ɃX�e�B�b�N�s�N�`���̑傫�������߂�
% ���̂����� Stick_Pics_Width = 1 ����1���̃X�e�B�b�N�s�N�`���Ɋւ��Ē��S����[�܂ł̋����� 1 �ɂȂ�
% XTick_For_One_Stick_Pics = Stick_Pics_Width �̎��� Stick_Pics_X = [0,1,2] ���ƌ��ԂȂ����ԁCStick_Pics_X = [0,0.5,1] ���Ɣ������d�Ȃ���, 0.5�̃X�e�B�b�N�s�N�`����0��1�ɕ����Ă��܂�
ax_Stick_XLim_Range = diff(ax_Subplot_Top.XLim) / XTick_For_One_Stick_Pics * Stick_Pics_Width;

% �X�e�B�b�N�s�N�`���̒��S�����[�̋���
Stick_Pics_Height_Base_Top = Stick_Pics_Height / 2;

% �X�e�B�b�N�s�N�`���̒��S���牺�[�̋���
Stick_Pics_Height_Base_Bottom = Stick_Pics_Height / 2;

Stick_Pics_X_All = [];
for Stick_Pics_Legend_Index = 1:size(Stick_Pics_Legend_Labels(:), 1)
    
    % cell ���� double �̔z��Ɏ��o��
    Stick_Pics_X_tmp = Stick_Pics_X{Stick_Pics_Legend_Index};
    Stick_Pics_Data_X_tmp = Stick_Pics_Data_X{Stick_Pics_Legend_Index};
    Stick_Pics_Data_Y_tmp = Stick_Pics_Data_Y{Stick_Pics_Legend_Index};
    
    Stick_Pics_X_All = [Stick_Pics_X_All; Stick_Pics_X_tmp];
    
    % ���S��y���W
    Origin_Y = -Stick_Pics_Height_Base_Top - Stick_Pics_Height * (Stick_Pics_Legend_Index - 1);
    
    % ���S��x���W
    Origin_X = 0 + ax_Stick_XLim_Range * (Stick_Pics_X_tmp - ax_Subplot_Top.XLim(1)) / diff(ax_Subplot_Top.XLim);
    
    Joint_X = Stick_Pics_Data_X_tmp + Origin_X';
    Joint_Y = Stick_Pics_Data_Y_tmp + Origin_Y;
    
    hold on
    plot(Joint_X, Joint_Y, 'k')
    hold off
end

% �ǂ̕����ɃX�e�B�b�N�s�N�`����u�������L�^�C���Grid��ǉ�����
Stick_Pics_X_All = sort(unique(Stick_Pics_X_All));

% �X�e�B�b�N�s�N�`���̉��ɖ}��̒ǉ�
Stick_Pics_Legend_Index = 1:size(Stick_Pics_Legend_Labels(:), 1);
Text_X(Stick_Pics_Legend_Index) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Subplot_Top.XLim(1)) / diff(ax_Subplot_Top.XLim) - Stick_Pics_Width/2;
Text_Y = -Stick_Pics_Height_Base_Top - Stick_Pics_Height * (Stick_Pics_Legend_Index - 1);
text(Text_X, Text_Y, Stick_Pics_Legend_Labels, 'HorizontalAlignment', 'right')

% ��ԍ��[�̃X�e�B�b�N�s�N�`���̍��[���M���M������悤�ɃX�e�B�b�N�s�N�`���p�̍��W��x���̉��[��ݒ�
ax_Stick.XLim(1) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Subplot_Top.XLim(1)) / (ax_Subplot_Top.XLim(2) - ax_Subplot_Top.XLim(1)) - Stick_Pics_Width/2;

% ��ԉE�[�̃X�e�B�b�N�s�N�`���̉E�[���M���M������悤�ɃX�e�B�b�N�s�N�`���p�̍��W��x���̏�[��ݒ�
ax_Stick.XLim(2) = ax_Stick_XLim_Range * (Stick_Pics_X_All(end) - ax_Subplot_Top.XLim(1)) / (ax_Subplot_Top.XLim(2) - ax_Subplot_Top.XLim(1)) + Stick_Pics_Width/2;

% ��ԏ�̃X�e�B�b�N�s�N�`���̏�[�ƈ�ԉ��̃X�e�B�b�N�s�N�`���̉��[������p�ɐݒ�, �������M���M���ł͂Ȃ�
ax_Stick.YLim = [- Stick_Pics_Height_Base_Top - Stick_Pics_Height * (size(Stick_Pics_Legend_Labels(:), 1) - 1) - Stick_Pics_Height_Base_Bottom, 0];

% ���̐F������
ax_Stick.XColor = 'none';
ax_Stick.YColor = 'none';

% ������
ax_Stick.Color = 'none';

% Subplot�����̉����𒲐�����
% ��ԉE�[�̃X�e�B�b�N�s�N�`���̉E�[����f�[�^�̉����̏�[���傫�������ꍇ�C��f�[�^�̉����������k������
if ax_Stick.XLim(2) / ax_Stick_XLim_Range > 1
    for Subplot_Index = 1:Subplot_Num
        ax_Subplot(Subplot_Index, 1).Position(3) = (1 - ax_Subplot_Top.Position(1)) / (ax_Stick.XLim(2) / ax_Stick_XLim_Range);
    end
else
    
end

% x���Cy���̃f�[�^�𓯂������ŕ\������D�Ⴆ�Ή~�������Ɖ~�Ƃ��ĕ\�������悤�ɂȂ�
% �����ŕ\������Ă��� y���̑傫���Ǝ��� Position �v���p�e�B����v���Ȃ��Ȃ�
daspect([1, 1, 1])

% �X�e�B�b�N�s�N�`���̈ʒu�Ǝ�f�[�^�̉����̈ʒu�������悤�� Position �𒲐�
ax_Stick.Position(1) = ax_Subplot_Top.Position(1) + ax_Subplot_Top.Position(3) * ax_Stick.XLim(1) / ax_Stick_XLim_Range;
ax_Stick.Position(3) = ax_Subplot_Top.Position(3) * diff(ax_Stick.XLim) / ax_Stick_XLim_Range;

% Grid ���ڂ��邽�߂̑S�̂̔w�i���W��ݒ�
ax_BackGround = axes;

% ���̍��W�������őO�ʂ�
for Subplot_Index = 1:Subplot_Num
    axes(ax_Subplot(Subplot_Index, 1))
end
axes(ax_Stick)

% ������
ax_BackGround.YColor = 'none';

% �����킹
xlim(ax_BackGround, ax_Subplot(end, 1).XLim)

% �^�C�g���Cxlabel�}��
title(ax_BackGround, Title_Str);
xlabel(ax_BackGround, XLabel_Str);

% �O���b�h���̒ǉ�
alpha_Value = 0.2;
for Stick_Pics_X_All_Index = 1:size(Stick_Pics_X_All,1)
    patch(ax_BackGround, [Stick_Pics_X_All(Stick_Pics_X_All_Index), Stick_Pics_X_All(Stick_Pics_X_All_Index), NaN], ...
        [ax_BackGround.YLim, NaN], 'k', 'EdgeColor', 'k', ...
        'FaceVertexAlphaData', [alpha_Value; alpha_Value; alpha_Value],'AlphaDataMapping','none', 'EdgeAlpha','interp')
end

% �����킹
ax_BackGround.Position([1,3]) = [ax_Subplot(end, 1).Position(1), ax_Subplot(end, 1).Position(3)];


% �c���킹
ax_BackGround.OuterPosition(2) = 0;

% ���x���p�̗]�������c���č��W�n��Position��ݒ�
ax_BackGround.Position(2) = ax_BackGround.OuterPosition(2) + ax_BackGround.TightInset(2);

% �c�S�������悤�ɂ���
ax_BackGround.OuterPosition(4) = 1 - ax_BackGround.OuterPosition(2);

% ���x���p�̗]�������c���č��W�n��Position��ݒ�
ax_BackGround.Position(4) = ax_BackGround.OuterPosition(2) + ax_BackGround.OuterPosition(4) - ax_BackGround.TightInset(4) - ax_BackGround.Position(2);

% �X�e�B�b�N�s�N�`���p�̍��W�̕��ƈʒu������C�w�i�̍��W�n�̏�[�ɒ���t���悤�ɂ���
fig_tmp = gcf;
ax_Stick.Position(4) = ax_Stick.Position(3) * diff(ax_Stick.YLim) / diff(ax_Stick.XLim) * fig_tmp.Position(3) / fig_tmp.Position(4);
ax_Stick.Position(2) = ax_BackGround.Position(2) + ax_BackGround.Position(4) - ax_Stick.Position(4);

% Subplot�̍��W�n�̑�g�̍������v�Z
ax_Subplot_OuterPosition_4 = (ax_Stick.Position(2) - ax_BackGround.Position(2))/Subplot_Num;

% ���ʒu��ݒ肵�Ă����D��g���ڂ���悤�ɂ���D���W�n��ڂ�����ƁC�ڐ��肪�d�Ȃ��Ă��܂����肷��
for Subplot_Index = 1:Subplot_Num
    ax_Subplot(Subplot_Index, 1).OuterPosition(4) = ax_Subplot_OuterPosition_4;
    ax_Subplot(Subplot_Index, 1).OuterPosition(2) = ax_Stick.Position(2) - ax_Subplot_OuterPosition_4 * Subplot_Index;
    legend(ax_Subplot(Subplot_Index, 1), Legend_Labels, 'Location', 'best')
end

% x�����e���W�̈�ԉ��ɒu���ꍇ�CSubplot�̈�ԉ���x���͔w�i��x���œh��ւ���
if isequal(XAxisLocation, 'bottom')
    ax_Subplot(end,1).XColor = 'none';
    ax_BackGround.Position(4) = ax_BackGround.Position(4) - (ax_Subplot(end,1).Position(2) - ax_BackGround.Position(2));
    ax_BackGround.Position(2) = ax_Subplot(end,1).Position(2);
end

end

















































