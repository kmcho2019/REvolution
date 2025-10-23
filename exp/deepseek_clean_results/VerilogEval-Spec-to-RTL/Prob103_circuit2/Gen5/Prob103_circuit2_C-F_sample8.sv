module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // Even parity checker: q=1 when even number of inputs are 1 (0, 2, or 4)
    // Implemented with XNOR for direct even parity computation
    assign q = ~(a ^ b ^ c ^ d);
endmodule