module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // First level XORs (pairwise)
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    
    // Second level XOR
    wire parity = ab_xor ^ cd_xor;
    
    // Invert to get even parity
    assign q = ~parity;

endmodule