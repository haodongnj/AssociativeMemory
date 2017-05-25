close all ;
% Im_input = zeros(image_height, image_width);
Im_original =  rgb2gray( imread('01.jpg')) ;
Im_input = Im_original  + uint8( 200 * randn(size(Im_original))); % ∏ﬂÀπ‘Î…˘
% Im_input = imnoise(Im_original, 'salt & pepper', 0.1);
Im_output = zeros(image_height, image_width);

figure('name', 'Input Test.');
imshow(Im_input)

X_iter = cell(image_height, image_width);
S_iter = cell(image_height, image_width);

number_of_iterations = 20 ;
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
    
    imshow(Im_output_Cell{count} );

end

nmse_test = NMSE( Im_original, Im_output_Cell{count} )