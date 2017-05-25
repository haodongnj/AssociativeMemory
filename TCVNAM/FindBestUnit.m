clear all ;
close all ;
% 采用分治策略设计网络

% number of patterns to be remembered
m = 4 ;

% read and reshape the image to vector
Im = {
    rgb2gray(imread('01.jpg')), ...
    rgb2gray(imread('02.jpg')), ...
    rgb2gray(imread('03.jpg')), ...
    rgb2gray(imread('04.jpg')), ...
};

[image_height, image_width] = size(Im{1});

unit_size = [5, 10, 20, 40, 80];
nmse_FindBestUnit = zeros(size(unit_size));
t = zeros(size(unit_size)); 


for iter_unit_size = 1:1:5
    t_start = cputime(); % Calculate the time ;
    % width and height of single unit image ;
    unit_width = unit_size(iter_unit_size) ;
    unit_height = unit_size(iter_unit_size) ;

    % iterations 
    iter_row = image_height/unit_height ;
    iter_column = image_width/unit_width ;

    % Initialize cell matrix A U S V T;
    A = cell(iter_row, iter_column) ;
    U = cell(iter_row, iter_column) ;
    S = cell(iter_row, iter_column) ;
    V = cell(iter_row, iter_column) ;
    T = cell(iter_row, iter_column) ; % Triagular Matrix ;
    W = cell(iter_row, iter_column) ;
    H = cell(iter_row, iter_column);

    alpha = 10 ;
    gamma = 0.25 ;
    phi0 = 2 * pi / 256 ;
    z_half = exp(1i * phi0/2 );

    for i = 1:1:iter_row
        for j = 1:1:iter_column
        % Step1 : Initialize matrix A and transform uint8 to double
        A_unit = exp( 1i * phi0 *  ...
                 double([
                    reshape(Im{1}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width ), unit_height * unit_width, 1),...
                    reshape(Im{2}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width ), unit_height * unit_width, 1),...
                    reshape(Im{3}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width ), unit_height * unit_width, 1),...
                    reshape(Im{4}( (i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width ), unit_height * unit_width, 1)...
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


        A{i, j} = A_unit ;
        U{i, j} = U_unit ;
        S{i, j} = S_unit ;
        V{i, j} = V_unit ;
        W{i, j} = W_unit ;
        H{i, j} = H_unit ;
        end
    end

    close all ;
    % Im_input = zeros(image_height, image_width);
    Im_original =  rgb2gray( imread('01.jpg')) ;
    Im_input = Im_original  + uint8( 100 * randn(size(Im_original))); % 高斯噪声
    % Im_input = imnoise(Im_original, 'salt & pepper', 0.1);
    Im_output = zeros(image_height, image_width);

    figure('name', 'Input Test.');
    imshow(Im_input)

    X_iter = cell(image_height, image_width);
    S_iter = cell(image_height, image_width);

    number_of_iterations = 10 ;
    Im_output_Cell = cell(number_of_iterations);

    for count = 1:number_of_iterations
        for i = 1:1:iter_row
            for j = 1:1:iter_column
                if ( count == 1 )
                    X_iter{i,j} = exp( 1i * phi0 * double( reshape(Im_input(((i-1) * unit_height + 1):i * unit_height, ((j-1) * unit_width + 1): j* unit_width ), unit_height * unit_width, 1)) );
                else
                    X_iter{i,j} = S_iter{i,j};
                end
                S_iter{i,j} = ActivationFunction(X_iter{i,j} , W{i,j}, H{i,j}) ;

                Im_output((i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width) = log( reshape( S_iter{i,j} ,unit_height,unit_width)) / ( 1i * phi0) ;
            end
        end

        figure();
        Im_output = real(Im_output) ;
        Im_output(Im_output < 0 ) = Im_output(Im_output < 0 ) + 256 ;

        Im_output_Cell{count} = uint8(Im_output);

        %imshow(Im_output_Cell{count} );

    end

    nmse_FindBestUnit(iter_unit_size) = NMSE( Im_original, Im_output_Cell{count} );
    
    t(iter_unit_size) = cputime() - t_start ; % Calculate the time
end
