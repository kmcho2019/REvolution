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

wire a_or_b = a | b;

// Minimal SOP expression:
// out = (~d & ~a) | (~c & ~b) | (c & d & (a | b))
assign out = (nd & na) | (nc & nb) | (c & d & a_or_b);

endmodule