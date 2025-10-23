module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly compute the output using hierarchical selection
    // sel[7:4] selects group (16 groups of 64 bits)
    // sel[3:0] selects within group (16 4-bit chunks per group)
    assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];

endmodule