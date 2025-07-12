module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Direct two-level selection without intermediate wires
    assign out = in[{sel[7:4], sel[3:0]}];

endmodule