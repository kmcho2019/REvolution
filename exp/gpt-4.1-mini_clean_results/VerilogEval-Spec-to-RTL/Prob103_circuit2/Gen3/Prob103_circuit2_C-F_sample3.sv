module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // q outputs 1 if the number of input bits set to 1 is even (even parity).
    // This is the XNOR of all inputs.
    assign q = ~(a ^ b ^ c ^ d);
endmodule