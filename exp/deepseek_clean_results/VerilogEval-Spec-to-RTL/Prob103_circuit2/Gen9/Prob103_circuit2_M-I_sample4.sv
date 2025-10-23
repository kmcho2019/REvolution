module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // XOR tree for parity detection
    wire ab_xor = a ^ b;
    wire abc_xor = ab_xor ^ c;
    wire abcd_xor = abc_xor ^ d;
    
    // Invert to get even parity
    assign q = ~abcd_xor;
endmodule