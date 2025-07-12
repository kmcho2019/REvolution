module TopModule (
    input  [255:0] in,    // 256-bit input vector
    input  [7:0]   sel,   // 8-bit selection (0-255)
    output         out    // Selected output bit
);
    // Directly select the bit corresponding to sel value
    assign out = in[sel];
endmodule