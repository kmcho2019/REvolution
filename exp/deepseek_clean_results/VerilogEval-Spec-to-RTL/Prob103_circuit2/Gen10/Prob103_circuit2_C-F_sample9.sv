module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal implementation: balanced XOR tree for even parity
    // with explicit inversion for clarity
    assign q = ~(a ^ b ^ c ^ d);
endmodule