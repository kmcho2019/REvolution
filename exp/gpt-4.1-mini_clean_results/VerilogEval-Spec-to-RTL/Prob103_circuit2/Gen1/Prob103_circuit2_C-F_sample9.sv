module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Output q is 1 when the number of inputs set to 1 is even (even parity),
    // implemented as the XNOR (negated XOR) of inputs a, b, c, and d.
    assign q = ~(a ^ b ^ c ^ d);
endmodule