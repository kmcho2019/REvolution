module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_xor, cd_xor;
    
    // First level: XOR pairs of inputs
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    
    // Second level: XNOR the intermediate results
    assign q = ~(ab_xor ^ cd_xor);

endmodule