module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal implementation using XOR chain for even parity
    assign q = ~(a ^ b ^ c ^ d);

endmodule