module TopModule(
    input [255:0] in,  // 256-bit input vector
    input [7:0] sel,   // 8-bit select line
    output out          // 1-bit output
);

    // Generate the output by selecting the bit from the input vector based on the select line
    assign out = in[sel];

endmodule