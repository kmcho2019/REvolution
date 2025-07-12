module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Calculate the XOR of all inputs
wire xor_result = a ^ b ^ c ^ d;

// If all inputs are 0, set q to 1, otherwise, q follows the XOR result
assign q = (~a & ~b & ~c & ~d) | xor_result;

endmodule