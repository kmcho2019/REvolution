module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the minimized Boolean expression
// This expression is derived by analyzing the Karnaugh map and identifying the essential prime implicants
assign out = (a & b) | (c & ~d) | (~c & a & ~b) | (~c & ~a & d);

endmodule