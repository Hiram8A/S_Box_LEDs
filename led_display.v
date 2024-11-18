module led_display (
    input wire [7:0] data,      // Datos a mostrar en los LEDs
    output reg [7:0] leds       // Salida para los LEDs
);

    always @(*) begin
        leds = data;
    end

endmodule