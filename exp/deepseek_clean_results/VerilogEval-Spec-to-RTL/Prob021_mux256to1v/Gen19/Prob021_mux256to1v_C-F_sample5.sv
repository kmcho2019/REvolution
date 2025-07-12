module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct 256-to-1 selection using part-select with proper indexing
    // Formula: out = in[(sel * 4) +: 4]
    // This selects 4 bits starting at position (sel * 4)
    assign out = in[sel * 4 +: 4];

endmodule