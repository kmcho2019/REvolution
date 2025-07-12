module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Split the 32-bit input vector into four 8-bit bytes
    wire [7:0] byte0 = in[7:0];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte3 = in[31:24];

    // Reverse the order of the bytes and combine them to form the 32-bit output vector
    assign out = {byte3, byte2, byte1, byte0};

endmodule