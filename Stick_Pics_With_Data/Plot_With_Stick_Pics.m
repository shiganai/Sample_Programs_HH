function Plot_With_Stick_Pics(X, Y, Stick_Pics_X, Stick_Pics_Data_X, Stick_Pics_Data_Y, XTick_For_One_Stick_Pics, Stick_Pics_Width, Stick_Pics_Height, Stick_Pics_Legend_Labels)
%CALL_FIGURE_NEW この関数の概要をここに記述
%   詳細説明をここに記述

% 今までの座標系を削除
clf('reset')

plot(X, Y)
title('Sample')

ax_Data = gca;

% 上枠と右枠の削除
ax_Data.Box = 'off';

ax_Data.YGrid = 'on';
ax_Data.XGrid = 'on';

% スティックピクチャ用の軸を作成
ax_Stick = axes('Position', ax_Data.Position);

% もし主データの横軸の一番左と一番右にスティックピクチャを載せるとしたら，どのくらいのx軸の幅になるのかを計算
% 例えば diff(ax_Data.XLim) = 2 の時に
% XTick_For_One_Stick_Pics = 1 だとちょうど2枚のスティックピクチャを隙間なく並べると端から端までの大きさになる，このようにスティックピクチャの大きさを決める
% そのうえで Stick_Pics_Width = 1 だと1枚のスティックピクチャに関して中心から端までの距離が 1 になる
% XTick_For_One_Stick_Pics = Stick_Pics_Width の時は Stick_Pics_X = [0,1,2] だと隙間なく並ぶ，Stick_Pics_X = [0,0.5,1] だと半分ずつ重なって, 0.5のスティックピクチャは0と1に覆われてしまう
ax_Stick_XLim_Range = diff(ax_Data.XLim) / XTick_For_One_Stick_Pics * Stick_Pics_Width;

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
    Origin_X = 0 + ax_Stick_XLim_Range * (Stick_Pics_X_tmp - ax_Data.XLim(1)) / diff(ax_Data.XLim);
    
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
Text_X(Stick_Pics_Legend_Index) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Data.XLim(1)) / diff(ax_Data.XLim) - Stick_Pics_Width/2;
Text_Y = -Stick_Pics_Height_Base_Top - Stick_Pics_Height * (Stick_Pics_Legend_Index - 1);
text(Text_X, Text_Y, Stick_Pics_Legend_Labels, 'HorizontalAlignment', 'right')

% スティックピクチャ用の座標にスティックピクチャを置いた場所のx軸の目盛りを追加
xticks(ax_Stick_XLim_Range * (Stick_Pics_X_All - ax_Data.XLim(1)) / diff(ax_Data.XLim))

% スティックピクチャ用の座標のx軸だけGrid on
ax_Stick.XGrid = 'on';

% 一番左端のスティックピクチャの左端がギリギリ入るようにスティックピクチャ用の座標のx軸の下端を設定
ax_Stick.XLim(1) = ax_Stick_XLim_Range * (Stick_Pics_X_All(1) - ax_Data.XLim(1)) / (ax_Data.XLim(2) - ax_Data.XLim(1)) - Stick_Pics_Width/2 - Stick_Pics_Width;

% 一番右端のスティックピクチャの右端がギリギリ入るようにスティックピクチャ用の座標のx軸の上端を設定
ax_Stick.XLim(2) = ax_Stick_XLim_Range * (Stick_Pics_X_All(end) - ax_Data.XLim(1)) / (ax_Data.XLim(2) - ax_Data.XLim(1)) + Stick_Pics_Width/2;

% 一番上のスティックピクチャの上端と一番下のスティックピクチャの下端が入る用に設定, ただしギリギリではない
ax_Stick.YLim = [- Stick_Pics_Height_Base_Top - Stick_Pics_Height * (size(Stick_Pics_Legend_Labels(:), 1) - 1) - Stick_Pics_Height_Base_Bottom, 0];

% 軸の色を消す
ax_Stick.XColor = 'none';
ax_Stick.YColor = 'none';

% 主データの横軸に追加したスティックピクチャの場所に対応するx軸に目盛りを追加，Gridがこれで一致する.
for Stick_Pics_X_All_Index = 1:size(Stick_Pics_X_All, 1)
    if all(abs(ax_Data.XTick - Stick_Pics_X_All(Stick_Pics_X_All_Index))>0.01)
        XTickLabel_tmp = [ax_Data.XTickLabel(:)', {''}];
        [ax_Data.XTick, Sorted_Index] = sort([ax_Data.XTick, Stick_Pics_X_All(Stick_Pics_X_All_Index)]);
        XTickLabel_tmp = XTickLabel_tmp(Sorted_Index);
        ax_Data.XTickLabel = XTickLabel_tmp;
    end
end

% 一番右端のスティックピクチャの右端が主データの横軸の上端より大きかった場合，主データの横軸を少し縮小する
if ax_Stick.XLim(2) / ax_Stick_XLim_Range > 1
    ax_Data.Position(3) = (1 - ax_Data.Position(1)) / (ax_Stick.XLim(2) / ax_Stick_XLim_Range);
else
    
end

% x軸，y軸のデータを同じ長さで表示する．例えば円がちゃんと円として表示されるようになる
% ここで表示されている y軸の大きさと軸の Position プロパティが一致しなくなる
daspect([1, 1, 1])

fig_tmp = gcf;
% figure の Position の単位を pixels に設定
fig_tmp.Units = 'pixels';

% 主データの座標の Position の単位を pixels に設定
ax_Data.Units = fig_tmp.Units;
% スティックピクチャ用の座標の Position の単位を pixels に設定
ax_Stick.Units = fig_tmp.Units;

% スティックピクチャの位置と主データの横軸の位置が合うように Position を調整
ax_Stick.Position(1) = ax_Data.Position(1) + ax_Data.Position(3) * ax_Stick.XLim(1) / ax_Stick_XLim_Range;
ax_Stick.Position(3) = ax_Data.Position(3) * diff(ax_Stick.XLim) / ax_Stick_XLim_Range;

% dapect で一致しなくなった y軸の大きさと軸の Position プロパティを合わせる
ax_Stick.Position(4) = ax_Stick.Position(3) * diff(ax_Stick.YLim) / diff(ax_Stick.XLim);

% figure の上端にスティックピクチャ用の座標の上端が一致するようにスティックピクチャ用の座標の下端を設定
ax_Stick.Position(2) = (fig_tmp.Position(2) + fig_tmp.Position(4)) - ax_Stick.Position(4);

% スティックピクチャ用の座標の上端に主データ用の座標の上端が一致するように主データ用の座標の高さを設定
ax_Data.Position(4) = ax_Stick.Position(2) - ax_Data.Position(2) - ax_Data.TightInset(4);

end

















































