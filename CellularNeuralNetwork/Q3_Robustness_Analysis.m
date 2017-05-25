% Robustness Analysis using Statisics
% Monte Carlo Method

%% Initialize the data to workspace
clear all ;

c = 0.96 ;
lamda = 4 ;

pattern_size = [3,4,5,6,7,8,9,10];
number_of_pattern_sizes =  size(pattern_size);
success_rate = zeros(number_of_pattern_sizes);

for order_of_pattern_size = 1:1:number_of_pattern_sizes(2)
    A = zeros(pattern_size(order_of_pattern_size)^2, pattern_size(order_of_pattern_size)^2);
    
    A1 = diag(ones(pattern_size(order_of_pattern_size),1) * 0.9 ) + ...
         diag(ones(pattern_size(order_of_pattern_size) - 1,1) * -0.01, 1) + ...
         diag(ones(pattern_size(order_of_pattern_size) - 1,1) * -0.01, -1);

   A2 = diag(ones(pattern_size(order_of_pattern_size),1) * -0.01 ) + ...
        diag(ones(pattern_size(order_of_pattern_size) - 1,1) * -0.01, 1) + ...
        diag(ones(pattern_size(order_of_pattern_size) - 1,1) * -0.01, -1);
    
   A3 = A2 ;
   
   A(1:pattern_size(order_of_pattern_size),1:pattern_size(order_of_pattern_size) ) = A1 ;
   A(1:pattern_size(order_of_pattern_size),pattern_size(order_of_pattern_size) + 1:2*pattern_size(order_of_pattern_size) ) = A2 ;
   
    for temp_count = 1:(pattern_size(order_of_pattern_size)-2)
        A(temp_count * pattern_size(order_of_pattern_size) + 1 :( temp_count + 1) * pattern_size(order_of_pattern_size), ...
          (temp_count-1) * pattern_size(order_of_pattern_size) + 1 : temp_count * pattern_size(order_of_pattern_size)) = A3;
        A(temp_count * pattern_size(order_of_pattern_size) + 1 :( temp_count + 1) * pattern_size(order_of_pattern_size), ...
          (temp_count) * pattern_size(order_of_pattern_size) + 1 : (temp_count+1) * pattern_size(order_of_pattern_size)) = A1;
        A(temp_count * pattern_size(order_of_pattern_size) + 1 :( temp_count + 1) * pattern_size(order_of_pattern_size), ...
          (temp_count+1) * pattern_size(order_of_pattern_size) + 1 : (temp_count+2) * pattern_size(order_of_pattern_size)) = A2;
    end
    
    A(pattern_size(order_of_pattern_size)*(pattern_size(order_of_pattern_size)-1) + 1:pattern_size(order_of_pattern_size)*pattern_size(order_of_pattern_size),...
      pattern_size(order_of_pattern_size)*(pattern_size(order_of_pattern_size)-2) + 1:pattern_size(order_of_pattern_size)*(pattern_size(order_of_pattern_size)-1) ) = A3 ;
    A(pattern_size(order_of_pattern_size)*(pattern_size(order_of_pattern_size)-1) + 1:pattern_size(order_of_pattern_size)*pattern_size(order_of_pattern_size),...
      pattern_size(order_of_pattern_size)*(pattern_size(order_of_pattern_size)-1) + 1:pattern_size(order_of_pattern_size)*pattern_size(order_of_pattern_size) ) = A1 ;
    
    % Desired memory patterns
    % how many patterns;
    number_of_patterns = pattern_size(order_of_pattern_size)^2 ;
    
    Sp = ones(pattern_size(order_of_pattern_size)^2, number_of_patterns) ;
    
    rand_column = rand(pattern_size(order_of_pattern_size)^2, 1);
    rand_column( rand_column > 0.5) = 1 ;
    rand_column( rand_column < 0.5) = -1 ;
    Sp(:,1) = rand_column ;
    sp_column = 2 ;
    
    
    
    while sp_column <= number_of_patterns
        rand_column = rand(pattern_size(order_of_pattern_size)^2, 1);
        rand_column( rand_column > 0.5) = 1 ;
        rand_column( rand_column < 0.5) = -1 ; 
        
        flag_duplicate = 0 ;
        for temp_count = 1:sp_column-1
            if(Sp(:, temp_count) == rand_column )
                flag_duplicate = 1 ;
                break ;
            end
        end
        
        if(flag_duplicate == 0 )
            Sp(:, sp_column) = rand_column ;
            sp_column = sp_column + 1 ;
        end
    end
    % Data Input are the same as Desired memory patterns for Auto Association
    Up = Sp ;

    D = lamda * Sp * (Up' * Up)^(-1) * Up';
    % Bias vector is set to zeros
    V = zeros(pattern_size(order_of_pattern_size)^2, 1) ;


    %% Monte Carlo Method
    % 1000 times to acquire success rate
    number_of_test = 5000 ;
    success_count = 0 ;
    
    for count_statistic = 1:1:number_of_test

        % The initial output and neuron state is randomly set ;
        s_input = rand(pattern_size(order_of_pattern_size)^2 , 1) * 2 - 1;
        x_input = rand(pattern_size(order_of_pattern_size)^2, 1) * 2 - 1;

        % Choose a image for test and show it ;
        % random input with random probe distortion
        input_original = Sp( : , ceil( number_of_patterns  * rand()) ) ;
        input_test = input_original * (rand() + 0.001)/1.001 ;
        input_test = input_test +  rand(pattern_size(order_of_pattern_size)^2, 1)* 2 - 1 ;

        % The input is multiplied by 0.1 plus some noise ;
        u_input = input_test ;

        % no more than 20 iterations
        for count = 1:100
            [x_out, s_out]= CNN_Calc(A, c, D, V, u_input, x_input, s_input);
            x_input = x_out ;
            s_input = s_out ;
        end
        
        if input_original == s_out 
            success_count = success_count + 1 ;
        end
    end

    success_rate(order_of_pattern_size) = success_count / number_of_test;
end