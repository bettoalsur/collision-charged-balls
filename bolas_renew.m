clear; clc; close all;

n = 3; %number of particles
K = 50; %constant for attractive force
E0 = 5*n; % kcinetic energy of the group

[prop,L,r] = create_balls(n);
E1 = sum(prop.vx.*prop.vx + prop.vy.*prop.vy) ; 
c = sqrt(E1/E0);
prop.vx = prop.vx/c; prop.vy = prop.vy/c;

dx = L*0.5/100;
dt = dx/sqrt(n);
tol = 1.01;

%creating index
I = []; J = [];
for i = 1:n-1
    for j = i+1 : n
        I = [ I ; i ]; J = [ J ; j ];
    end
end
IND = (J-1)*n + I ;
IB = prop.q < 0 ;
IR = prop.q > 0 ;

th = linspace(0,2*pi,16);
px = r*cos(th);
py = r*sin(th);
pxB = repmat(px,sum(IB),1);
pyB = repmat(py,sum(IB),1);
pxR = repmat(px,sum(IR),1);
pyR = repmat(py,sum(IR),1);

ax = zeros(n,n);
ay = zeros(n,n);
Q = prop.q(I).*prop.q(J);

cont = 1;
while cont > 0
    
cont = cont + 1;
    
dist_x = prop.x(I) - prop.x(J);
dist_y = prop.y(I) - prop.y(J);
dist = sqrt( dist_x.^2 + dist_y.^2 );

% index colliding
ind_cho = ( dist <= 2*r*tol );
dist_x(ind_cho) = 0;
dist_y(ind_cho) = 0;

aux = Q./( dist.^3 );
ax( IND ) = aux.*dist_x; prop.ax = K * sum( ax - ax' ,2);
ay( IND ) = aux.*dist_y; prop.ay = K * sum( ay - ay' ,2);

% handle collition
ind_cho = [I(ind_cho) J(ind_cho)];
for i = 1:size(ind_cho,1);
    prop = choque(prop,ind_cho(i,:),1);
end

% calculate position
aux_x = prop.ax*dt^2 + prop.vx*dt + prop.x;
aux_y = prop.ay*dt^2 + prop.vy*dt + prop.y;

ind_x = ( (aux_x <= r*tol) + (aux_x >= (L-r*tol) ) ) > 0;
ind_y = ( (aux_y <= r*tol) + (aux_y >= (L-r*tol) ) ) > 0;

aux_x(ind_x) = - prop.vx(ind_x)*dt + prop.x(ind_x);
aux_y(ind_y) = - prop.vy(ind_y)*dt + prop.y(ind_y);

% calculate velocity
prop.vx = ( aux_x - prop.x )/dt;
prop.vy = ( aux_y - prop.y )/dt;

% update information
prop.x = aux_x;
prop.y = aux_y;

% plot balls
bx = repmat(prop.x(IB),1,16) + pxB;
by = repmat(prop.y(IB),1,16) + pyB;
rx = repmat(prop.x(IR),1,16) + pxR;
ry = repmat(prop.y(IR),1,16) + pyR;

plot(bx',by','b',rx',ry','r');
axis equal;
axis([0 L 0 L]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
pause(1e-7);

if mod(cont,250) == 0
    E1 = sum(prop.vx.*prop.vx + prop.vy.*prop.vy) ; 
    c = sqrt(E1/E0);
    prop.vx = prop.vx/c; prop.vy = prop.vy/c;
end

end








