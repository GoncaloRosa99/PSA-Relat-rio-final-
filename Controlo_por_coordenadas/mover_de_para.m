function mover_de_para(s, mapa)
    origem = upper(input("De onde vais? (ex: A2): ", "s"));
    destino = upper(input("Para onde queres ir? (ex: B3): ", "s"));

    if ~isKey(mapa, origem) || ~isKey(mapa, destino)
        error("Posição inválida. Usa casas como 'A1' até 'H8'.");
    end

    pos1 = mapa(origem);
    pos2 = mapa(destino);

    % Velocidades
    v_xy = 5000;  % velocidade horizontal (X/Y)
    v_z  = 1500;  % velocidade vertical (Z)

    % Voltar ao centro
    writeline(s, sprintf("G1 X0 Y0 Z0 F%d", v_xy)); readline(s); pause(0.4);

    % Ir horizontalmente até acima da peça (Z=0)
    writeline(s, sprintf("G1 X%.2f Y%.2f Z0 F%d", pos1(1), pos1(2), v_xy)); readline(s); pause(0.4);

    % Descer verticalmente (Z = -30)
    writeline(s, sprintf("G1 Z-30 F%d", v_z)); readline(s); pause(0.4);

    % Subir de novo a Z = 0
    writeline(s, sprintf("G1 Z0 F%d", v_z)); readline(s); pause(0.4);

    % Ir horizontalmente até acima do destino (Z=0)
    writeline(s, sprintf("G1 X%.2f Y%.2f Z0 F%d", pos2(1), pos2(2), v_xy)); readline(s); pause(0.4);

    % Descer verticalmente (Z = -30)
    writeline(s, sprintf("G1 Z-30 F%d", v_z)); readline(s); pause(0.4);

    % Subir de novo a Z = 0
    writeline(s, sprintf("G1 Z0 F%d", v_z)); readline(s); pause(0.4);

    % Voltar ao centro
    writeline(s, sprintf("G1 X0 Y0 Z0 F%d", v_xy)); readline(s); pause(0.4);
end

