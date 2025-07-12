module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Check for all zeros case
    wire all_zeros = ~(a | b | c | d);
    
    // Calculate parity using balanced XOR tree
    wire xor_ab = a ^ b;
    wire xor_cd = c ^ d;
    wire parity = xor_ab ^ xor_cd;
    
    // Output is 1 for all zeros or even parity
    assign q = all_zeros | ~parity;
endmodule