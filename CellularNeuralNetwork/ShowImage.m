function ShowImage(Img_Matrix)
    [row , column] = size(Img_Matrix);
    figure_Matrix = uint8(zeros(100 * row, 100 * column));
    for i = 1:1:row
        for j = 1:1:column
            temp =  uint8((Img_Matrix(i,j) + 1) * 127.5 );
            figure_Matrix(((i-1) * 100 + 1) : (i * 100)  ,(j-1) * 100 + 1 : j * 100 ) = temp ; 
        end
    end
    figure();
    imshow(figure_Matrix);  
end