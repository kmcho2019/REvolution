module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct selection using the full 8-bit selector
    // sel*4 calculates the starting bit position, +:4 selects 4 bits
    assign out = in[sel*4 +: 4];

endmodule