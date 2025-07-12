module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implement minimal SOP directly, with inline inverted signals and common term
assign out = (~d & ~a) | (~c & ~b) | (c & d & (a | b));

endmodule