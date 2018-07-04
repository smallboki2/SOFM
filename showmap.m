function showmap(map,length)
len = length;
%zig = figure;
for i = 1:len
    figure;
    for j = 1:len
        for k = 1:len
            fig = reshape(map(:,i,j,k),[28,28]);
            subplot(len,len,(j-1)*len + k), image(fig);
            set(gca,'ytick',[])
            set(gca,'xtick',[])
        end
    end
end
%saveas(zig,strcat('./pic/mnist',int2str(num),'.png'));
%close
end
