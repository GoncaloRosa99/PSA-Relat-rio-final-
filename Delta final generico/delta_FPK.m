function delta_FPK(theta_deg)
% delta_FPK - Calcula e imprime a posição do end-effector do robô Delta
% dado os ângulos das juntas em graus.
%
% INPUT:
%   theta_deg - vetor [theta1, theta2, theta3] em graus

    %% =======================
    %  PARÂMETROS DO ROBÔ
    %  =======================
    sB = 0.567;   % lado da base (m)
    sP = 0.076;   % lado da plataforma (m)

    % Cálculo geométrico dos parâmetros
    wB = sqrt(3)/6 * sB;
    uB = sqrt(3)/3 * sB;
    wP = sqrt(3)/6 * sP;
    uP = sqrt(3)/3 * sP;

    L  = 0.524;    % braço superior (m)
    l  = 1.244;    % braço inferior (m)

    %% =======================
    %  ÂNGULOS DAS JUNTAS [rad]
    %  =======================
    theta = deg2rad(theta_deg); % converter para radianos
    theta1 = theta(1);
    theta2 = theta(2);
    theta3 = theta(3);

    %% =======================
    %  CENTROS DAS ESFERAS
    %  =======================
    A1v = [ 0;
           -wB - L*cos(theta1) + uP;
           -L*sin(theta1)];

    A2v = [ (sqrt(3)/2)*(wB + L*cos(theta2)) - sP/2;
             0.5*(wB + L*cos(theta2)) - wP;
            -L*sin(theta2)];

    A3v = [-(sqrt(3)/2)*(wB + L*cos(theta3)) + sP/2;
             0.5*(wB + L*cos(theta3)) - wP;
            -L*sin(theta3)];

    %% =======================
    %  INTERSEÇÃO DAS ESFERAS
    %  =======================
    C1 = A1v;
    C2 = A2v;
    C3 = A3v;

    syms z_sym real
    A = 2 * [C2' - C1';
             C3' - C1'];
    b = [norm(C1)^2 - norm(C2)^2;
         norm(C1)^2 - norm(C3)^2];

    X = A \ (b - 2*z_sym * [C2(3) - C1(3); C3(3) - C1(3)]);
    x = X(1);
    y = X(2);

    % Equação da esfera 1
    eq = (x - C1(1))^2 + (y - C1(2))^2 + (z_sym - C1(3))^2 == l^2;

    % Resolver z
    S = solve(eq, z_sym);
    z_sol = double(S);
    z_sol = z_sol(imag(z_sol) == 0); % manter apenas reais

    % Selecionar solução válida (abaixo da base)
    [~, idx] = min(z_sol);
    z = z_sol(idx);
    x = double(subs(x, z_sym, z));
    y = double(subs(y, z_sym, z));

    %% =======================
    %  RESULTADO FINAL
    %  =======================
    Pp = [x; y; z] ;  % converter para mm

    % Mostrar resultado formatado
    fprintf('Para o theta = [%.0f %.0f %.0f] graus\n', theta_deg);
    fprintf('x = %.3f mm\n', Pp(1));
    fprintf('y = %.3f mm\n', Pp(2));
    fprintf('z = %.3f mm\n', Pp(3));
end
