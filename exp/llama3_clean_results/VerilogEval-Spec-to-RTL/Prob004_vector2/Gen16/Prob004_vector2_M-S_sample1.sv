module TopModule (
    input  wire [31:0] in,  // 32-bit input vector
    output wire [31:0] out  // 32-bit output vector with bytes reversed
);

    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};  // Directly reverse the byte order

endmodule