module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// When 'a' is 1, out is always 1
// When 'a' is 0, the output depends on 'b' and 'c'
assign out = a ? 1'b1 : ((~b && c) ? 1'b1 : (b && c) ? 1'b1 : (b && ~c) ? 1'b1 : 1'b1);

// Alternatively, using a more explicit MUX-like approach
// assign out = (a) ? 1'b1 : ((~b && ~c) ? 1'b0 : 1'b1);

endmodule