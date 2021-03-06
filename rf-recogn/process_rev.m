function process_rev
clc;

t = tic;
pic = imread('00249.png'); %image is 480x640x3, type of each element is uint8
[size1 size2 colors] = size(pic);

% ��������� �� �����
left_border = 80;
right_border = 70;
new_pic = pic(:,left_border:size2 - right_border,:);

% remove all dark spots
new_pic = color_dist(new_pic, size1 - 5, size2 - right_border - left_border - 10);
% [0..255]->[0..1]
new_pic = double(new_pic/255);
% ������� � �/�
pic_gray = GS(new_pic);
% ��������� ���������:
% img - ����������� � ������������, ����������� ��������
[ed_clust,N_elem,N_clust, img] = find_clusters(pic_gray);
%figure(1);imshow(new_pic);

% ����� ������
st=1;
figure(2)
for j=1:N_clust
    for i=1:N_elem(j)
        
        x=ed_clust{j}(1,i);
        y=ed_clust{j}(2,i);
        
        R(st)=new_pic(x,y,1);
        G(st)=new_pic(x,y,2);
        B(st)=new_pic(x,y,3);
    
        hold on;
        plot3(R(st),G(st),B(st),'.','Color',[R(st) G(st) B(st)]);
    
        st=st+1;
    end
end
axis([0 1 0 1 0 1]);

% ������ � ������� ������
color = ['g','b','m','r'];

% ������������ ������� ��������� ������
N_color{1}=[1 4 11]; %green
N_color{2}=[3 10]; %blue
N_color{3}=[2 5 6 7 9]; %pink
N_color{4}=[8]; %red


% ��������� ������ �������
[avg,list_color,npoint]=find_averages(ed_clust,N_elem,new_pic,N_color);
% �������� ������������ �����
final_rgb=get_clouds(list_color,npoint,avg);

figure(3);
% ������� ������
for k=1:4
    hold on;
    plot3(avg{k}(1),avg{k}(2),avg{k}(3),'.k');
end

%������� �����, ��������� ��������
for i=1:size(final_rgb,2)
    for j=1:size(final_rgb{i},1)
        hold on;
        plot3(final_rgb{i}(j,1),final_rgb{i}(j,2),final_rgb{i}(j,3),'.','Color',color(i));
    end
end


axis([0 1 0 1 0 1]);
disp(toc(t));
