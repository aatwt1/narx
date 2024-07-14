P= out_narx(:, 1);
T = out_narx(:, 2);
 
vel = length(P);
 
minulaz = min(P); 
maxulaz = max(P); 
minizlaz = min(T); 
maxizlaz = max(T);
 
% normiranje ulaza i izlaza na opseg [-1, 1]
p= 2 * (P - minulaz) ./ (maxulaz - minulaz) - 1;
t = 2 * (T - minizlaz) ./ (maxizlaz - minizlaz) - 1;
 
N=4;
 
p=p;
t=t;
 
for k = N+1 : vel
    t1 = flipud( t(k-N:k-1) );
    p1 = flipud( p(k-N:k-1) );
    ulaz(:,k) = [t1; p1];
    izlaz(k) = t(k)';
end
 
ulaz
izlaz
 
net = newff([-1 1;-1 1;-1 1;-1 1;-1 1;-1 1;-1 1;-1 1],[15 1],{'tansig', 'purelin'}, 'trainlm');
 
net.trainParam.epochs = 2000;
net.trainParam.goal = 2e-4;
net.trainParam.show = 300;
net.trainParam.time = Inf;
net.performFcn='sse';
 
% Treniranje...
fprintf('Po?etak treniranja\n');
tic
net = train(net, ulaz, izlaz);
toc
 
izlaz=sim(net,ulaz);
izlaz=(izlaz+1)*(maxizlaz-minizlaz)./2 +minizlaz;
 
figure
subplot(2,1,1),plot(una_narx(:,1));
title('Izlazni podaci iz sistema');
xlabel('uzorci')
ylabel('amplituda')
subplot(2,1,2),plot(izlaz,'r')
title('Podaci dobiveni sa treniranom mrežom');
xlabel('uzorci')
ylabel('amplituda')
gensim(net)
