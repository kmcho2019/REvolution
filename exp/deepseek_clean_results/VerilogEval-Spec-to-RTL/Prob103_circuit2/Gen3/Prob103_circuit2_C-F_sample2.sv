module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Balanced XOR tree for minimal delay
    wire xor_ab = a ^ b;
    wire xor_cd = c ^ d;
    
    // Final XOR and inversion
    assign q = ~(xor_ab ^ xor_cd);
endmodule