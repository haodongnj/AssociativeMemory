function [ s ] = ActivationFunction( x , w, h)
    K = 256 ;
    phi0 = 2 * pi / 256 ;
    z = exp(phi0 * 1i) ;
    z_half = exp(phi0 * 1i / 2) ;
    
    input = ( w * x + h ) * z_half ;
    s = complex( zeros(size(x)) );
    
    for count = 1 :1: size(s)
        angle_input = angle(input(count) );
        if( angle_input >= 0)
            for j = 1:K
                if( (angle_input >= (j-1) * phi0) && (angle_input < j * phi0 ))
                    s(count) = z^(j-1);
                end
            end
        else 
             for j = 1:K
                if(( ( angle_input + 2 * pi) >= (j-1) * phi0) && ((angle_input + 2 * pi )< j * phi0 ))
                    s(count) = z^(j-1);
                end
             end
        end
    end
end