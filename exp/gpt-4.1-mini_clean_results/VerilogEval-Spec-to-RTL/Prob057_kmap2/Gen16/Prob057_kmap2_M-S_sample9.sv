module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Derived minimal sum of products from Karnaugh map:
// out = (~c & ~d & ~b) | (~c & d & ~b) | (c & d) | (c & ~d & ~a) | (~c & ~d & ~a)

assign out = 
    (~c & ~d & (~a | ~b)) |
    (~c & d & ~b)         |
    (c & d)               |
    (c & ~d & ~a);

endmodule