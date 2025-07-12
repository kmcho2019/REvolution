module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Intermediate signals
wire ab_xor = a ^ b;
wire c_or_d = c | d;
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Expression:
// out = ( (a XOR b) AND (c OR d) ) OR ( (~a & ~b & ~c) ) OR ( ~d & ~a )
assign out = (ab_xor & c_or_d) | (na & nb & nc) | (nd & na);

endmodule