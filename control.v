module control (
    input wire clk,             // Reloj del sistema
    input wire reset,           // Señal de reset
    input wire encrypt,         // Señal de control para cifrado/descifrado
    input wire [7:0] data_in,   // Datos de entrada
    output wire [7:0] data_out  // Datos de salida
);

    reg [7:0] address;
    wire [7:0] sbox_data;

    sbox_lookup sbox_inst (
        .encrypt(encrypt),
        .address(address),
        .data_out(sbox_data)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            address <= 8'b0;
        end else begin
            address <= data_in;
        end
    end

    assign data_out = sbox_data;

endmodule