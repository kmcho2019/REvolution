module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct hierarchical selection using concatenated group and bit selectors
    // sel[7:4] selects group (16 groups), sel[3:0] selects bit within group
    // This creates a balanced two-level selection while being compact
    assign out = in[{sel[7:4], sel[3:0]}];

endmodule