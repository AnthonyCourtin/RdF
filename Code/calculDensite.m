function [ nbPixNoir ] = calculDensite(im, xdeb, xfin, ydeb, yfin)
    
    nbPixNoir = 0; %initialisation
    
    for i= xdeb:xfin
        for j = ydeb:yfin
            if (im(i,j) == 0)
                %incremente le nombre de pixel noir
                nbPixNoir = nbPixNoir + 1; 
            end
        end
    end
end