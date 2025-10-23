module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Shared negations
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Implement minimized expression:
// out = (~b & ~c) | (~a & ~b & ~d) | (~a & b & c & d) | (a & ~b & c)
wire term1 = nb & nc;
wire term2 = na & nb & nd;
wire term3 = na & b & c & d;
wire term4 = a & nb & c;

assign out = term1 | term2 | term3 | term4;

endmodule