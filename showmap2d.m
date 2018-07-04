function showmap2d(map,length)
len = length;
%zig = figure;
figure;
for i = 1:len
    for j = 1:len
            fig = reshape(map(:,i,j),[28,28]);
            subplot(len,len,(i-1)*len + j), image(fig);
            set(gca,'ytick',[])
            set(gca,'xtick',[])
    end
end
%saveas(zig,strcat('./pic/mnist',int2str(num),'.png'));
%close
end
