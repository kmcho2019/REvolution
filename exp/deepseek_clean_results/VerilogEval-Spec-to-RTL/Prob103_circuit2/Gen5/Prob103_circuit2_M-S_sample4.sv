module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Direct XOR chain for parity, then invert for even parity
    assign q = ~(a ^ b ^ c ^ d);

endmodule