module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Optimal fused solution: direct hierarchical selection without intermediates
    assign out = in[{sel, 2'b00} +: 4];
endmodule