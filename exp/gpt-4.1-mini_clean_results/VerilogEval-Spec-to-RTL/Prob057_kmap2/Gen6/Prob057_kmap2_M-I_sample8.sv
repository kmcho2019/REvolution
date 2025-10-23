module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement minimized logic with inline inversions
// out = (~d & ~a) | (~c & ~b) | (c & d & (a | b))

assign out = (~d & ~a) | (~c & ~b) | (c & d & (a | b));

endmodule