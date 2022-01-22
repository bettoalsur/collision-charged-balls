function [prop]=choque(prop,idex,p)

x = prop.x(idex);
y = prop.y(idex);

v = [prop.vx(idex)' ; prop.vy(idex)' ];

phi = [diff(x) diff(y)];
phi = -phi/norm(phi);

A = [phi(1) phi(2); phi(2) -phi(1)];
v = A*v;

E =  v(1,1)^2 + v(1,2)^2 ;
C = v(1,1) + v(1,2) ;

E = E*p; C = C*p;

v(1,1) = C/2 + sqrt( 2*E - C*C )/2;
v(1,2) = C - v(1,1);

v = A\v;

prop.vx(idex) = v(1,:); 
prop.vy(idex) = v(2,:);

end
