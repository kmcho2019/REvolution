module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted inputs reused to save gates and power
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared OR sub-expressions to reduce duplicated logic
wire na_or_nb = na | nb; // (~a | ~b)
wire a_or_b   = a  | b;  // (a | b)

// Implement Karnaugh map minimized logic with shared signals:
// out = (~c & ~d & (~a | ~b)) |
//       (~c &  d & ~b)        |
//       ( c & ~d & ~a)        |
//       ( c &  d & (a | b))
//
// Explanation:
// - (~c & ~d & (~a | ~b)) covers cells where c=0,d=0 and a=0 or b=0
// - (~c &  d & ~b) covers cells where c=0,d=1,b=0
// - ( c & ~d & ~a) covers cells where c=1,d=0,a=0
// - ( c &  d & (a | b)) covers cells where c=1,d=1 and a=1 or b=1
assign out = (nc & nd & na_or_nb) |
             (nc &  d & nb)      |
             ( c & nd & na)      |
             ( c &  d & a_or_b);

endmodule