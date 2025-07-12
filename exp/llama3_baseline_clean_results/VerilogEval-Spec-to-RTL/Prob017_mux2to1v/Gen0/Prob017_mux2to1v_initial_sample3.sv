module TopModule(
    input  [99:0] a,  // 100-bit input
    input  [99:0] b,  // 100-bit input
    input         sel,  // select signal
    output [99:0] out  // 100-bit output
);

    // Use a conditional operator to assign out based on sel
    assign out = sel ? b : a;

endmodule