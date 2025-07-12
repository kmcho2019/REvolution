module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct two-level hierarchical selection using part-select:
    // 1. First level uses sel[7:4] to select one of 16 groups (each 64 bits)
    // 2. Second level uses sel[3:0] to select one of 16 4-bit fields within group
    assign out = in[{sel[7:4], sel[3:0], 2'b0} +: 4];

endmodule