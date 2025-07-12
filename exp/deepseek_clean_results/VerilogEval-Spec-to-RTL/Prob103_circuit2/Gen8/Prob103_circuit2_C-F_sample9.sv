module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Balanced XOR tree for even parity check
    assign q = ~((a ^ b) ^ (c ^ d));
endmodule