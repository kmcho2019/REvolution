module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Implementing minimized logic:
// out = (~d & ~a) | (~c & ~b) | (c & d & (a | b))
wire a_or_b = a | b;

assign out = (nd & na) | (nc & nb) | (c & d & a_or_b);

endmodule