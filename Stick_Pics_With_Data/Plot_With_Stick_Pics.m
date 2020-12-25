function Plot_With_Stick_Pics(X, Y, Stick_Pics_X, Stick_Pics_Data_X, Stick_Pics_Data_Y, XTick_For_One_Stick_Pics, Stick_Pics_Width, Stick_Pics_Height, Stick_Pics_Legend_Labels)
%CALL_FIGURE_NEW ���̊֐��̊T�v�������ɋL�q
%   �ڍא����������ɋL�q

% ���܂ł̍��W�n���폜
clf('reset')

plot(X, Y)
title('Sample')

ax_Data = gca;

% ��g�ƉE�g�̍폜
ax_Data.Box = 'off';

ax_Data.YGrid = 'on';
ax_Data.XGrid = 'on';

% �X�e�B�b�N�s�N�`���p�̎����쐬
ax_Stick = axes('Position', ax_Data.Position);

% ������f�[�^�̉����̈�ԍ��ƈ�ԉE�ɃX�e�B�b�N�s�N�`�����ڂ���Ƃ�����C�ǂ̂��炢��x���̕��ɂȂ�̂����v�Z
% �Ⴆ�� diff(ax_Data.XLim) = 2 �̎���
% XTick_For_One_Stick_Pics = 1 ���Ƃ��傤��2���̃X�e�B�b�N�s�N�`�������ԂȂ����ׂ�ƒ[����[�܂ł̑傫���ɂȂ�C���̂悤�ɃX�e�B�b�N�s�N�`���̑傫�������߂�
% ���̂����� Stick_Pics_Width = 1 ����1���̃X�e�B�b�N�s�N�`���Ɋւ��Ē��S����[�܂ł̋����� 1 �ɂȂ�
% XTick_For_One_Stick_Pics = Stick_Pics_Width �̎��� Stick_Pics_X = [0,1,2] ���ƌ��ԂȂ����ԁCStick_Pics_X = [0,0.5,1] ���Ɣ������d�Ȃ���, 0.5�̃X�e�B�b�N�s�N�`����0��1�ɕ����Ă��܂�
ax_Stick_XLim_Range = diff(ax_Data.XLim) / XTick_For_One_Stick_Pics * Stick_Pics_Width;

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
    Origin_X = 0 + ax_Stick_XLim_Range * (Stick_Pics_X_tmp - ax_Data.XLim(1)) / diff(ax_Data.XLim);
    
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
Text_X(Stick_Pics_Legend_Index) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Data.XLim(1)) / diff(ax_Data.XLim) - Stick_Pics_Width/2;
Text_Y = -Stick_Pics_Height_Base_Top - Stick_Pics_Height * (Stick_Pics_Legend_Index - 1);
text(Text_X, Text_Y, Stick_Pics_Legend_Labels, 'HorizontalAlignment', 'right')

% �X�e�B�b�N�s�N�`���p�̍��W�ɃX�e�B�b�N�s�N�`����u�����ꏊ��x���̖ڐ����ǉ�
xticks(ax_Stick_XLim_Range * (Stick_Pics_X_All - ax_Data.XLim(1)) / diff(ax_Data.XLim))

% �X�e�B�b�N�s�N�`���p�̍��W��x������Grid on
ax_Stick.XGrid = 'on';

% ��ԍ��[�̃X�e�B�b�N�s�N�`���̍��[���M���M������悤�ɃX�e�B�b�N�s�N�`���p�̍��W��x���̉��[��ݒ�
ax_Stick.XLim(1) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Data.XLim(1)) / (ax_Data.XLim(2) - ax_Data.XLim(1)) - Stick_Pics_Width/2 - Stick_Pics_Width;

% ��ԉE�[�̃X�e�B�b�N�s�N�`���̉E�[���M���M������悤�ɃX�e�B�b�N�s�N�`���p�̍��W��x���̏�[��ݒ�
ax_Stick.XLim(2) = ax_Stick_XLim_Range * (Stick_Pics_X_All(end) - ax_Data.XLim(1)) / (ax_Data.XLim(2) - ax_Data.XLim(1)) + Stick_Pics_Width/2;

% ��ԏ�̃X�e�B�b�N�s�N�`���̏�[�ƈ�ԉ��̃X�e�B�b�N�s�N�`���̉��[������p�ɐݒ�, �������M���M���ł͂Ȃ�
ax_Stick.YLim = [- Stick_Pics_Height_Base_Top - Stick_Pics_Height * (size(Stick_Pics_Legend_Labels(:), 1) - 1) - Stick_Pics_Height_Base_Bottom, 0];

% ���̐F������
ax_Stick.XColor = 'none';
ax_Stick.YColor = 'none';

% ��f�[�^�̉����ɒǉ������X�e�B�b�N�s�N�`���̏ꏊ�ɑΉ�����x���ɖڐ����ǉ��CGrid������ň�v����.
for Stick_Pics_X_All_Index = 1:size(Stick_Pics_X_All, 1)
    if all(abs(ax_Data.XTick - Stick_Pics_X_All(Stick_Pics_X_All_Index))>0.01)
        XTickLabel_tmp = [ax_Data.XTickLabel(:)', {''}];
        [ax_Data.XTick, Sorted_Index] = sort([ax_Data.XTick, Stick_Pics_X_All(Stick_Pics_X_All_Index)]);
        XTickLabel_tmp = XTickLabel_tmp(Sorted_Index);
        ax_Data.XTickLabel = XTickLabel_tmp;
    end
end

% ��ԉE�[�̃X�e�B�b�N�s�N�`���̉E�[����f�[�^�̉����̏�[���傫�������ꍇ�C��f�[�^�̉����������k������
if ax_Stick.XLim(2) / ax_Stick_XLim_Range > 1
    ax_Data.Position(3) = (1 - ax_Data.Position(1)) / (ax_Stick.XLim(2) / ax_Stick_XLim_Range);
else
    
end

% x���Cy���̃f�[�^�𓯂������ŕ\������D�Ⴆ�Ή~�������Ɖ~�Ƃ��ĕ\�������悤�ɂȂ�
% �����ŕ\������Ă��� y���̑傫���Ǝ��� Position �v���p�e�B����v���Ȃ��Ȃ�
daspect([1, 1, 1])

fig_tmp = gcf;
% figure �� Position �̒P�ʂ� pixels �ɐݒ�
fig_tmp.Units = 'pixels';

% ��f�[�^�̍��W�� Position �̒P�ʂ� pixels �ɐݒ�
ax_Data.Units = fig_tmp.Units;
% �X�e�B�b�N�s�N�`���p�̍��W�� Position �̒P�ʂ� pixels �ɐݒ�
ax_Stick.Units = fig_tmp.Units;

% �X�e�B�b�N�s�N�`���̈ʒu�Ǝ�f�[�^�̉����̈ʒu�������悤�� Position �𒲐�
ax_Stick.Position(1) = ax_Data.Position(1) + ax_Data.Position(3) * ax_Stick.XLim(1) / ax_Stick_XLim_Range;
ax_Stick.Position(3) = ax_Data.Position(3) * diff(ax_Stick.XLim) / ax_Stick_XLim_Range;

% dapect �ň�v���Ȃ��Ȃ��� y���̑傫���Ǝ��� Position �v���p�e�B�����킹��
ax_Stick.Position(4) = ax_Stick.Position(3) * diff(ax_Stick.YLim) / diff(ax_Stick.XLim);

% figure �̏�[�ɃX�e�B�b�N�s�N�`���p�̍��W�̏�[����v����悤�ɃX�e�B�b�N�s�N�`���p�̍��W�̉��[��ݒ�
ax_Stick.Position(2) = (fig_tmp.Position(2) + fig_tmp.Position(4)) - ax_Stick.Position(4);

% �X�e�B�b�N�s�N�`���p�̍��W�̏�[�Ɏ�f�[�^�p�̍��W�̏�[����v����悤�Ɏ�f�[�^�p�̍��W�̍�����ݒ�
ax_Data.Position(4) = ax_Stick.Position(2) - ax_Data.Position(2) - ax_Data.TightInset(4);

end

















































