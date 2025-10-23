module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Optimal implementation: single XNOR operation for even parity
    assign q = ~(a ^ b ^ c ^ d);
endmodule