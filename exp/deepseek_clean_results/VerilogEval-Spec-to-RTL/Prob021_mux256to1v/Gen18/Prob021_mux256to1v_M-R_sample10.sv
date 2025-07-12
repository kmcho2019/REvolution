module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct calculation of the selected 4-bit group
    assign out = in[(sel * 4) +: 4];

endmodule