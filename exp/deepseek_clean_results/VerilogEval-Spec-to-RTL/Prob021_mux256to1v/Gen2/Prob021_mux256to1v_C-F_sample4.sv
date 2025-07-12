module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct part-select with full 8-bit sel for optimal selection
    assign out = in[(sel << 2) +: 4];  // Equivalent to in[4*sel +: 4]

endmodule