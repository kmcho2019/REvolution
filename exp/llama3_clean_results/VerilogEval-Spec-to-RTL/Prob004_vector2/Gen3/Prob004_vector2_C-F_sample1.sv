module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    // Reverse the byte order of the input vector
    // in[31:24] is the most significant byte, in[7:0] is the least significant byte
    // We assign them in reverse order to out
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule