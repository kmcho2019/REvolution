module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    reg [7:0] byte0, byte1, byte2, byte3;  // Registers to hold the input bytes
    reg [31:0] out_reg;  // Register to hold the output vector

    always @(*) begin
        // Assign the input bytes to the registers
        byte0 = in[31:24];
        byte1 = in[23:16];
        byte2 = in[15:8];
        byte3 = in[7:0];

        // Assign the registers to the output vector in reverse order
        out_reg = {byte3, byte2, byte1, byte0};
    end

    // Assign the output register to the output port
    assign out = out_reg;

endmodule