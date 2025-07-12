module TopModule(
    input  [31:0] in,
    output [31:0] out
);

    // Assign each byte of the input vector to the output vector in reverse order
    assign out[7:0]   = in[31:24];  // Most significant byte to least significant
    assign out[15:8]  = in[23:16];
    assign out[23:16] = in[15:8];
    assign out[31:24] = in[7:0];   // Least significant byte to most significant

endmodule