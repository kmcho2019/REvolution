// TopModule: Reverses the byte order of a 32-bit vector
module TopModule(
    input  [31:0] in,  // 32-bit input vector
    output [31:0] out  // 32-bit output vector
);

    // Reverse byte order by reordering the bytes
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule