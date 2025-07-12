module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output reg [31:0] out  // 32-bit output vector with bytes reversed
);

    reg [7:0] byte0, byte1, byte2, byte3;  // Registers to hold the bytes of the input vector

    // Assign the bytes of the input vector to the registers
    always @(*) begin
        byte0 = in[7:0];
        byte1 = in[15:8];
        byte2 = in[23:16];
        byte3 = in[31:24];
    end

    // Reverse the byte order by concatenating the registers in reverse order
    always @(*) begin
        out = {byte3, byte2, byte1, byte0};  // Reverse byte order
    end

endmodule