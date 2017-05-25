function s = linear_saturation(x)
    s = x ;
    s( s > 1 ) = 1 ;
    s( s < -1 ) = -1 ;
end