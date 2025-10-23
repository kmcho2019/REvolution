module TopModule(
    input  [7:0] in,  // 8-bit input
    output [31:0] out  // 32-bit output
);

// Create a 24-bit vector filled with the sign bit of the input
wire [23:0] sign_bit_vector = {24{in[7]}};

// Concatenate the sign bit vector with the input to sign-extend it
assign out = {sign_bit_vector, in};

endmodule