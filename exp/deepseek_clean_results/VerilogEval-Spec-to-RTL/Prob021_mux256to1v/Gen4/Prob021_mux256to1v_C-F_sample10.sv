module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Single expression combining both selection levels:
    // - Upper 4 bits of sel select the group (16 groups)
    // - Lower 4 bits select within group (16 entries per group)
    // Each group is 64 bits (16 entries × 4 bits)
    assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];
endmodule