function [o_map,o_count,n_update] = sofmnist(lo,slope,zrate,iteration,len,mapinit)
load('mnist.mat');
map = mapinit;%randi([0 255], [784 len len]);
count = zeros(len,len,len,10);
dim = 784;
itr = iteration;
r0 = len/2;
l0 = lo;
step = 1/itr;
step2 = l0 * slope / r0;
input = 60000;
n_update = 0;
%train
vecs = reshape(training.images,[784 60000]);
vecs = round(vecs * 255);

for i = 1:itr
    disp(i);
    %tic;
    rate = 1 - step * (i - 1);
    zzrate = 1 - step * (i - 1)/zrate;
    radius = r0 * rate;
    lrate =  l0 * zzrate;
    for j = 1:input
        hitmap = zeros(len*len*len,1);
        %winner
        mindis = 0;
        minx = 1;
        miny = 1;
        minz = 1;
        %ivec = round(training.images(:,:,j) * 255);
        ivec = vecs(:,j);
        for x = 1:len
            for y = 1:len
                for z = 1:len
                    ndis = norm(map(:,x,y,z) - ivec);
                    if(x == 1 && y == 1 && z == 1)
                        mindis = ndis;
                    end
                    if(ndis < mindis)
                        mindis = ndis;
                        minx = x;
                        miny = y;
                        minz = z;
                    end
                end
            end
        end
        %update
        for x = 1:len
            for y = 1:len
                for z = 1:len
                    xx = abs(x - minx);%min(abs(x - minx),len - abs(x - minx));%
                    yy = abs(y - miny);%min(abs(y - miny),len - abs(y - miny));%
                    zz = abs(z - minz);
                    if(xx <= radius && yy <= radius && zz <= radius)
                        distance = max(max(xx,yy),zz);
                        alpha = lrate * (1 - distance * slope / radius);
                        map(:,x,y,z) = map(:,x,y,z) - alpha * (map(:,x,y,z) - ivec);
                        hitmap(x + (y-1)*10 + (z-1)*100) = 1;
                    end
                end
            end
        end
        
        for pos = 1:8:993
            if(sum(hitmap(pos:pos+7)) > 0)
                n_update = n_update + 1;
            end
        end
        %}
        %{
        if(mod(j,6000) == 0)
            fig = zeros(840,840);
            for iii = 1:30
                for jjj = 1:30
                    zzz = reshape(map(:,iii,jjj),[28,28]);
                    fig((iii-1)*28+1:iii*28,(jjj-1)*28+1:jjj*28) = zzz;
                end
            end
            F = figure;
            image(fig);
            set(gca,'ytick',[])
            set(gca,'xtick',[])
            saveas(F,strcat('./pic/mnist',int2str((i-1)*10+j/6000),'.png'));
            close;
        end
        %}
    end
%figure;
%{
for x = 1:len
    for y = 1:len
        fig = reshape(map(:,x,y),[28,28]);
        subplot(len,len,(x-1)*len + y), image(fig);
        set(gca,'ytick',[])
        set(gca,'xtick',[])
    end
end
%}
%toc;
end
for i = 1:input
        mindis = 0;
        minx = 1;
        miny = 1;
        minz = 1;
        ivec = round(training.images(:,:,i) * 255);
        ivec = ivec(:);
        for x = 1:len
            for y = 1:len
                for z = 1:len
                    ndis = norm(map(:,x,y,z) - ivec);
                    if(x == 1 && y == 1 && z == 1)
                        mindis = ndis;
                    end
                    if(ndis < mindis)
                        mindis = ndis;
                        minx = x;
                        miny = y;
                        minz = z;
                    end
                end
            end
        end
   count(minx,miny,minz,training.labels(i)+1) = count(minx,miny,minz,training.labels(i)+1) + 1;
end

o_map = map;
o_count = count;
end