function mapa = mapear_tabuleiro()
    casas = ["A","B","C","D","E","F","G","H"];
    mapa = containers.Map();

    lado = 32;              % mm
    offset = lado * 3.5;    % centro do tabuleiro (112 mm)
    x_offset_corr = 0;      % correções finas (se quiseres ajustar depois)
    y_offset_corr = 0;

    % Correção radial
    k = 0.05;               % ganho da correção radial (ajustável)
    max_r = sqrt(112^2 + 112^2);  % ≈ 158.4 mm (canto mais distante)

    for i = 1:8
        for j = 1:8
            nome = sprintf("%s%d", casas(i), j);

            % Coordenadas sem correção
            x_raw = (8 - i) * lado - offset;
            y_raw = (8 - j) * lado - offset;

            % Distância ao centro
            r = sqrt(x_raw^2 + y_raw^2);

            % Fator de correção radial
            fator = 1 + k * (r / max_r);

            % Aplicar correção radial
            x = x_raw * fator + x_offset_corr;
            y = y_raw * fator + y_offset_corr;

            mapa(nome) = [x, y, 0];
        end
    end
end

