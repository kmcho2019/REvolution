module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Optimal fused solution:
    // - Uses shift operations instead of multiplication
    // - Single continuous assignment for best timing
    // - Combines group and bit selection in one expression
    assign out = in[({sel[7:4], sel[3:0], 2'b0} +: 4];

endmodule