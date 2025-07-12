module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = 
    // Term 1: (~c & ~d & (~a | ~b))
    (~c & ~d & (~a | ~b)) |
    // Term 2: (~c & d & ~b)
    (~c & d & ~b) |
    // Term 3: (c & ~d & ~a)
    (c & ~d & ~a) |
    // Term 4: (c & d & (a | b))
    (c & d & (a | b));

endmodule