module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire p;  // parity of a, b, c

    assign p = a ^ b ^ c;    // intermediate parity
    assign q = ~(p ^ d);     // XNOR of parity p and input d

endmodule