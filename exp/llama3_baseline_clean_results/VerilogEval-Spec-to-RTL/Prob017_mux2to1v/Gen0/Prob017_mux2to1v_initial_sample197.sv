module TopModule(
    input  [99:0] a,  // 100-bit input
    input  [99:0] b,  // 100-bit input
    input         sel,  // Select signal
    output [99:0] out  // 100-bit output
);

    // Use a ternary operator (conditional operator) to select between a and b
    assign out = sel? b : a;

endmodule