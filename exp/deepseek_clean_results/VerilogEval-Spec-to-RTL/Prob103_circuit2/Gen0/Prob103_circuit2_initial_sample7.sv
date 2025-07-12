module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // The output is 1 when the number of 1s is even (0, 2, or 4)
    assign q = ~(a ^ b ^ c ^ d);

endmodule