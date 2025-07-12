module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate the direct offset using hierarchical selection
    // sel[7:4] selects group (0-15), each group has 16 4-bit entries (64 bits)
    // sel[3:0] selects within group (0-15), each entry is 4 bits
    assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];

endmodule