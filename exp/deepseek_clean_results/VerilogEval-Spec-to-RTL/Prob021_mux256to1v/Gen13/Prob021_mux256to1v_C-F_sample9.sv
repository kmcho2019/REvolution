module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Direct two-level selection without intermediate wires:
    // 1. Upper 4 bits select group (16 groups of 64 bits)
    // 2. Lower 4 bits select within group (16 4-bit inputs per group)
    assign out = in[{sel[7:4], sel[3:0], 2'b00} +: 4];
endmodule