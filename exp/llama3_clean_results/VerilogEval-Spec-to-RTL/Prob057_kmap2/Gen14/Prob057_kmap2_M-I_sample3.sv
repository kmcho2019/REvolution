module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the simplified Boolean expression
assign out = (~c & ~d) | (b & ~c) | (a & d);

endmodule