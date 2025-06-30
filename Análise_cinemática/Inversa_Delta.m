function theta = Inversa_Delta(Pp)
% Calcula os ângulos das juntas do Robô Delta (cinemática inversa)
% Entrada: Pp = [x, y, z] posição desejada da plataforma móvel (em metros)
% Saída: theta = [theta1, theta2, theta3] (em graus)

% ----- Parâmetros do robô (modelo ABB FlexPicker IRB 360-1/1600) -----
sB = 0.381;   % lado do triângulo da base
sP = 0.121;   % lado do triângulo da plataforma
L  = 0.164;   % braço superior
l  = 0.448;   % braço inferior
h  = 0.000;   % offset vertical (podes definir se necessário)

wB = sqrt(3)/6 * sB;
uB = sqrt(3)/3 * sB;
wP = sqrt(3)/6 * sP;
uP = sqrt(3)/3 * sP;

a = wB - uP;
b = sP / 2 - sqrt(3)/2 * wB;
c = wP - 0.5 * wB;

% ----- Extrair coordenadas desejadas -----
x = Pp(1); y = Pp(2); z = Pp(3);

% ----- Inicializar vetor de ângulos -----
theta = zeros(1,3);

% ----- Loop para cada perna (i = 1, 2, 3) -----
for i = 1:3
    % Coeficientes da equação quadrática Ei*cos(theta) + Fi*sin(theta) + Gi = 0
    switch i
        case 1
            E = 2 * L * (y + a);
            F = 2 * z * L;
            G = x^2 + y^2 + z^2 + a^2 + L^2 + 2 * y * a - l^2;
        case 2
            E = -L * (sqrt(3) * (x + b) + y + c);
            F = 2 * z * L;
            G = x^2 + y^2 + z^2 + b^2 + c^2 + L^2 + 2 * (x * b + y * c) - l^2;
        case 3
            E = L * (sqrt(3) * (x - b) - y - c);
            F = 2 * z * L;
            G = x^2 + y^2 + z^2 + b^2 + c^2 + L^2 + 2 * (-x * b + y * c) - l^2;
    end

    % Substituição por tangente do meio ângulo: t = tan(theta/2)
    % Resolver E*cos(theta) + F*sin(theta) + G = 0

    % Quadrática em t: (G - E)*t^2 + (2*F)*t + (G + E) = 0
    A = G - E;
    B = 2 * F;
    C = G + E;

    % Resolver quadrática
    delta = B^2 - 4 * A * C;
    if delta < 0
        error('Não há solução real para a perna %d', i);
    end

    % Duas soluções possíveis
    t1 = (-B + sqrt(delta)) / (2 * A);
    t2 = (-B - sqrt(delta)) / (2 * A);

    % Calcular ângulos correspondentes
    theta1 = 2 * atan(t1);
    theta2 = 2 * atan(t2);

    % Converter para graus
    theta1_deg = rad2deg(theta1);
    theta2_deg = rad2deg(theta2);

    % Escolher solução com menor módulo do ângulo 
    if abs(theta1_deg) < abs(theta2_deg)
        theta(i) = theta1_deg;
    else
        theta(i) = theta2_deg;
    end
end
end
