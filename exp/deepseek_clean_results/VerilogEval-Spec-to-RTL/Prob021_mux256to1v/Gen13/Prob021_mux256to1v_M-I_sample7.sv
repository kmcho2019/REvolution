module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct calculation of starting bit position
    // sel*4 is equivalent to {sel, 2'b00} which is efficiently synthesized
    assign out = in[(sel * 4) +: 4];

endmodule