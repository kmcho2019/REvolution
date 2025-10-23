module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // XOR tree implementation of even parity checker
    wire xor_ab, xor_cd;
    
    assign xor_ab = a ^ b;
    assign xor_cd = c ^ d;
    assign q = ~(xor_ab ^ xor_cd);  // Invert final XOR for even parity
endmodule