module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Negations reused for partial functions
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Partial functions per (c,d) group derived from minimal SOP:
// cd=00: ~a | ~b
wire F_00 = na | nb;

// cd=01: ~b
wire F_01 = nb;

// cd=10: ~a
wire F_10 = na;

// cd=11: a | b
wire F_11 = a | b;

// One-hot select signals for cd
wire sel_00 = nc & nd; // c=0,d=0
wire sel_01 = nc & d;  // c=0,d=1
wire sel_10 = c & nd;  // c=1,d=0
wire sel_11 = c & d;   // c=1,d=1

// Multiplexer: enable only one function per cd
assign out =
    (sel_00 & F_00) |
    (sel_01 & F_01) |
    (sel_10 & F_10) |
    (sel_11 & F_11);

endmodule