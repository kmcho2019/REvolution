module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] out
);

    // Clear ternary selection with correct bit widths
    // Maintains original polarity: sel=1 selects a, sel=0 selects b
    assign out = sel ? a : b;

endmodule