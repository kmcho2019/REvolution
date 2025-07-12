module TopModule (
    input  logic [31:0] in,  // 32-bit input vector
    output logic [31:0] out  // 32-bit output vector with bytes reversed
);

    // Directly reverse the byte order of the input vector
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule