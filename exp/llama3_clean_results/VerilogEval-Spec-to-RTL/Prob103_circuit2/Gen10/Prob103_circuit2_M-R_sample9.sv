module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Intermediate wire for XOR of a and b
    wire ab_xor;
    assign ab_xor = a ^ b;
    
    // Intermediate wire for XOR of c and d
    wire cd_xor;
    assign cd_xor = c ^ d;
    
    // Intermediate wire for XOR of ab_xor and cd_xor
    wire abcd_xor;
    assign abcd_xor = ab_xor ^ cd_xor;
    
    // Final output q as the inverse of abcd_xor
    assign q = ~abcd_xor;
    
endmodule