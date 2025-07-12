module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    assign out = (a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & b & ~c & d) | (a & ~b & c & d) | 
                 (~a & b & c & ~d) | (a & b & c & ~d) | (~a & ~b & ~c & d) | (a & ~b & ~c & d);

    // Alternatively, a more optimized and simplified version after analyzing the Karnaugh map could be:
    // assign out = (b ^ c) & (a ^ d);

endmodule