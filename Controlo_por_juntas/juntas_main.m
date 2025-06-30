clear; clc;

%% --- Comunicação Serial ---
porta = "COM8";  % Altera conforme necessário
s = serialport(porta, 115200);
configureTerminator(s, "CR");
flush(s);

disp("A ignorar mensagens de boot...");
t0 = tic;
while toc(t0) < 4
    if s.NumBytesAvailable > 0
        readline(s);
    end
end
pause(0.5);

%% --- Inicialização dos motores e modo por juntas ---
writeline(s, "G90"); readline(s); pause(0.3);
writeline(s, "M17"); readline(s); pause(0.3);
writeline(s, "M17.1"); readline(s); pause(0.3);

%% --- Ir para origem (posição conhecida)
disp("Mover para origem θ = -7.01°...");
writeline(s, "G01 01q-7.01 02q-7.01 03q-7.01 F2500");
readline(s); pause(2);

%% --- Mapeamento do tabuleiro
mapa = mapear_tabuleiro();

%% --- Pedir casas de origem e destino
disp("Indica de que casa para que casa mover a peça:");
casa_origem = upper(input("De: ", "s"));
casa_destino = upper(input("Para: ", "s"));

if ~isKey(mapa, casa_origem) || ~isKey(mapa, casa_destino)
    error("Casa inválida. Usa formato como 'E2'.");
end

% Obter coordenadas XY
P_origem = mapa(casa_origem);      % [x, y, z]
P_destino = mapa(casa_destino);    % [x, y, z]
xy_origem = P_origem(1:2);
xy_destino = P_destino(1:2);

%% --- Alturas e velocidade
z_alto = -375;     % altura segura
z_baixo = -405;    % altura para agarrar/largar
vel = 10000;       % velocidade comum

% === 1. Ir para cima da casa de origem ===
P1 = [xy_origem, z_alto] / 1000;
theta1 = Inversa_Delta1(P1);
cmd = sprintf("G01 01q%.2f 02q%.2f 03q%.2f F%d", theta1(1), theta1(2), theta1(3), vel);
disp("1. Ir para cima da casa de origem...");
writeline(s, cmd); readline(s); pause(1.5);

% === 2. Descer para agarrar ===
P2 = [xy_origem, z_baixo] / 1000;
theta2 = Inversa_Delta1(P2);
cmd = sprintf("G01 01q%.2f 02q%.2f 03q%.2f F%d", theta2(1), theta2(2), theta2(3), vel);
disp("2. Descer para agarrar a peça...");
writeline(s, cmd); readline(s); pause(1.5);

% === 3. Subir novamente ===
cmd = sprintf("G01 01q%.2f 02q%.2f 03q%.2f F%d", theta1(1), theta1(2), theta1(3), vel);
disp("3. Subir com a peça...");
writeline(s, cmd); readline(s); pause(1.5);

% === 4. Mover para cima da casa destino ===
P4 = [xy_destino, z_alto] / 1000;
theta4 = Inversa_Delta1(P4);
cmd = sprintf("G01 01q%.2f 02q%.2f 03q%.2f F%d", theta4(1), theta4(2), theta4(3), vel);
disp("4. Mover para cima da casa de destino...");
writeline(s, cmd); readline(s); pause(1.5);

% === 5. Descer para largar ===
P5 = [xy_destino, z_baixo] / 1000;
theta5 = Inversa_Delta1(P5);
cmd = sprintf("G01 01q%.2f 02q%.2f 03q%.2f F%d", theta5(1), theta5(2), theta5(3), vel);
disp("5. Descer para largar a peça...");
writeline(s, cmd); readline(s); pause(1.5);

% === 6. Subir novamente ===
cmd = sprintf("G01 01q%.2f 02q%.2f 03q%.2f F%d", theta4(1), theta4(2), theta4(3), vel);
disp("6. Subir após largar...");
writeline(s, cmd); readline(s); pause(1.5);

% === 7. Voltar à origem em z = -375 ===
P7 = [0, 0, z_alto] / 1000;
theta7 = Inversa_Delta1(P7);
cmd = sprintf("G01 01q%.2f 02q%.2f 03q%.2f F%d", theta7(1), theta7(2), theta7(3), vel);
disp("7. Voltar à origem...");
writeline(s, cmd); readline(s); pause(1.5);

%% --- Desligar motores
writeline(s, "M18"); readline(s);
disp("Motores desligados.");
