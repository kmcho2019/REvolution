module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Use shift-left by 2 instead of multiplication by 4 for indexing
    assign out = in[(sel << 2) +: 4];

endmodule