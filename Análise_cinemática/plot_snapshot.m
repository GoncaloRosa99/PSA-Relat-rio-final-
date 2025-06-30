function plot_snapshot(Pp, theta)
% Plota o robô Delta em quatro vistas: 3D, XY, YZ, XZ
% Entrada:
%   Pp: posição da plataforma [x y z] (m)
%   theta: ângulos das juntas [theta1 theta2 theta3] (graus)

%% Parâmetros do robô
sB = 0.381;   % lado do triângulo da base
sP = 0.121;   % lado do triângulo da plataforma
L  = 0.164;   % braço superior
l  = 0.448;   % braço inferior
h  = 0.000;   % offset vertical (podes definir se necessário)   % comprimento dos braços inferiores (m)

% Conversão de graus para rad
theta = deg2rad(theta);

% Coordenadas dos pontos da base
wB = sB / (2 * tan(pi/3));
wP = sP / (2 * tan(pi/3));

% Vértices da base
V1 = [0, -wB, 0];
V2 = [ (sqrt(3)/2)*wB, 0.5*wB, 0];
V3 = [-(sqrt(3)/2)*wB, 0.5*wB, 0];

% Pontos de fixação dos braços (meios dos lados da base)
B1 = (V1 + V2)/2;
B2 = (V2 + V3)/2;
B3 = (V3 + V1)/2;

% Vértices da plataforma inferior
P1 = Pp + [0, -wP, 0];
P2 = Pp + [(sqrt(3)/2)*wP, 0.5*wP, 0];
P3 = Pp + [-(sqrt(3)/2)*wP, 0.5*wP, 0];

% Pontos dos cotovelos (braços superiores)
A1 = B1 + [0, -L*cos(theta(1)), -L*sin(theta(1))];
A2 = B2 + [sqrt(3)/2*L*cos(theta(2)), 0.5*L*cos(theta(2)), -L*sin(theta(2))];
A3 = B3 + [-sqrt(3)/2*L*cos(theta(3)), 0.5*L*cos(theta(3)), -L*sin(theta(3))];

% Inicializa a figura
figure('Name', 'Snapshot do Robô Delta');

% ---- Vista 3D ----
subplot(2,2,1);
plot_robot(V1,V2,V3,B1,B2,B3,A1,A2,A3,P1,P2,P3,Pp);
title('Vista 3D');
view(3);

% ---- Vista XY ----
subplot(2,2,2);
plot_robot(V1,V2,V3,B1,B2,B3,A1,A2,A3,P1,P2,P3,Pp);
title('Vista XY');
view(0,90);

% ---- Vista YZ ----
subplot(2,2,3);
plot_robot(V1,V2,V3,B1,B2,B3,A1,A2,A3,P1,P2,P3,Pp);
title('Vista YZ');
view(90,0);

% ---- Vista XZ ----
subplot(2,2,4);
plot_robot(V1,V2,V3,B1,B2,B3,A1,A2,A3,P1,P2,P3,Pp);
title('Vista XZ');
view(0,0);
end

function plot_robot(V1,V2,V3,B1,B2,B3,A1,A2,A3,P1,P2,P3,Pp)
% Desenha o robô Delta com os pontos dados
hold on; axis equal; grid on;
xlim([-1 1]); ylim([-1 1]); zlim([-1.5 0.5]);
xlabel('X'); ylabel('Y'); zlabel('Z');

% Triângulo da base (preto)
fill3([V1(1), V2(1), V3(1)], [V1(2), V2(2), V3(2)], [V1(3), V2(3), V3(3)], 'k', 'FaceAlpha',0.1);

% Braços superiores (verde)
plot3([B1(1) A1(1)], [B1(2) A1(2)], [B1(3) A1(3)], 'g', 'LineWidth', 2);
plot3([B2(1) A2(1)], [B2(2) A2(2)], [B2(3) A2(3)], 'g', 'LineWidth', 2);
plot3([B3(1) A3(1)], [B3(2) A3(2)], [B3(3) A3(3)], 'g', 'LineWidth', 2);

% Braços inferiores (azul)
plot3([A1(1) P1(1)], [A1(2) P1(2)], [A1(3) P1(3)], 'b');
plot3([A2(1) P2(1)], [A2(2) P2(2)], [A2(3) P2(3)], 'b');
plot3([A3(1) P3(1)], [A3(2) P3(2)], [A3(3) P3(3)], 'b');

% Plataforma (preta)
plot3([P1(1) P2(1) P3(1) P1(1)], [P1(2) P2(2) P3(2) P1(2)], [P1(3) P2(3) P3(3) P1(3)], 'k');

% Centro da plataforma
plot3(Pp(1), Pp(2), Pp(3), 'ko', 'MarkerFaceColor','k');
end
