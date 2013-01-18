function mrQ_fitT1PD_SGE(opt,jumpindex,jobindex)
%
% Perform the T1 and PD fitting using the SGE
%
% mrQ_fitT1PD_SGE(opt,jumpindex,jobindex)
%
% Saves: 'res','resnorm','st','ed'
%    TO: [opt.outDir opt.name '_' num2str(st) '_' num2str(ed)]
%
% See Also:
%   mrQ_fitT1M0.m, mrQ_fitT1PD_LSQ.m
%

%%

% Set the maximum number of computational threads avaiable to Matlab
%maxnumcompthreads(1)

j  = 0;
st = 1 +(jobindex-1)*jumpindex;
ed = st+jumpindex-1;

if ed>length(opt.wh)
    ed = length(opt.wh);
end

%%
a=version('-date');
if str2num(a(end-3:end))==2012
    options = optimset('Algorithm', 'levenberg-marquardt','Display', 'off','Tolx',1e-12);
else
    options =  optimset('LevenbergMarquardt','on','Display', 'off','Tolx',1e-12);%'TolF',1e-12
    
end
%options =  optimset('LevenbergMarquardt','on','Display', 'off','Tolx',1e-12,'TolF',1e-12);

for i= st:ed,
    j=j+1;
    if find(isnan(opt.s(i,:)));
        res(1:length(opt.x0(i,:)),j)=nan;resnorm(j)=nan;
        
    else
        [res(:,j), resnorm(j)] = lsqnonlin(@(par) errT1PD(par,opt.flipAngles,opt.tr,opt.s(i,:),opt.Gain(i),opt.B1(i),1,[]),opt.x0(i,:),opt.lb,opt.ub,options);
    end
end

%%

name = [opt.outDir opt.name '_' num2str(st) '_' num2str(ed)];
save(name,'res','resnorm','st','ed')
