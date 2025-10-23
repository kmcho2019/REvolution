module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Directly select 4 bits from 'in' using sel as index
    // sel * 4 computes the starting bit index for the 4-bit output
    assign out = in[sel*4 +: 4];

endmodule