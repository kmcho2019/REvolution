module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Directly select 4 bits from the input vector based on sel index
    // sel * 4 gives the starting bit for the selected 4-bit slice
    assign out = in[sel*4 +: 4];

endmodule