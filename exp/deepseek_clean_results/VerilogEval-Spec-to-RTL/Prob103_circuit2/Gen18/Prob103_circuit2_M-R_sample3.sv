module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Compute even parity in a single expression
    assign q = ~(a ^ b ^ c ^ d);

endmodule