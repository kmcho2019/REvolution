module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Negations
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Partial functions corresponding to each cd row
// cd=00: F_00 = ~a + ~b
wire F_00 = na | nb;

// cd=01: F_01 = ~b
wire F_01 = nb;

// cd=11: F_11 = a + b
wire F_11 = a | b;

// cd=10: F_10 = ~a
wire F_10 = na;

// 2-bit selector (cd)
wire sel0 = nc & nd; // 00
wire sel1 = nc & d;  // 01
wire sel3 = c & d;   // 11
wire sel2 = c & nd;  // 10

// Multiplexer implementation:
// out = F_00 if cd=00
//     = F_01 if cd=01
//     = F_10 if cd=10
//     = F_11 if cd=11

// Use one-hot select lines combined with data
wire o0 = sel0 & F_00;
wire o1 = sel1 & F_01;
wire o2 = sel2 & F_10;
wire o3 = sel3 & F_11;

assign out = o0 | o1 | o2 | o3;

endmodule