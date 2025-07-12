module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly compute the selected 4-bit output using a single expression
    // sel*4 gives the starting bit position of the selected 4-bit chunk
    assign out = in[sel*4 +: 4];

endmodule