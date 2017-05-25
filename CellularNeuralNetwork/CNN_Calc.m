function [x_output, s_output] = CNN_Calc(AB, C, D, V, U, x_input, s_input)
    x_output = (1 - C) * x_input + AB * s_input + D * U + V ;
    s_output = linear_saturation(x_output);
    %ShowImage(reshape(s_output, 5, 5));
end