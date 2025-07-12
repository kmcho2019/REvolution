module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

// Sign-extend the 8-bit input to 32 bits
assign out = { {24{in[7]}}, in };  // Replicate the sign bit 24 times and concatenate the 8-bit input

endmodule