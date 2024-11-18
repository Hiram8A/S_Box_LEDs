module debouncer #(
    parameter DEBOUNCE_MS = 10,              // Tiempo de rebote en milisegundos
    parameter CLK_FREQ_MHZ = 50              // Frecuencia del reloj en MHz
)(
    input  wire clk_50MHz,                   // Reloj de entrada de 50MHz
    input  wire btn_in,                      // Entrada del botón sin procesar
    output reg  btn_out                      // Salida del botón con rebote eliminado
);

    // Calcular el máximo del contador basado en los parámetros
    localparam COUNTER_MAX = DEBOUNCE_MS * CLK_FREQ_MHZ * 1000;
    localparam COUNTER_WIDTH = $clog2(COUNTER_MAX);

    // Señales internas
    reg [1:0]  sync_ff;                      // Flip-flops de sincronización
    reg [COUNTER_WIDTH-1:0] counter;         // Contador de rebote
    reg btn_stable;                          // Estado estable del botón
    reg btn_prev;                            // Estado previo del botón

    // Sincronizar con dos flip-flops
    always @(posedge clk_50MHz) begin
        sync_ff <= {sync_ff[0], btn_in};
    end

    // Lógica del anti-rebote
    always @(posedge clk_50MHz) begin
        // Verificar cambio en el estado del botón
        if (btn_prev != sync_ff[1]) begin
            counter <= 'd0;
            btn_prev <= sync_ff[1];
        end
        // Anti-rebote con un contador
        else if (counter < COUNTER_MAX) begin
            counter <= counter + 1'b1;
        end
        else begin
            btn_stable <= btn_prev;
        end
    end

    // Generación de pulso de salida
    always @(posedge clk_50MHz) begin
        btn_out <= (btn_stable && !btn_prev);
    end

endmodule