module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

// Replicate the MSB 24 times and concatenate with the original 8-bit input
assign out = { {24{in[7]}}, in };

endmodule