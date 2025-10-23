module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// q is the negation of the XOR of all inputs (even parity)
assign q = ~(a ^ b ^ c ^ d);

endmodule