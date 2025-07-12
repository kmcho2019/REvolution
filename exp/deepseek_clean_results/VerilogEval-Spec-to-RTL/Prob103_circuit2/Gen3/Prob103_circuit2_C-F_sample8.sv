module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Output is 1 when number of 1s is even (0, 2, or 4)
    // This includes the all-zeros case (0000) and all-ones case (1111)
    assign q = ~(a ^ b ^ c ^ d);

endmodule