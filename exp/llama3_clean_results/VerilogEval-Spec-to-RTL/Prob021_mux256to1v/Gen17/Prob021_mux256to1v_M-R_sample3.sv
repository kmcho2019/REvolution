module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the starting index of the selected block
wire [9:0] start_idx = {sel[7:4], 4'd0} * 64;

// Extract the 4-bit value from the input vector
assign out = in[start_idx + sel[3:0] * 4 +: 4];

endmodule