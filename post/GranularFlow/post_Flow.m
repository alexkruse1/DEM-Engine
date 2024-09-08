clear;close all;clc

%%% Experimental data from Sarno et al. 2018
exp=readtable("../../data/granularFlow/heightSarno2018.dat");


folder=['../' ...
    '../build/DemoOutput_Granular/Hopper_shute/1/'];
files=dir(folder);


dx=0.0033*1;
pathX=(0.93:dx:0.97)';
pathY=(-0.04:dx:0.04)';

[X,Y] = meshgrid(pathX,pathY);
Z=X*0;


Y_idx = find(pathX >= 0.95, 1, 'first');  

curve1_y=Y(Y_idx,:);
time=(0:0.01:7)';
level_z=zeros(numel(time),1);

for i=50:300
    file=['DEMdemo_output_' num2str(i,'%04i.csv')];
    disp(file)
    data=readtable([folder file]);
    x=data.X;
    y=data.Y;
    z=data.Z+data.r;

    index=find(x>0.93 & x<0.97);
    vec=z(index);
    x=x(index);
    y=y(index);
    z=z(index);
    
    tempMin=0.0;
    if numel(index)>1
        % a=sort(vec,'descend');
        % value=mean(vec)+1.96*std(vec);
        % disp(value)
        range=dx*3;
        for j=1:numel(pathX)
            for k=1:numel(pathY)
                xLocal=X(k,j);
                ylocal=Y(k,j);
                index=find(abs(x-xLocal)<range & abs(y-ylocal)<range);
                
                if ~isempty(index)
                    temp=abs(max(z(index)));
                    tempMin=abs(min(z(index)))-1*0.0033;
                    Z(k,j)=temp;
                end
            end
        end
    end
    
% surf(X,Y,Z)
 curve1_z=sgolayfilt(Z(:,Y_idx),3,15);
 figure(1); hold on
  plot(curve1_z,Color=[1 1 1]*0.9)
  drawnow
 disp([num2str(mean(curve1_z),'%1.3f') ' ' num2str(tempMin,'%1.3f')])
 if numel(curve1_z)>0
     level_z(i)=mean(curve1_z);
 end
end


figure(2); hold on

plot(time,level_z,'DisplayName','DEME')
plot(exp.Var1,exp.Var2,'DisplayName','Exp.')

axis([0 14 0 0.06])
