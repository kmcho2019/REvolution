module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Inverted inputs used in the minimized expression
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Common OR term used in the last product term
wire a_or_b = a | b;

// Minimized logic expression derived from Karnaugh map:
// out = (~d & ~a) | (~c & ~b) | (c & d & (a | b))
//
// Explanation:
// - (~d & ~a) covers cells where d=0 and a=0
// - (~c & ~b) covers cells where c=0 and b=0
// - (c & d & (a | b)) covers cells where c=1, d=1, and either a=1 or b=1
assign out = (nd & na) | (nc & nb) | (c & d & a_or_b);

endmodule