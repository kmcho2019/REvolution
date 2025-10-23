module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Implement 4-input XNOR using XOR tree for better PPA
    wire xor_ab = a ^ b;
    wire xor_cd = c ^ d;
    assign q = ~(xor_ab ^ xor_cd);  // Final XNOR

endmodule