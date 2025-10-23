module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Balanced XOR tree implementation
    wire ab_xor, cd_xor;
    
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign q = ~(ab_xor ^ cd_xor);
endmodule