function nmse = NMSE(Im_desired, Im_retrieved)
    % 列向量之差的平方和 除以 原来图像列向量的模的平方和
    nmse = sum( (double(Im_desired - Im_retrieved)).^2 )/ sum ( ( double(Im_desired)).^2 );
end