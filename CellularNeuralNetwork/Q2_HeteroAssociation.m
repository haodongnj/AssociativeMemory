% 复现论文中的异联想实验
Data

% A_template + B_template = []; r = 1 ;
A_T = [-0.01, -0.01, -0.01;
             -0.01, 0.9, -0.01;
            -0.01, -0.01, -0.01]; 
A1 = [
    0.9     -0.01      0        0       0       ;
    -0.01   0.9     -0.01       0       0       ;
    0       -0.01   0.9         -0.01   0       ;
    0       0       -0.01       0.9     -0.01   ;
    0       0       0           -0.01   0.9     ;
];

A2 = [
    -0.01   -0.01     0        0       0       ;
    -0.01   -0.01     -0.01    0       0       ;
    0       -0.01     -0.01    -0.01   0       ;
    0       0         -0.01    -0.01   -0.01   ;
    0       0         0        -0.01   -0.01   ;
];

A3 = [
    -0.01   -0.01     0        0       0       ;
    -0.01   -0.01     -0.01    0       0       ;
    0       -0.01     -0.01    -0.01   0       ;
    0       0         -0.01    -0.01   -0.01   ;
    0       0         0        -0.01   -0.01   ;
];

A = [
    A1, A2, zeros(5,5), zeros(5,5), zeros(5,5);
    A3, A1, A2, zeros(5,5),zeros(5,5);
    zeros(5,5), A3, A1, A2, zeros(5,5);
    zeros(5,5), zeros(5,5), A3, A1, A2;
    zeros(5,5),zeros(5,5),zeros(5,5), A3, A1;
    ];
c = 0.96 ;
lamda = 4 ;

desired1 = reshape(data_big, 25, 1);
desired2 = reshape(data_small, 25, 1);
desired3 = reshape(data_soil, 25, 1);

ShowImage(reshape(desired1, 5, 5))

% Desired memory patterns
% 大，小，土
Sp = [desired1, desired2, desired3] ;

% Input: H, V, O
H_input = reshape(data_H, 25, 1);
V_input = reshape(data_V, 25, 1); 
O_input = reshape(data_O, 25, 1);
Up = [ H_input, V_input, O_input] ;

D = lamda * Sp * (Up' * Up)^(-1) * Up';
V = zeros(25, 1) ;

s_input = rand(25, 1) * 2 - ones(25, 1) ;
% u_input = 0.1 * H_input ;
% add random noise ;
% u_input = 0.1 * H_input + 0.2 * rand(25, 1) ;
u_input = 0.1 * V_input + 0.2 * rand(25, 1) ;
x_input = zeros(25, 1);

ShowImage(reshape(s_input, 5, 5));

for count = 1:10 
    [x_out, s_out]= CNN_Calc(A, c, D, V, u_input, x_input, s_input);
    x_input = x_out ;
    s_input = s_out ;
end




