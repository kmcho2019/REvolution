module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Directly select the 4-bit slice indexed by sel
    assign out = in[sel*4 +: 4];
endmodule