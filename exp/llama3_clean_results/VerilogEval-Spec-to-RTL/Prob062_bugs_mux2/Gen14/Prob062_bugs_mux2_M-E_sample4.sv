// Novel 8-bit 2-to-1 multiplexer implementation using ternary operator
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

    // Use ternary operator for concise multiplexer logic
    assign out = (sel)? b : a;

endmodule