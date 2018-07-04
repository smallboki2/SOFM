    len = 10;
    mapinit = randi([0 255], [784 len len len]); 
    %for lr = 0.5:0.05:0.9
    tic;
    [map4,count4,nupdate] = sofmnist(0.3,0.9,1,30,len,mapinit);
    toc;
    pclu = pricluster(count4,len,0.8);
    [acc,matrix]= sofmnistest(pclu,map4,len);