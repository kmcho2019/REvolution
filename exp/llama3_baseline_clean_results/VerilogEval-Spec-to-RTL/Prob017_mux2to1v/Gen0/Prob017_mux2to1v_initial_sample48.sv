module TopModule(
    input [99:0] a,  // 100-bit input
    input [99:0] b,  // 100-bit input
    input sel,
    output [99:0] out  // 100-bit output
);

assign out = (sel) ? b : a;  // Use ternary operator to choose between a and b

endmodule