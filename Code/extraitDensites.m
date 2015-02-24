function [ yfinal ] = extraitDensites( im, d )
    [n,m] = size(im);
    xdeb = 1;
    xfin = floor(n/d);
    ydeb = 1;
    yfin = floor(m/d);
    
    for i=1:d
        for j=1:d 
           Y(i,j) = calculDensite(im,xdeb,xfin,ydeb,yfin);
           Y(i,j) = Y(i,j) ./ ((xfin-xdeb)*(yfin-ydeb)); %normalisation
           ydeb = ydeb + floor(m/d); %modification des bornes
           yfin = yfin + floor(m/d);
        end
        xdeb = xdeb + floor(n/d);
        xfin = xfin + floor(n/d);
        ydeb = 1;
        yfin = floor(m/d);
    end
    fin = d*d;
    yfinal = zeros(d*d,1);
    col = 1;
    for i=0:5:fin-d
        yfinal(i+1:i+d) = Y(:,col);
        col = col + 1;
    end
end

