module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Minimal sum-of-products expression from K-map minimization
assign out = 
    (~c & ~d & ~a) |
    (~c & ~d & ~b) |
    (~c &  d & ~b) |
    ( c & ~d & ~a) |
    ( c &  d &  a) |
    ( c &  d &  b);

endmodule