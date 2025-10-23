module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Implementing the simplified Boolean expression
assign out = d | (a & ~c) | (b & ~d);

endmodule