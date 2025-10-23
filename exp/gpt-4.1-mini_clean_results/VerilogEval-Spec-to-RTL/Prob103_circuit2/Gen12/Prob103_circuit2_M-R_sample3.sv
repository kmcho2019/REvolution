module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Output is 1 when number of inputs set to '1' is even (including zero)
    // This can be computed as the negation of XOR of all inputs (even parity)
    assign q = ~(a ^ b ^ c ^ d);

endmodule