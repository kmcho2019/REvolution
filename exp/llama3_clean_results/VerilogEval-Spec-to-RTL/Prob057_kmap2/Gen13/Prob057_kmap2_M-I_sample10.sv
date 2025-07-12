module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the minimized Boolean expression
assign out = (~c & ~d & a) | (~c & d & ~b) | (~c & d & a) | (c & d & ~a & ~b) | (c & ~d & a & b) | (~c & ~d & ~a & b) | (c & d & a & b) | (~c & d & ~a & b);

// Simplifying the expression by removing duplicate and redundant terms
assign out = (~c & ~d & a) | (~c & d & (~b | a)) | (c & d & (~a & ~b | a & b)) | (~c & ~d & ~a & b);

// Final simplified expression after applying the rules of Boolean algebra
assign out = (~c & (~d & a | d & (~b | a))) | (c & d & (~a & ~b | a & b));

// Further simplification by factoring out common terms
assign out = (~c & (~d & a | d)) | (c & d & (a | ~a) & (~b | b));

// Simplifying using the properties of Boolean algebra, where (a | ~a) = 1 and (~b | b) = 1
assign out = (~c & (~d & a | d)) | (c & d);

// Factoring out 'd' from the first term
assign out = (~c & d | ~c & ~d & a) | (c & d);

// Applying the distributive property
assign out = (~c & (d | ~d & a)) | (c & d);

// Simplifying using the properties of Boolean algebra, where (d | ~d) = 1
assign out = (~c & (d | a)) | (c & d);

// Final simplified expression
assign out = (~c & d) | (~c & a) | (c & d);

// Simplifying further by applying the rules of Boolean algebra
assign out = d | (~c & a);

endmodule