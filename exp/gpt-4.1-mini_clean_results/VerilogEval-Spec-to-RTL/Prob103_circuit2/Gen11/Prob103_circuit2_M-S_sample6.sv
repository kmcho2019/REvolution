module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Directly assign q as the inverse XOR of all inputs (even parity)
    assign q = ~(a ^ b ^ c ^ d);

endmodule