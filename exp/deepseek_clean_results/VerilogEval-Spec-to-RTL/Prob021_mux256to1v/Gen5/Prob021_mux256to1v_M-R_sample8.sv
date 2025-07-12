module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Single continuous assignment combining both selection levels:
    // - sel[7:4] selects which 64-bit chunk (16 groups of 4 bits)
    // - sel[3:0] selects which 4-bit group within the chunk
    assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];

endmodule