function mapa = mapear_tabuleiro()
    casas = ["A","B","C","D","E","F","G","H"];
    mapa = containers.Map();

    % Lado da casa (32 mm), e origem no centro do tabuleiro
    lado = 32;
    offset = lado * 3.5;  % deslocamento até ao centro

    for i = 1:8  % colunas (A a H)
        for j = 1:8  % linhas (1 a 8)
            nome = sprintf("%s%d", casas(i), j);
            x = (i-1) * lado - offset;
            y = (j-1) * lado - offset;
            mapa(nome) = [x, y, -30];  % Z fixo
        end
    end
end
