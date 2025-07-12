module TopModule(
    input  [255:0] in,  // 256-bit input vector
    input  [7:0] sel,   // 8-bit select signal
    output out          // 1-bit output
);

assign out = in[sel];  // Use sel as an index into the input vector

endmodule