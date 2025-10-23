module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Directly select 4 bits from the input vector indexed by sel
    assign out = in[sel*4 +: 4];
endmodule