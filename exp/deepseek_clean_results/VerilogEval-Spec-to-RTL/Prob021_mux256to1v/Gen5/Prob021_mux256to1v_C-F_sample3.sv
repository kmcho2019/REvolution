module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Optimal fused solution: direct hierarchical selection with minimal operations
    assign out = in[(sel << 2) +: 4];
endmodule