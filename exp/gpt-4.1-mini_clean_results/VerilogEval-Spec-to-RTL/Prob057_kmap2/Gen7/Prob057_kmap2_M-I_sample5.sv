module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire a_or_b = a | b;

// Implement minimized logic with minimal explicit inversions
assign out = (~d & ~a) | (~c & ~b) | (c & d & a_or_b);

endmodule