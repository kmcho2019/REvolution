module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Even parity check using XOR chain
    assign q = ~(a ^ b ^ c ^ d);

endmodule