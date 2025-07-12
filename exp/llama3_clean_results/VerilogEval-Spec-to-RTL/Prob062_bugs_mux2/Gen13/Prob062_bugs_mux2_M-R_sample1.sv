// Refactored 8-bit 2-to-1 multiplexer implementation using a conditional operator
module TopModule (
    // Select line input
    input        sel,
    // 8-bit input a
    input  [7:0] a,
    // 8-bit input b
    input  [7:0] b,
    // 8-bit output selected based on sel
    output [7:0] out
);

    // Continuous assignment using a conditional operator
    assign out = (sel == 1'b0) ? a : b;

endmodule