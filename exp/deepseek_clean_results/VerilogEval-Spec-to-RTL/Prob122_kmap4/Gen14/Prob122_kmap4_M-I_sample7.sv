module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Optimal implementation of checkerboard K-map pattern using XOR */
    assign out = a ^ b ^ c ^ d;

endmodule