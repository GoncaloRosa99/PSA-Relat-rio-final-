clear all; clc; close all;

porta = "COM7";
s = serialport(porta, 115200);
configureTerminator(s, "CR");
flush(s);

%% Ignorar mensagens de boot
disp("A ignorar mensagens de boot...");
t0 = tic;
while toc(t0) < 4
    if s.NumBytesAvailable > 0
        readline(s);  % descarta linha de boot
    end
end

pause(0.5);  % garantir estabilidade

%% Inicialização segura
writeline(s, "G90"); readline(s); pause(0.3);       % Coordenadas absolutas
writeline(s, "G28"); readline(s); pause(1.0);       % Homing 
writeline(s, "M17"); readline(s); pause(0.3);       % Ativar motores
writeline(s, "M17.1"); readline(s); pause(0.3);     % Modo Delta



%% Voltar à origem física em Z=0
disp("A mover para origem física em Z=0...");
writeline(s, "G1 X0 Y0 Z0 F5000"); readline(s); pause(2);
%% Executar transporte entre duas casas
mapa = mapear_tabuleiro();
mover_de_para(s, mapa);

% Desligar motores
writeline(s, "M18"); readline(s); pause(0.5);