module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct selection of 4-bit chunk from 1024-bit input
    // sel*4 calculates the starting bit position, +:4 selects 4 bits from there
    assign out = in[sel*4 +: 4];

endmodule