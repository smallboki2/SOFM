function [accuracy, o_matrix] = sofmnistest(cluster,map, length)
load('mnist.mat')
acc = 0;
matrix = zeros(10,10);
len = length;
vecs = reshape(test.images,[784 10000]);
vecs = round(vecs * 255);
for num = 0:9
distri = zeros(len,len,len);
ii = 0;
for i = 1:10000
    ilabel = test.labels(i);
    if(~(ilabel == num))
        continue;
    end
    ii = ii + 1;
    mindis = 0;
    ivec = vecs(:,i);
    minx = 1;
    miny = 1;
    minz = 1;
    first = 1;
    for x = 1:len
        for y = 1:len
            for z = 1:len
                if(cluster(x,y,z) == 10)
                    continue;
                end
                ndis = norm(map(:,x,y,z)-ivec);
                if(first == 1)
                    mindis = ndis;
                    minx = x;
                    miny = y;
                    minz = z;
                    first = 0;
                end
                if(ndis < mindis)
                    mindis = ndis;
                    minx = x;
                    miny = y;
                    minz = z;
                end
            %disp([x,y]);
            end
        end
    end
    %disp([minx,miny,num,cluster(minx,miny)]);
    matrix(num + 1,cluster(minx,miny,minz)+1) = matrix(num + 1,cluster(minx,miny,minz)+1) + 1;
    if(ilabel == cluster(minx,miny,minz))
        acc = acc + 1/10000;
    end
    if(ilabel ~= cluster(minx,miny,minz))
        distri(minx,miny,minz) = distri(minx,miny,minz) + 1;
    end
end
%{
figure;
imagesc(distri);
caxis([0 10]);
colormap jet
%}
end
disp(acc);
for i = 1:10
    matrix(i,:) =matrix(i,:) / sum(matrix(i,:));
end
figure;
imagesc(matrix);
caxis([0 0.5]);
colormap default;
accuracy = acc;
o_matrix = matrix;
end