module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // q is high when the number of ones in inputs a,b,c,d is even (even parity).
    // This is equivalent to the XNOR of all inputs.
    assign q = ~(a ^ b ^ c ^ d);

endmodule