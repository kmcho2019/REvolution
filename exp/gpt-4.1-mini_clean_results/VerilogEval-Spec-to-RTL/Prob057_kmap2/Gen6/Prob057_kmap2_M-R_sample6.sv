module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Directly implement the minimized expression with inline negations
assign out = (~d & ~a) | (~c & ~b) | (c & d & (a | b));

endmodule