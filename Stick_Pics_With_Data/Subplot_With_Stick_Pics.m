function [ax_Subplot, ax_Stick, ax_BackGround] = Subplot_With_Stick_Pics(X, Y, XLabel_Str, YLabel_Str, Title_Str, Legend_Labels, XAxisLocation, ...
    Stick_Pics_X, Stick_Pics_Data_X, Stick_Pics_Data_Y, Stick_Pics_Legend_Labels, XTick_For_One_Stick_Pics, Stick_Pics_Width, Stick_Pics_Height)
%CALL_FIGURE_NEW この関数の概要をここに記述
%   詳細説明をここに記述

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

% もし主データの横軸の一番左と一番右にスティックピクチャを載せるとしたら，どのくらいのx軸の幅になるのかを計算
% 例えば diff(ax_Subplot_Top.XLim) = 2 の時に
% XTick_For_One_Stick_Pics = 1 だとちょうど2枚のスティックピクチャを隙間なく並べると端から端までの大きさになる，このようにスティックピクチャの大きさを決める
% そのうえで Stick_Pics_Width = 1 だと1枚のスティックピクチャに関して中心から端までの距離が 1 になる
% XTick_For_One_Stick_Pics = Stick_Pics_Width の時は Stick_Pics_X = [0,1,2] だと隙間なく並ぶ，Stick_Pics_X = [0,0.5,1] だと半分ずつ重なって, 0.5のスティックピクチャは0と1に覆われてしまう
ax_Stick_XLim_Range = diff(ax_Subplot_Top.XLim) / XTick_For_One_Stick_Pics * Stick_Pics_Width;

% スティックピクチャの中心から上端の距離
Stick_Pics_Height_Base_Top = Stick_Pics_Height / 2;

% スティックピクチャの中心から下端の距離
Stick_Pics_Height_Base_Bottom = Stick_Pics_Height / 2;

Stick_Pics_X_All = [];
for Stick_Pics_Legend_Index = 1:size(Stick_Pics_Legend_Labels(:), 1)
    
    % cell から double の配列に取り出す
    Stick_Pics_X_tmp = Stick_Pics_X{Stick_Pics_Legend_Index};
    Stick_Pics_Data_X_tmp = Stick_Pics_Data_X{Stick_Pics_Legend_Index};
    Stick_Pics_Data_Y_tmp = Stick_Pics_Data_Y{Stick_Pics_Legend_Index};
    
    Stick_Pics_X_All = [Stick_Pics_X_All; Stick_Pics_X_tmp];
    
    % 中心のy座標
    Origin_Y = -Stick_Pics_Height_Base_Top - Stick_Pics_Height * (Stick_Pics_Legend_Index - 1);
    
    % 中心のx座標
    Origin_X = 0 + ax_Stick_XLim_Range * (Stick_Pics_X_tmp - ax_Subplot_Top.XLim(1)) / diff(ax_Subplot_Top.XLim);
    
    Joint_X = Stick_Pics_Data_X_tmp + Origin_X';
    Joint_Y = Stick_Pics_Data_Y_tmp + Origin_Y;
    
    hold on
    plot(Joint_X, Joint_Y, 'k')
    hold off
end

% どの部分にスティックピクチャを置いたか記録，後でGridを追加する
Stick_Pics_X_All = sort(unique(Stick_Pics_X_All));

% スティックピクチャの横に凡例の追加
Stick_Pics_Legend_Index = 1:size(Stick_Pics_Legend_Labels(:), 1);
Text_X(Stick_Pics_Legend_Index) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Subplot_Top.XLim(1)) / diff(ax_Subplot_Top.XLim) - Stick_Pics_Width/2;
Text_Y = -Stick_Pics_Height_Base_Top - Stick_Pics_Height * (Stick_Pics_Legend_Index - 1);
text(Text_X, Text_Y, Stick_Pics_Legend_Labels, 'HorizontalAlignment', 'right')

% 一番左端のスティックピクチャの左端がギリギリ入るようにスティックピクチャ用の座標のx軸の下端を設定
ax_Stick.XLim(1) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Subplot_Top.XLim(1)) / (ax_Subplot_Top.XLim(2) - ax_Subplot_Top.XLim(1)) - Stick_Pics_Width/2;

% 一番右端のスティックピクチャの右端がギリギリ入るようにスティックピクチャ用の座標のx軸の上端を設定
ax_Stick.XLim(2) = ax_Stick_XLim_Range * (Stick_Pics_X_All(end) - ax_Subplot_Top.XLim(1)) / (ax_Subplot_Top.XLim(2) - ax_Subplot_Top.XLim(1)) + Stick_Pics_Width/2;

% 一番上のスティックピクチャの上端と一番下のスティックピクチャの下端が入る用に設定, ただしギリギリではない
ax_Stick.YLim = [- Stick_Pics_Height_Base_Top - Stick_Pics_Height * (size(Stick_Pics_Legend_Labels(:), 1) - 1) - Stick_Pics_Height_Base_Bottom, 0];

% 軸の色を消す
ax_Stick.XColor = 'none';
ax_Stick.YColor = 'none';

% 透明化
ax_Stick.Color = 'none';

% Subplotたちの横幅を調整する
% 一番右端のスティックピクチャの右端が主データの横軸の上端より大きかった場合，主データの横軸を少し縮小する
if ax_Stick.XLim(2) / ax_Stick_XLim_Range > 1
    for Subplot_Index = 1:Subplot_Num
        ax_Subplot(Subplot_Index, 1).Position(3) = (1 - ax_Subplot_Top.Position(1)) / (ax_Stick.XLim(2) / ax_Stick_XLim_Range);
    end
else
    
end

% x軸，y軸のデータを同じ長さで表示する．例えば円がちゃんと円として表示されるようになる
% ここで表示されている y軸の大きさと軸の Position プロパティが一致しなくなる
daspect([1, 1, 1])

% スティックピクチャの位置と主データの横軸の位置が合うように Position を調整
ax_Stick.Position(1) = ax_Subplot_Top.Position(1) + ax_Subplot_Top.Position(3) * ax_Stick.XLim(1) / ax_Stick_XLim_Range;
ax_Stick.Position(3) = ax_Subplot_Top.Position(3) * diff(ax_Stick.XLim) / ax_Stick_XLim_Range;

% Grid を載せるための全体の背景座標を設定
ax_BackGround = axes;

% 他の座標たちを最前面に
for Subplot_Index = 1:Subplot_Num
    axes(ax_Subplot(Subplot_Index, 1))
end
axes(ax_Stick)

% 透明化
ax_BackGround.YColor = 'none';

% 軸合わせ
xlim(ax_BackGround, ax_Subplot(end, 1).XLim)

% タイトル，xlabel挿入
title(ax_BackGround, Title_Str);
xlabel(ax_BackGround, XLabel_Str);

% グリッド線の追加
alpha_Value = 0.2;
for Stick_Pics_X_All_Index = 1:size(Stick_Pics_X_All,1)
    patch(ax_BackGround, [Stick_Pics_X_All(Stick_Pics_X_All_Index), Stick_Pics_X_All(Stick_Pics_X_All_Index), NaN], ...
        [ax_BackGround.YLim, NaN], 'k', 'EdgeColor', 'k', ...
        'FaceVertexAlphaData', [alpha_Value; alpha_Value; alpha_Value],'AlphaDataMapping','none', 'EdgeAlpha','interp')
end

% 横合わせ
ax_BackGround.Position([1,3]) = [ax_Subplot(end, 1).Position(1), ax_Subplot(end, 1).Position(3)];


% 縦合わせ
ax_BackGround.OuterPosition(2) = 0;

% ラベル用の余白分を残して座標系のPositionを設定
ax_BackGround.Position(2) = ax_BackGround.OuterPosition(2) + ax_BackGround.TightInset(2);

% 縦全部覆うようにする
ax_BackGround.OuterPosition(4) = 1 - ax_BackGround.OuterPosition(2);

% ラベル用の余白分を残して座標系のPositionを設定
ax_BackGround.Position(4) = ax_BackGround.OuterPosition(2) + ax_BackGround.OuterPosition(4) - ax_BackGround.TightInset(4) - ax_BackGround.Position(2);

% スティックピクチャ用の座標の幅と位置を決定，背景の座標系の上端に張り付くようにする
fig_tmp = gcf;
ax_Stick.Position(4) = ax_Stick.Position(3) * diff(ax_Stick.YLim) / diff(ax_Stick.XLim) * fig_tmp.Position(3) / fig_tmp.Position(4);
ax_Stick.Position(2) = ax_BackGround.Position(2) + ax_BackGround.Position(4) - ax_Stick.Position(4);

% Subplotの座標系の大枠の高さを計算
ax_Subplot_OuterPosition_4 = (ax_Stick.Position(2) - ax_BackGround.Position(2))/Subplot_Num;

% 一つ一つ位置を設定していく．大枠が接するようにする．座標系を接させると，目盛りが重なってしまったりする
for Subplot_Index = 1:Subplot_Num
    ax_Subplot(Subplot_Index, 1).OuterPosition(4) = ax_Subplot_OuterPosition_4;
    ax_Subplot(Subplot_Index, 1).OuterPosition(2) = ax_Stick.Position(2) - ax_Subplot_OuterPosition_4 * Subplot_Index;
    legend(ax_Subplot(Subplot_Index, 1), Legend_Labels, 'Location', 'best')
end

% x軸を各座標の一番下に置く場合，Subplotの一番下のx軸は背景のx軸で塗り替える
if isequal(XAxisLocation, 'bottom')
    ax_Subplot(end,1).XColor = 'none';
    ax_BackGround.Position(4) = ax_BackGround.Position(4) - (ax_Subplot(end,1).Position(2) - ax_BackGround.Position(2));
    ax_BackGround.Position(2) = ax_Subplot(end,1).Position(2);
end

end

















































