module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct hierarchical selection using full 8-bit selector
    // sel[3:0] selects within group, sel[7:4] selects group
    assign out = in[{sel[7:4], sel[3:0]}];

endmodule