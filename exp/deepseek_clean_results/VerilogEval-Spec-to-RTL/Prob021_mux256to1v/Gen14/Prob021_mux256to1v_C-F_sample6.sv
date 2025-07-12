module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Single-line implementation using direct part-select
    // Breaks down into:
    // 1. First level: sel[3:0] selects among 16 groups within a 64-bit block
    // 2. Second level: sel[7:4] selects which 64-bit block to use
    assign out = in[{sel[7:4], sel[3:0], 2'b00} +: 4];

endmodule