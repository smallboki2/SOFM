
mapinit = randi([0 256],[21 21 21 3],'uint8');
mapinit(21,21,21,:) = [255 255 255];
mapinit(1,1,1,:) = [0 0 0];
mapinit(21,1,1,:) = [255 0 0];
mapinit(1,21,1,:) = [0 255 0];
mapinit(1,1,21,:) = [0 0 255];
mapinit(21,21,1,:) = [255 255 0];
mapinit(21,1,21,:) = [255 0 255];
mapinit(1,21,21,:) = [0 255 255];
map = mapinit;

pinput = randi([0 256], [100000 3],'uint8');
pinput(1,:) = [0 0 255];
pinput(2,:) = [51 51 255];
pinput(3,:) = [0 204 255];
pinput(4,:) = [0 153 255];
pinput(5,:) = [0 102 255];
pinput(6,:) = [51 102 255];
pinput(7,:) = [0 255 204];
pinput(8,:) = [0 255 255];
pinput(9,:) = [51 204 255];
pinput(10,:) = [51 153 255];
pinput(11,:) = [102 153 255];
pinput(12,:) = [102 102 255];
pinput(13,:) = [102 0 255];
pinput(14,:) = [0 255 153];
pinput(15,:) = [102 255 204];
pinput(16,:) = [102 255 255];
pinput(17,:) = [102 204 255];
pinput(18,:) = [153 204 255];
pinput(19,:) = [153 153 255];
pinput(20,:) = [153 102 255];
pinput(21,:) = [153 51 255];
pinput(22,:) = [153 0 255];
pinput(23,:) = [0 255 0];
pinput(24,:) = [102 255 153];
pinput(25,:) = [153 255 204];
pinput(26,:) = [204 255 255];
pinput(27,:) = [204 204 255];
pinput(28,:) = [204 153 255];
pinput(29,:) = [204 102 255];
pinput(30,:) = [204 51 255];
pinput(31,:) = [204 0 255];
pinput(32,:) = [102 255 102];
pinput(33,:) = [153 255 153];
pinput(34,:) = [204 255 204];
pinput(35,:) = [255 255 255];
pinput(36,:) = [255 204 255];
pinput(37,:) = [255 153 255];
pinput(38,:) = [255 102 255];
pinput(39,:) = [255 0 255];
pinput(40,:) = [102 255 51];
pinput(41,:) = [153 255 102];
pinput(42,:) = [255 255 204];
pinput(43,:) = [255 204 204];
pinput(44,:) = [255 153 204];
pinput(45,:) = [255 102 204];
pinput(46,:) = [255 51 204];
pinput(47,:) = [153 255 51];
pinput(48,:) = [255 255 153];
pinput(49,:) = [255 204 153];
pinput(50,:) = [255 153 153];
pinput(51,:) = [255 102 153];
pinput(52,:) = [255 51 153];
pinput(53,:) = [204 255 51];
pinput(54,:) = [255 255 102];
pinput(55,:) = [255 204 102];
pinput(56,:) = [255 153 102];
pinput(57,:) = [255 102 102];
pinput(58,:) = [255 0 102];
pinput(59,:) = [255 255 0];
pinput(60,:) = [255 204 0];
pinput(61,:) = [255 153 51];
pinput(62,:) = [255 102 0];
pinput(63,:) = [255 80 80];
pinput(64,:) = [255 153 0];
pinput(65,:) = [255 51 0];
pinput(66,:) = [255 0 0];
pinput(67,:) = [255 255 255];
pinput(68,:) = [0 0 0];

x = 0;
y = 0;
%}
mindis = 0;
nupdate = 0;

%%%%%
nitr = 20;
r0 = 10;
l0 = 0.3;
step = int32(3276);%1/nitr;
step2 = int32(1796);%floor(l0 * 0.9 / r0 * 65536) / 65536;
alpha0 = int32(983);%floor(l0/nitr*65536)/65536;
rt0 = 0.7;
rt1 = 0.8;
rt2 = rt0/rt1;
rediusarr = zeros(nitr,1);
distribute = zeros(nitr*100,2);
idx = randperm(68);
input = pinput;%zeros(68,3);
%{
for rdi = 1:68
    input(rdi,:) = pinput(idx(rdi),:);
end
%}
noad = zeros(3,1);
nowb = 0;
tic;
for itr = 1:nitr
    rate = 65536 - step * (itr - 1);%linear version
    redius = floor(double(r0 * rate) / double(65536));%32 * exp(-(i-1)/lamda);
    %redius = r0 * rt1^(itr - 1);
    %rediusarr(itr) = redius;
for i = 69:1069
    lrate =  l0 * rate;%exp(-(i-1)/lamda2);
    x = 0;
    y = 0;
    z = 0;
    for j = 1:21
        for k = 1:21
            for l = 1:21
                dis = 0;
                for n = 1:3
                    if(map(j,k,l,n) > input(i,n))
                        dis = dis + uint16(map(j,k,l,n) - input(i,n));
                    else
                        dis = dis + uint16(input(i,n) - map(j,k,l,n));
                    end
                end
                if(j == 1 && k == 1 && l == 1)
                    x = 1;
                    y = 1;
                    z = 1;
                    mindis = dis;
                else
                    if(dis < mindis)
                        x = j;
                        y = k;
                        z = l;
                        mindis = dis;
                    end
                end
            end
        end
    end
    for j = 1:21
        for k = 1:21
            for l = 1:21
                if((j == 1 && k == 1 && l == 1) || (j == 21 && k == 1 && l == 1) || (j == 1 && k == 21 && l == 1) || (j == 1 && k == 1 && l == 21) || (j == 1 && k == 21 && l == 21) || (j == 21 && k == 1 && l == 21) || (j == 21 && k == 21 && l == 1) || (j == 21 && k == 21 && l == 21))
                    continue;
                end
                xx = abs(j - x);%min(abs(j - x), 100 - abs(j - x));%
                yy = abs(k - y);%min(abs(k - y), 100 - abs(k - y));%
                zz = abs(l - z);
                if(xx <= redius && yy <= redius && zz <= redius)
                    nupdate = nupdate + 1;
                    distance = int32(max(max(xx,yy),zz));
                    alpha = alpha0 * (nitr - itr + 1)  - distance * step2;
                    qqd = 0;
                    for n = 1:3
                        if(input(i,n) > map(j,k,l,n))
                            move = input(i,n) - map(j,k,l,n);
                            nmap = int32(map(j,k,l,n)) * 65536 + alpha * int32(move);
                            qqd = round(double(nmap) / double(65536));%idivide(nmap,65536,'floor');
                            map(j,k,l,n) = qqd;%idivide(nmap,65536,'floor');
                        else
                            move = map(j,k,l,n) - input(i,n);
                            nmap = int32(map(j,k,l,n)) * 65536 - alpha * int32(move);
                            qqd = round(double(nmap) / double(65536));%idivide(nmap,65536,'floor');
                            map(j,k,l,n) = qqd;%idivide(nmap,65536,'floor');
                        end
                    end
                end
            end
        end
    end

end

end
for i = 1:21
    figure;
    layer = reshape(map(:,:,i,:),[21,21,3]); 
    image(layer);
    set(gca,'visible','off');
end
toc;