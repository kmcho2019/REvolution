module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Direct two-level selection:
    // 1. Use upper 4 bits of sel to select which 64-bit chunk to look at
    // 2. Use lower 4 bits to select the 4-bit field within that chunk
    assign out = in[{sel[7:4], sel[3:0], 2'b0} +: 4];
endmodule