module TopModule (
    input  wire [1023:0] in,  // 256 inputs of 4 bits each packed in 1024-bit vector
    input  wire [7:0]    sel, // 8-bit select
    output wire [3:0]    out  // 4-bit output
);

    // Directly index into the input vector using sel * 4 as the start bit
    assign out = in[sel*4 +: 4];

endmodule