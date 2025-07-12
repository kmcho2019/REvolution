module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Even parity detector: q=1 when even number of inputs are 1
    // Implemented as XOR tree with final inversion for optimal PPA
    assign q = ~(a ^ b ^ c ^ d);
endmodule