module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimized odd parity check using balanced XOR tree
    assign q = (a ^ b) ^ (c ^ d);
endmodule