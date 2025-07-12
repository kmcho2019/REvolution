module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Single direct calculation of the selected 4-bit chunk
    // Equivalent to: (sel[7:4]*64) + (sel[3:0]*4) = sel*4
    assign out = in[(sel * 4) +: 4];

endmodule