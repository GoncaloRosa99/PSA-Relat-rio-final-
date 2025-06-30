function theta = Inversa_Delta1(Pp)
% Calcula os ângulos das juntas do Robô Delta (cinemática inversa)
% Entrada: Pp = [x, y, z] em metros
% Saída: theta = [θ1, θ2, θ3] em graus

sB = 0.381; sP = 0.121; L = 0.164; l = 0.448;
wB = sqrt(3)/6 * sB;
uP = sqrt(3)/3 * sP;
wP = sqrt(3)/6 * sP;
a = wB - uP;
b = sP / 2 - sqrt(3)/2 * wB;
c = wP - 0.5 * wB;

x = Pp(1); y = Pp(2); z = Pp(3);
theta = zeros(1,3);

for i = 1:3
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
    A = G - E;
    B = 2 * F;
    C = G + E;
    delta = B^2 - 4 * A * C;
    if delta < 0
        error('Não há solução real para a perna %d', i);
    end
    t1 = (-B + sqrt(delta)) / (2 * A);
    t2 = (-B - sqrt(delta)) / (2 * A);
    theta1 = 2 * atan(t1);
    theta2 = 2 * atan(t2);
    theta1_deg = rad2deg(theta1);
    theta2_deg = rad2deg(theta2);
    if abs(theta1_deg) < abs(theta2_deg)
        theta(i) = theta1_deg;
    else
        theta(i) = theta2_deg;
    end
end
end
