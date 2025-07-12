module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal implementation using XOR for even parity check
    assign q = ~(a ^ b ^ c ^ d);
endmodule