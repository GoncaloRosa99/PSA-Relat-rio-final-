function Pp = resolver_intersecao_esferas(A1, A2, A3, l)
    % Vetores base do novo referencial
    ex = (A2 - A1) / norm(A2 - A1);
    i = dot(ex, A3 - A1);
    
    temp = A3 - A1 - i * ex;
    ey = temp / norm(temp);
    ez = cross(ex, ey);
    
    d = norm(A2 - A1);
    j = dot(ey, A3 - A1);
    
    % Coordenadas locais no novo referencial
    x = (l^2 - l^2 + d^2) / (2 * d);
    y = (l^2 - l^2 + i^2 + j^2 - 2*i*x) / (2 * j);
    
    z_squared = l^2 - x^2 - y^2;
    if z_squared < 0
        error("Não existe solução real para a interseção das esferas.");
    end
    z = -sqrt(z_squared);  % solução abaixo da base

    % Converter para coordenadas globais
    P_local = x * ex + y * ey + z * ez;
    Pp = A1 + P_local;
end
