function [ X ] = extraitProfils( im, d )
    [n, p] = size(im); % recuperation de la taille
    nbLignes = floor(d/2); % recuperation du nombre de ligne pour le profil
    X = zeros(d,1);
    k = floor(n/nbLignes);
%     l = floor(p/nbLignes);
    
%     if p<=nbLignes
%         l = 1;
%     end
    
% a chaque iteratioon, quand on ne rencontre pas de point noir, on
% incremente la distance
    for i=1:nbLignes 
        % parcours de la matrice de gauche a droite
        j = 1;
        while ((im(k,j) == 255) && (j <= p))
            j = j+1;
            X(i) = X(i)+1;
        end
        
        % parcours de la matrice de droite a gauche
        j = p;
        while ((im(k,j) == 255) && (j >= 1))
            j = j-1;
            X(i+floor(d/2)) = X(i+floor(d/2))+1;
        end
        
        k = k + floor(n/nbLignes);
    end
    X = X./p;
    
    % Recuperation profil haut et bas 
    % pb : rajoute des erreurs
%     for i=1:nbLignes 
%         % parcours de la matrice de gauche a droite
%         j = 1;
%         while ((im(j,l) == 255) && (j <= n))
%             j = j+1;
%             X(i+(floor(d/2)*2)) = X(i+(floor(d/2)*2))+1;
%         end
%         
%         % parcours de la matrice de droite a gauche
%         j = n;
%         while ((im(j,l) == 255) && (j >= 1))
%             j = j-1;
%             X(i+(floor(d/2)*3)) = X(i+(floor(d/2)*3))+1;
%         end
%         
%         l = l + floor(p/nbLignes);
%     end
%     tailleX = length(X);
%     X(1:tailleX/2) = X(1:tailleX/2)./p; % normalisation
%     X((tailleX/2)+1:end) = X((tailleX/2)+1:end)./n;
end

