module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_xor, cd_xor;
    wire intermediate;
    
    // First level XORs
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    
    // Second level XOR
    assign intermediate = ab_xor ^ cd_xor;
    
    // Final inversion for XNOR
    assign q = ~intermediate;

endmodule