module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nd = ~d;

// Term1: ~a
wire term1 = na;

// Term2: a & ~b & ~d
wire term2 = a & nb & nd;

// Term3: c & d & (a + b)
wire term3 = c & d & (a | b);

// Output is OR of all terms
assign out = term1 | term2 | term3;

endmodule