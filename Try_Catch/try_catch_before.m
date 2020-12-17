
x_1 = (1:10)';
y_1 = (1:10)';

x_2 = (1:100)';
y_2 = (1:10)';

x_3 = (1:100)';
y_3 = (1:100)';

Cell_tmp = {x_1, y_1;
    x_2, y_2;
    x_3, y_3};

for Cell_tmp_Index = 1:size(Cell_tmp, 1)
    Scatter_tmp(Cell_tmp{Cell_tmp_Index,1}, Cell_tmp{Cell_tmp_Index,2});
end