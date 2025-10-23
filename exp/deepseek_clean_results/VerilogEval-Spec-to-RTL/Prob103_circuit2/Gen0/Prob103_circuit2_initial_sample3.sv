module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // The output is 1 when there's an even number of 1's in the inputs
    assign q = ~(a ^ b ^ c ^ d);

endmodule