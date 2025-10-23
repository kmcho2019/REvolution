module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Compute parity using parallel XOR tree structure
    wire ab_xor, cd_xor;
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    assign q = ~(ab_xor ^ cd_xor);  // XNOR of intermediate results

endmodule