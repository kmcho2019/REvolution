module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Break down the input vector into individual bytes
    wire [7:0] byte0 = in[7:0];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte3 = in[31:24];

    // Reverse the byte order
    assign out[7:0]   = byte3;
    assign out[15:8]  = byte2;
    assign out[23:16] = byte1;
    assign out[31:24] = byte0;

endmodule