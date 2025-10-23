module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Efficient implementation using XOR tree for parity check
    wire xor_ab = a ^ b;
    wire xor_cd = c ^ d;
    assign q = ~(xor_ab ^ xor_cd);  // Final XNOR

endmodule