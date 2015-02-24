function [ coef ] = calculMatConf( i,j,resultat,labelTest,k )
    n = size(resultat,1);
    coef = 0; % initialiser la valeur a zero
    
    for l =1:10
        if (resultat(k(l)) == j) % on compare les valeurs
            coef = coef +1;
        end
    end


end

