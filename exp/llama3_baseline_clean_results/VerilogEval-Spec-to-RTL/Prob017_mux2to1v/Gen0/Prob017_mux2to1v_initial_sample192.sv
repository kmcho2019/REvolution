module TopModule(
    input [99:0] a,  // 100-bit input a
    input [99:0] b,  // 100-bit input b
    input sel,       // 1-bit select signal
    output [99:0] out // 100-bit output
);

    assign out = sel ? b : a; // Conditional operator to select between a and b based on sel

endmodule