module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Efficient 8-bit multiplexer using ternary operator
    // sel=1 selects a, sel=0 selects b
    // Clean implementation that synthesizes well
    assign out = sel ? a : b;

endmodule