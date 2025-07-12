module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Direct implementation of the Karnaugh map using logical expressions
assign out = (~c & ~d & b) | (c & ~d & ~b) | (~c & d & ~b) | (c & d & b);

endmodule