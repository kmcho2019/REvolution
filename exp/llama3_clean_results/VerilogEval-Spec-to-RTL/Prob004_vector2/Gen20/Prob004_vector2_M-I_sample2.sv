module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    assign out[7:0]   = in[24:17];  // Reverse byte 0
    assign out[15:8]  = in[16:9];   // Reverse byte 1
    assign out[23:16] = in[8:1];    // Reverse byte 2
    assign out[31:24] = in[0:7];    // Reverse byte 3

endmodule