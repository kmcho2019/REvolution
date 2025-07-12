module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Direct calculation of output using hierarchical selection without intermediate wires
    // Upper 4 bits of sel select the 64-bit group (16 groups total)
    // Lower 4 bits select the 4-bit chunk within the group (16 chunks per group)
    assign out = in[{sel[7:4], sel[3:0], 2'b00} +: 4];
endmodule