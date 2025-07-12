module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Directly index the 4-bit slice selected by sel
    assign out = in[sel*4 +: 4];
endmodule