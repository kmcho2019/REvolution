module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly compute the output using part-select
    // sel*4 gives the starting bit position, +:4 selects 4 bits from there
    assign out = in[sel*4 +: 4];

endmodule