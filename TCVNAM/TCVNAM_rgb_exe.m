close all ;
% Im_input = zeros(image_height, image_width);
Im_input =  imread('02.jpg');
% Im_input = imnoise(Im_input, 'gaussian',0.02);
Im_input = Im_input +  uint8( 200 * randn(size(Im_input)));
Im_output = zeros(image_height, image_width);

figure('name', 'Input Test.');
imshow(Im_input)

X_iter = cell(image_height, image_width, 3 );

number_of_iterations = 10 ;
Im_output_Cell = cell(number_of_iterations);

for count = 1:number_of_iterations
    for channel = 1:3
        for i = 1:1:iter_row
            for j = 1:1:iter_column
                if count == 1 
                    X_iter{i,j, channel} = exp( 1i * phi0 * double( reshape(Im_input((i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width , channel), unit_height * unit_width, 1)) );
                end
                X_iter{i,j, channel} = ActivationFunction(X_iter{i,j, channel} , W{i,j, channel}, H{i,j, channel}) ;

                Im_output((i-1) * unit_height + 1:i * unit_height, (j-1) * unit_width + 1: j* unit_width, channel) = log( reshape(X_iter{i,j, channel},unit_height,unit_width)) / ( 1i * phi0) ;
            end
        end
    end

    figure();
    Im_output = real(Im_output) ;
    Im_output(Im_output < 0 ) = Im_output(Im_output < 0 ) + 256 ;

    Im_output_Cell{count} = uint8(Im_output);

    imshow(Im_output_Cell{count} );
end

