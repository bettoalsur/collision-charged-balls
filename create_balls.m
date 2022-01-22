function [prop,L,r] = create_balls(n)

L = 10;
d = 1; r = d/2;

if floor(n*d/L) >= 1 
    L = ( floor(n*d/L) + 1 )*L ;
end

mesh.size = 70;
tol = 1.03;
mesh.xc = repmat(linspace(r*tol,L-r*tol,mesh.size),1,mesh.size)';
mesh.yc = reshape(repmat(linspace(r*tol,L-r*tol,mesh.size),mesh.size,1),mesh.size*mesh.size,1);

mesh.list = (1:mesh.size*mesh.size)';
mesh.aval = ones(size(mesh.list));

%position
prop.x = [];
prop.y = [];

for i = 1:n

aux_list = mesh.list(mesh.aval==1);
id = randi([1 size(aux_list,1)],1);
id = aux_list(id);

aux_x = mesh.xc(id); aux_y = mesh.yc(id); 
prop.x = [prop.x ; aux_x];
prop.y = [prop.y ; aux_y];

mesh.aval( sqrt( (mesh.xc - aux_x).^2 + (mesh.yc - aux_y).^2 ) <= d*tol ) = 0;

end

%velocity
prop.vx = rand(n,1)*2-1;
prop.vy = rand(n,1)*2-1;

%charge
prop.q = (-1).^randi([1 2],n,1);

%cor to draw
% str1 = num2str(zeros(n,1),'%d');
% str2 = num2str(zeros(n,1),'%d');
% str1(prop.q>0) = '+'; str2(prop.q>0) = 'r'; 
% str1(prop.q<0) = 's'; str2(prop.q<0) = 'b'; 
% prop.str=[str1 str2];




