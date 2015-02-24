%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Squelette de programme pour tp de reco de formes 	%%%%%
%%%%%   Cl�ment Chatelain          janvier 2013		%%%%%
%%%%%   D�partement ASI - INSA de Rouen 		%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%% apprentissage %%%%%%%%%%%%%%%%%%%%%%%%%
im = imread('app.tif'); % lecture fichier image d'apprentissage
taille = 22; % nombre de ligne pour le profil
coordImages = extractionImages(im); 
nbImageBaseApp = length(coordImages);
sprintf('APPRENTISSAGE detection images OK : %d images detect�es\n', nbImageBaseApp);

profils = zeros(taille, nbImageBaseApp);
labels = zeros(nbImageBaseApp,1);
densites = zeros(5*5,nbImageBaseApp);
tic;
for (iImage=1 : nbImageBaseApp)
    iImage;
    % localisation et extraction des imagettes
    largeur = coordImages(iImage, 2) - coordImages(iImage, 1) - 2;
    hauteur = coordImages(iImage, 4) - coordImages(iImage, 3) - 2;
    x0 = coordImages(iImage, 1);
    y0 = coordImages(iImage, 3);
    imageChiffre = subimage(im, largeur, hauteur, x0, y0);
  
    % crop (supprimer les bords blancs)
    imageChiffreCroppee = crop(imageChiffre);    
    imagesc(imageChiffreCroppee); %afficher les imagettes de chiffres    
    
    %%%%%% ICI c'est � vous de Jouer !!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % extraire des caract�ristiques ...
    profils(:,iImage) = extraitProfils(imageChiffreCroppee,taille);
    densites(:,iImage) = extraitDensites(imageChiffreCroppee,5);
    
    % Astuce : la classe de l'image courante est donn�e par : iClasse = fix((iImage-1)/20)
    sprintf('classe de l image %d : %d\n', iImage, fix((iImage-1)/20))
    labels(iImage) = fix((iImage-1)/20);
    
end
time = toc;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% decision %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear all;

imTest = imread('test.tif'); % lecture fichier image test
coordImagesTest = extractionImages(imTest);
length(coordImagesTest);
nbImageBaseTest = length(coordImagesTest);
profilsTest = zeros(taille, nbImageBaseTest);
densitesTest = zeros(25,nbImageBaseTest);
tic;
for (iImage=1 : nbImageBaseTest)
    largeur = coordImagesTest(iImage, 2) - coordImagesTest(iImage, 1) - 2;
    hauteur = coordImagesTest(iImage, 4) - coordImagesTest(iImage, 3) - 2;
    
    % extraction image
    imageChiffre = subimage(imTest, largeur, hauteur, coordImagesTest(iImage, 1), coordImagesTest(iImage, 3));
    
    % crop
    imageChiffreCroppee = crop(imageChiffre);    
    imagesc(imageChiffreCroppee); %afficher les imagettes de chiffres
    
    %%%%%% ICI c'est � vous de Jouer !!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % appliquer le mod�le sauvegard� sur les chiffres de l'image de test ...
    profilsTest(:,iImage) = extraitProfils(imageChiffreCroppee,taille);
    densitesTest(:,iImage) = extraitDensites(imageChiffreCroppee,5);
    [YPeval,MatDist] = kppv(profilsTest(:,iImage)', profils', labels, 1, []);
    [YPeval2,MatDist2] = kppv(densitesTest(:,iImage)', densites', labels, 1, []);
    resultatProfils(iImage) = YPeval;
    resultatDensites(iImage) = YPeval2;
end
timeTest = toc;

%%%%%%%%% Calcul des performances %%%%%%%

%%%%%%%%Erreur%%%%%%%%%
%creation du vecteur des labels
j = 10;
for k=0:9
    labelTest(j-9:j) = k;
    j = j + 10;
end

erreurProfils = 0;
for i= 1:nbImageBaseTest
    if resultatProfils(i) ~= labelTest(i)
        erreurProfils = erreurProfils + 1;
    end
end

erreurProfils = erreurProfils/nbImageBaseTest;
sprintf('Erreur en pourcentage Profils : %f',erreurProfils*100)

erreurDensites = 0;
for i= 1:nbImageBaseTest
    if resultatDensites(i) ~= labelTest(i)
        erreurDensites = erreurDensites + 1;
    end
end

erreurDensites = erreurDensites/nbImageBaseTest;
sprintf('Erreur en pourcentage Densites : %f',erreurDensites*100)

%%%%%%%%%%%%%% Temps de calcul %%%%%%%%%%%%%%%%
sprintf('Temps de calcul pour apprentissage : %f',time)
sprintf('Temps de calcul pour test : %f',timeTest)


%%%%%%%%%%%%%% Matrice de confusion %%%%%%%%%%%%%%%%

matConfProfils = zeros(10,10); %creation de la matrice de confusion

for i = 0:9
    k = find(labelTest==i);
    for j = 0:9
        matConfProfils(i+1,j+1) = calculMatConf(i,j,resultatProfils,labelTest,k);
    end
end

matConfProfils = matConfProfils./10; % normalisation
disp('Matrice Confusion Profils')
disp('-----------------------------------------------------------------------------------------------------')
disp(matConfProfils) % affichage de la matrice de confusion

matConfDensites = zeros(10,10); %creation de la matrice de confusion

for i = 0:9
    k = find(labelTest==i);
    for j = 0:9
        matConfDensites(i+1,j+1) = calculMatConf(i,j,resultatDensites,labelTest,k);
    end
end
disp('Matrice Confusion Densites')
disp('-----------------------------------------------------------------------------------------------------')
matConfDensites = matConfDensites./10; % normalisation
disp(matConfDensites) % affichage de la matrice de confusion