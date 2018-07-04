function o_cluster = pricluster(count,length,i_rate)
len = length;
cluster = zeros(len,len,len);
%matrix = zeros(len,len);
%matrix2 = zeros(len,len);
for i = 1:len
    for j = 1:len
        for k = 1:len
            [M,I] = max(count(i,j,k,:));
            rate = M / sum(count(i,j,k,:));
            %matrix(i,j) = rate;
            %matrix2(i,j) = sum(count(i,j,k,:));
            if(M == 0 || rate < i_rate)
                cluster(i,j,k) = 10;
            else
                cluster(i,j,k) = I - 1;
            end
        end
    end
end
%{
figure;
imagesc(matrix);
caxis([0.5 1]);
figure;
imagesc(matrix2);
caxis([0,200]);
%}
o_cluster = cluster;
end