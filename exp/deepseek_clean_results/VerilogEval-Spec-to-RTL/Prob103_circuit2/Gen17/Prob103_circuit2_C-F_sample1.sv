module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Optimized even parity detector with balanced XOR tree
    assign q = ~((a ^ b) ^ (c ^ d));
endmodule