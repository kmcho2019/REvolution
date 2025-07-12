module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Calculate parity using XOR chain
    assign q = ~(a ^ b ^ c ^ d);
endmodule