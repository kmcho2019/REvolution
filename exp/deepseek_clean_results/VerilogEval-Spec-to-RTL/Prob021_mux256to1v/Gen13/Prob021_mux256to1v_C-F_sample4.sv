module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct hierarchical selection without intermediate wires
    // Upper 4 bits select group (64-bit chunk)
    // Lower 4 bits select within group (4-bit chunk)
    assign out = in[{sel[7:4], sel[3:0], 2'b00} +: 4];

endmodule