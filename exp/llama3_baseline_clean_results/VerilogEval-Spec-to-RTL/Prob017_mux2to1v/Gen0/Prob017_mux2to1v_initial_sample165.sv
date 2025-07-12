module TopModule(
    input  [99:0] a,   // 100-bit input
    input  [99:0] b,   // 100-bit input
    input          sel,  // select line
    output [99:0] out  // 100-bit output
);

assign out = (sel == 1'b1) ? b : a; // Use ternary operator to conditionally assign out

endmodule