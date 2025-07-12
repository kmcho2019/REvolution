module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // Direct implementation of the observed pattern using XOR gates
    assign q = ~(a ^ b ^ c ^ d);

endmodule