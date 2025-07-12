module TopModule(
    input  [99:0] a,   // 100-bit input vector a
    input  [99:0] b,   // 100-bit input vector b
    input           sel, // select signal
    output [99:0] out  // 100-bit output vector
);

assign out = (sel == 1'b0) ? a : b;

endmodule