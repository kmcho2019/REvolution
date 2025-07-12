module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Output is 1 when even number of inputs are 1 (XOR chain)
    assign q = ~(a ^ b ^ c ^ d);

endmodule