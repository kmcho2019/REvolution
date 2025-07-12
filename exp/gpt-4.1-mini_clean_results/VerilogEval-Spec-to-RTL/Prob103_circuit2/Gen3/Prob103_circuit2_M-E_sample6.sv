module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire p1, p2;

    // Compute parity of first pair (a, b)
    assign p1 = a ^ b;

    // Compute parity of second pair (c, d)
    assign p2 = c ^ d;

    // Final output: q is high if overall parity is even
    assign q = ~(p1 ^ p2);

endmodule