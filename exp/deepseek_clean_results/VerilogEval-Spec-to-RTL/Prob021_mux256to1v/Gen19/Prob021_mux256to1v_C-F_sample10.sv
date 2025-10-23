module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct calculation of the selected 4-bit slice
    // Each sel value corresponds to a unique 4-bit group (0->[3:0], 1->[7:4], etc.)
    assign out = in[(sel * 4) +: 4];

endmodule