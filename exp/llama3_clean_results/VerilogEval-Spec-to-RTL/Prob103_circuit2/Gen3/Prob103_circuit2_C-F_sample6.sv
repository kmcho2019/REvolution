module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Calculate the XOR of all input bits and store it in a temporary variable
wire xor_result = a ^ b ^ c ^ d;

// Assign the output q as the inverse of the XOR result
assign q = ~xor_result;

endmodule