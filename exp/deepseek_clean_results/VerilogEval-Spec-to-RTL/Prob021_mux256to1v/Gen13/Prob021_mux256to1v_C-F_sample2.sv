module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Combined hierarchical selection in one expression:
    // - sel[7:4] selects which 64-bit group (0-15)
    // - sel[3:0] selects which 4-bit segment within the group
    assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];

endmodule