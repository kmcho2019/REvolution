module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Use variable part-select with offset sel*4
    assign out = in[sel*4 +: 4];

endmodule