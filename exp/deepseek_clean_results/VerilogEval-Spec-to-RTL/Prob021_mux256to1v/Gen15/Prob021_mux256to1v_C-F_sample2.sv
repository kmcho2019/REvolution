module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct hierarchical selection without intermediate wires
    // sel[7:4] selects group (0-15), sel[3:0] selects within group (0-15)
    assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];

endmodule