module TopModule(
    input  [255:0] in,  // 256-bit input vector
    input  [7:0] sel,   // 8-bit selector
    output out          // 1-bit output
);

    assign out = in[sel];  // Use the sel value to index into the input vector

endmodule