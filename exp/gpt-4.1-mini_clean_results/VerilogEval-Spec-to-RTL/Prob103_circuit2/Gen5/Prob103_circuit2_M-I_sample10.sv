module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    // q = NOT ((a XOR b) XOR (c XOR d)) = XNOR of all four inputs in pairs
    assign q = ~((a ^ b) ^ (c ^ d));

endmodule