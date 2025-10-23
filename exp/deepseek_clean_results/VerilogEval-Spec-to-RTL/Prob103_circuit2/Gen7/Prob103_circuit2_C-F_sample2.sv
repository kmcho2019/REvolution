module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Output is 1 when even number of inputs are 1 (even parity)
    assign q = ~(a ^ b ^ c ^ d);

endmodule