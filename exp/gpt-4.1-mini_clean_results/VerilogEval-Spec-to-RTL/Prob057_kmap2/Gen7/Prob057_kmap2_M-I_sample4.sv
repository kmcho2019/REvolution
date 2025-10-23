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

// Factor common terms to reduce gate count and fan-in:
// From original:
// out = (~c & ~d & (~a | ~b)) | (~c & d & ~b) | (c & ~d & ~a) | (c & d & (a | b))
// Grouping terms by c and d:

// For c=0:
// (~c & ~d & (~a | ~b)) | (~c & d & ~b)
// = ~c & ( (~d & (~a | ~b)) | (d & ~b) )
// = ~c & ( (~d & (~a | ~b)) | (d & ~b) )

// For c=1:
// (c & ~d & ~a) | (c & d & (a | b))
// = c & ( (~d & ~a) | (d & (a | b)) )

// Further factoring inside brackets if beneficial:

wire term_c0 = (nd & (na | nb)) | (d & nb);
wire term_c1 = (nd & na) | (d & (a | b));

assign out = (nc & term_c0) | (c & term_c1);

endmodule