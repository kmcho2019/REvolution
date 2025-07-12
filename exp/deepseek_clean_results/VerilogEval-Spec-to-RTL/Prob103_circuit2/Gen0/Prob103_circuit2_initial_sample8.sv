module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    // The output is 1 when an even number of inputs are 1 (0, 2, or 4)
    assign q = ~(a ^ b ^ c ^ d);
endmodule