module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Balanced XOR tree implementation for even parity
    assign q = ~((a ^ b) ^ (c ^ d));
endmodule