module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Temporary variable to store the XOR result
wire xor_result;

// Calculate the XOR of all input bits
assign xor_result = a ^ b ^ c ^ d;

// Invert the XOR result to obtain the output q
assign q = ~xor_result;

endmodule