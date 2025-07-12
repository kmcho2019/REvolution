module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Simplified logic based on the Karnaugh map
assign out = (~c & ~d) | (~c & d & ~a) | (c & d & a & b) | (c & ~d & a & ~b) | (~a & ~c & ~d);

endmodule