// Given the simplicity and efficiency of the current design,
// the improved code remains similar, focusing on the existing
// implementation's direct byte assignment approach.
module TopModule(
    input [31:0] in,
    output [31:0] out
);

// Directly assign the bytes in reverse order to the output.
assign out[31:24] = in[7:0];
assign out[23:16] = in[15:8];
assign out[15:8] = in[23:16];
assign out[7:0] = in[31:24];

endmodule