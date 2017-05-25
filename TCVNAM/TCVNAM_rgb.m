clear all ;
close all ;
% 采用分治策略设计网络

% number of patterns to be remembered
m = 4 ;

% read and reshape the image to vector
Im = {
    imread('02.jpg'), ...
    imread('03.jpg'), ...
    imread('05.jpg'), ...
    imread('06.jpg'), ...
};

[image_height, image_width] = size(Im{1}(:,:,1));

% width and height of single unit image ;
unit_width = 20 ;
unit_height = 20 ;

% iterations 
iter_row = image_height/unit_height ;
iter_column = image_width/unit_width ;

% Initialize cell matrix A U S V T;
A = cell(iter_row, iter_column, 3) ;
U = cell(iter_row, iter_column, 3) ;
S = cell(iter_row, iter_column, 3) ;
V = cell(iter_row, iter_column, 3) ;
T = cell(iter_row, iter_column, 3) ; % Triagular Matrix ;
W = cell(iter_row, iter_column, 3) ;
H = cell(iter_row, iter_column, 3) ;

alpha = 10 ;
gamma = 0.25 ;
phi0 = 2 * pi / 256 ;
z_half = exp(1i * phi0/2 );

for channel = 1:3
    for i = 1:1:iter_row
        for j = 1:1:iter_column
        % Step1 : Initialize matrix A and transform uint8 to double
        A_unit = exp( 1i * phi0 *  ...
                 double([
                    reshape(Im{1}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width, channel ), unit_height * unit_width, 1),...
                    reshape(Im{2}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width, channel ), unit_height * unit_width, 1),...
                    reshape(Im{3}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width, channel ), unit_height * unit_width, 1),...
                    reshape(Im{4}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width, channel ), unit_height * unit_width, 1)...
                 ]));
        A_unit_m = zeros(size(A_unit));
        for k = 1:1:m
            A_unit_m(:, k) = A_unit(:, m) ;
        end
        A_unit_svd = A_unit - A_unit_m ;
        A_unit_svd = A_unit_svd(:, 1:(m-1) );
        % Step 2 
        [U_unit, S_unit, V_unit] = svd(A_unit_svd);

        % Step 3: Calculate the triangular matrix 
        T = zeros(unit_height * unit_width,unit_height * unit_width );
        for a = 1:unit_height * unit_width
            for b = 1:unit_height * unit_width 
                if(a == b && a >= m)
                    T(a, b) = rand();
                else if( a== b )
                        T(a, b) = alpha ;
                    else if(a > b && a >= m && b >= m)
                            T(a, b) = (rand() * 2 - 1) * gamma ;
                        end
                    end
                end
            end
        end

        W_unit = U_unit * T * U_unit' ;
        % Step 4 ;
        H_unit = alpha * A_unit(:, m) - W_unit * A_unit(:, m);


        A{i, j, channel} = A_unit ;
        U{i, j, channel} = U_unit ;
        S{i, j, channel} = S_unit ;
        V{i, j, channel} = V_unit ;
        W{i, j, channel} = W_unit ;
        H{i, j, channel} = H_unit ;
        end
    end
end
