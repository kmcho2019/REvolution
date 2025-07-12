module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Directly index the 4-bit slice from the input vector using sel as index
    // Each input group is 4 bits, so multiply sel by 4 to find the starting bit
    assign out = in[sel*4 +: 4];
endmodule