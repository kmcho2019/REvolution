module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    wire term_cd0 = (nd & (na | nb)) | (d & nb);  // (~d & (~a | ~b)) | (d & ~b)
    wire term_cd1 = (nd & na) | (d & (a | b));    // (~d & ~a) | (d & (a | b))

    assign out = (nc & term_cd0) | (c & term_cd1);

endmodule