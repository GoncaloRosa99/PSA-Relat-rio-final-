function Pp = Direta_Delta(theta)
    % Direta_Delta: calcula a posição da plataforma (Pp) dado os ângulos das juntas (theta)
    % Entrada: theta = [theta1 theta2 theta3] em graus
    % Saída: Pp = [x y z] posição da plataforma móvel (em metros)

    %% Parâmetros geométricos do robô
sB = 0.381;   % lado do triângulo da base
sP = 0.121;   % lado do triângulo da plataforma
L  = 0.164;   % braço superior
l  = 0.448;   % braço inferior
h  = 0.000;   % offset vertical (podes definir se necessário)

    %% Conversão de ângulos para radianos
    theta = deg2rad(theta);

    %% Cálculo dos raios dos triângulos
    wB = sB / (2 * tan(pi / 3));
    wP = sP / (2 * tan(pi / 3));

    %% Cálculo dos vetores auxiliares
    a = wB - wP;
    b = (sP / 2) - (sqrt(3)/2) * wB;
    c = wP - 0.5 * wB;

    %% Pontos fixos da base (B1, B2, B3)
    B1 = [0, -wB, 0];
    B2 = [sqrt(3)/2 * wB, 0.5 * wB, 0];
    B3 = [-sqrt(3)/2 * wB, 0.5 * wB, 0];

    %% Braços superiores (BL1, BL2, BL3)
    BL1 = [0, -L * cos(theta(1)), -L * sin(theta(1))];
    BL2 = [sqrt(3)/2 * L * cos(theta(2)), 0.5 * L * cos(theta(2)), -L * sin(theta(2))];
    BL3 = [-sqrt(3)/2 * L * cos(theta(3)), 0.5 * L * cos(theta(3)), -L * sin(theta(3))];

    %% Pontos dos cotovelos (A1, A2, A3)
    A1 = B1 + BL1;
    A2 = B2 + BL2;
    A3 = B3 + BL3;

    %% Pontos fixos da plataforma (P1, P2, P3)
    P1 = [0, -sP/2, 0];
    P2 = [sqrt(3)*sP/4, sP/4, 0];
    P3 = [-sqrt(3)*sP/4, sP/4, 0];

    %% Centros das esferas = A_i - P_i
    A1v = A1 - P1;
    A2v = A2 - P2;
    A3v = A3 - P3;
    %% Calcula a interseção das esferas
    Pp = resolver_intersecao_esferas(A1v, A2v, A3v, l);
end
