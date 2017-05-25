% 复现论文中的自联想实验
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

desired1 = reshape(data_H, 25, 1);
desired2 = reshape(data_E, 25, 1);
desired3 = reshape(data_V, 25, 1);
desired4 = reshape(data_5, 25, 1);
desired5 = reshape(data_O, 25, 1);

% Desired memory patterns
Sp = [desired1, desired2, desired3, desired4, desired5 ] ;

% Data Input are the same as Desired memory patterns for Auto Association
Up = [desired1, desired2, desired3, desired4, desired5] ;

D = lamda * Sp * (Up' * Up)^(-1) * Up';
V = zeros(25, 1) ;

% The initial output and neuron state is randomly set ;
s_input = rand(25, 1) ;
x_input = rand(25, 1);

% Choose a image for test and show it ;
input_test = desired3 ;
ShowImage(reshape(input_test, 5, 5))
% The input is multiplied by 0.1 plus some noise ;
% u_input = 0.1 * input_test ;
u_input = 0.1 * input_test + 0.1 * ( 2 * rand(25, 1) -1 ) ;

for count = 1:10
    [x_out, s_out]= CNN_Calc(A, c, D, V, u_input, x_input, s_input);
    x_input = x_out ;
    s_input = s_out ;
end




