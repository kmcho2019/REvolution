module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel, // 8-bit selector
    output wire [3:0]    out
);
    // Directly select 4 bits starting at sel*4 from the input vector
    assign out = in[sel*4 +: 4];

endmodule