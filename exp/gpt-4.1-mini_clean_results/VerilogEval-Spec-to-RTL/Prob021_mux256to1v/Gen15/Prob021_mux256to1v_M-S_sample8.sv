module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select
    output wire [3:0]    out   // 4-bit output
);

    // Directly select the 4-bit slice based on sel
    assign out = in[sel*4 +: 4];

endmodule