module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Implementing the simplified Karnaugh map expression
assign out = (a & ~c & ~d) | (~a & b & ~c) | (~a & b & d) | (~c & d & ~b) | (a & b & ~c) | (a & ~b & d) | (~a & ~b & ~c & d);

endmodule