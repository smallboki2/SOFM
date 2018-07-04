
mapinit = randi([0 256],[100 100 3],'uint8');
mapinit(1,1,:) = [255 0 0];
mapinit(67,1,:) = [255 255 0];
mapinit(100,34,:) = [0 255 0];
mapinit(100,100,:) = [0 255 255];
mapinit(67,100,:) = [0 0 255];
mapinit(1,67,:) = [255 0 255];

map = mapinit;

%figure;
%image(map);
input = randi([0 256], [100000 3],'uint8');
input(1,:) = [0 0 255];
input(2,:) = [51 51 255];
input(3,:) = [0 204 255];
input(4,:) = [0 153 255];
input(5,:) = [0 102 255];
input(6,:) = [51 102 255];
input(7,:) = [0 255 204];
input(8,:) = [0 255 255];
input(9,:) = [51 204 255];
input(10,:) = [51 153 255];
input(11,:) = [102 153 255];
input(12,:) = [102 102 255];
input(13,:) = [102 0 255];
input(14,:) = [0 255 153];
input(15,:) = [102 255 204];
input(16,:) = [102 255 255];
input(17,:) = [102 204 255];
input(18,:) = [153 204 255];
input(19,:) = [153 153 255];
input(20,:) = [153 102 255];
input(21,:) = [153 51 255];
input(22,:) = [153 0 255];
input(23,:) = [0 255 0];
input(24,:) = [102 255 153];
input(25,:) = [153 255 204];
input(26,:) = [204 255 255];
input(27,:) = [204 204 255];
input(28,:) = [204 153 255];
input(29,:) = [204 102 255];
input(30,:) = [204 51 255];
input(31,:) = [204 0 255];
input(32,:) = [102 255 102];
input(33,:) = [153 255 153];
input(34,:) = [204 255 204];
input(35,:) = [255 255 255];
input(36,:) = [255 204 255];
input(37,:) = [255 153 255];
input(38,:) = [255 102 255];
input(39,:) = [255 0 255];
input(40,:) = [102 255 51];
input(41,:) = [153 255 102];
input(42,:) = [255 255 204];
input(43,:) = [255 204 204];
input(44,:) = [255 153 204];
input(45,:) = [255 102 204];
input(46,:) = [255 51 204];
input(47,:) = [153 255 51];
input(48,:) = [255 255 153];
input(49,:) = [255 204 153];
input(50,:) = [255 153 153];
input(51,:) = [255 102 153];
input(52,:) = [255 51 153];
input(53,:) = [204 255 51];
input(54,:) = [255 255 102];
input(55,:) = [255 204 102];
input(56,:) = [255 153 102];
input(57,:) = [255 102 102];
input(58,:) = [255 0 102];
input(59,:) = [255 255 0];
input(60,:) = [255 204 0];
input(61,:) = [255 153 51];
input(62,:) = [255 102 0];
input(63,:) = [255 80 80];
input(64,:) = [255 153 0];
input(65,:) = [255 51 0];
input(66,:) = [255 0 0];
for i = 67:70
    input(i,:) = [255 255 255];
end

x = 0;
y = 0;
%}
mindis = 0;
nupdate = 0;

%%%%%
nitr = 20;
r0 = 50;
l0 = 0.3;
step = int32(3276);%1/nitr;
step2 = int32(353);%floor(l0 * 0.9 / r0 * 65536) / 65536;
alpha0 = int32(983);%floor(l0/nitr*65536)/65536;
rt0 = 0.7;
rt1 = 0.8;
rt2 = rt0/rt1;
rediusarr = zeros(nitr,1);
distribute = zeros(nitr*100,2);
idx = randperm(70);
noad = zeros(3,1);
nowb = 0;
tic;
for itr = 1:nitr
    rate = 65536 - step * (itr - 1);%linear version
    redius = floor(double(r0 * rate) / double(65536));%32 * exp(-(i-1)/lamda);
    %redius = r0 * rt1^(itr - 1);
    %rediusarr(itr) = redius;
for i = 1:67
    lrate =  l0 * rate;%exp(-(i-1)/lamda2);
    x = 0;
    y = 0;
    for k = 1:100
        for j = 1:100
            dis = 0;
            for n = 1:3
                if(map(j,k,n) > input(idx(i),n))
                    dis = dis + uint16(map(j,k,n) - input(idx(i),n));
                else
                    dis = dis + uint16(input(idx(i),n) - map(j,k,n));
                end
            end
            if(j == 1 && k == 1)
                x = 1;
                y = 1;
                mindis = dis;
            else
                if(dis < mindis)
                    x = j;
                    y = k;
                    mindis = dis;
                end
            end
        end
    end
    for k = 1:100
        for j = 1:100
            if((j == 1 && k == 1) || (j == 67 && k == 1) || (j == 100 && k == 34) || (j == 100 && k == 100)||(k == 67 && j == 1)||(j == 100 && k == 100))
                noad = noad + 1;
                continue;
            end
            xx = abs(j - x);%min(abs(j - x), 100 - abs(j - x));%
            yy = abs(k - y);%min(abs(k - y), 100 - abs(k - y));%
            
            if(xx <= redius && yy <= redius)
                nupdate = nupdate + 1;
                distance = int32(max(xx,yy));
                alpha = alpha0 * (nitr - itr + 1)  - distance * step2;
                qqd = 0;
                for l = 1:3
                    if(input(idx(i),l) > map(j,k,l))
                        move = input(idx(i),l) - map(j,k,l);
                        nmap = int32(map(j,k,l)) * 65536 + alpha * int32(move);
                        qqd = round(double(nmap) / double(65536));%idivide(nmap,65536,'floor');
                        if(qqd == map(j,k,l))
                            noad(l) = noad(l) + 1;
                        end
                        map(j,k,l) = qqd;%idivide(nmap,65536,'floor');
                    else
                        move = map(j,k,l) - input(idx(i),l);
                        nmap = int32(map(j,k,l)) * 65536 - alpha * int32(move);
                        qqd = round(double(nmap) / double(65536));%idivide(nmap,65536,'floor');
                        if(qqd == map(j,k,l))
                            noad(l) = noad(l) + 1;
                        end
                        map(j,k,l) = qqd;%idivide(nmap,65536,'floor');
                    end
                end
            end
        end
    end

end
%input = fliplr(input);

end
    %fig = figure;
    figure;
    %image(map2);
    %figure;
    image(map);
    set(gca,'visible','off');
    %saveas(fig,strcat('zz',int2str(itr),'.png'));
    %close;
toc;