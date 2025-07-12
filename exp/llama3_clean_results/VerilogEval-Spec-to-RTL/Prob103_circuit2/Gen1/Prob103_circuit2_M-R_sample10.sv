module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Using a temporary variable for the XOR result before inverting it
wire xor_result = a ^ b ^ c ^ d;
assign q = ~xor_result;

endmodule