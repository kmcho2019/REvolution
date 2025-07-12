module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct hierarchical selection in one expression:
    // - Upper 4 bits of sel select the 64-bit group
    // - Lower 4 bits select the 4-bit field within group
    assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];

endmodule