module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Shared inverted signals
wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

// Shared common OR terms for partial functions
wire na_or_nb = na | nb;   // (~a | ~b)
wire a_or_b   = a  | b;    // (a | b)

// Partial functions per cd combination using factored expressions:
// cd = 00: F_00 = ~a | ~b
wire F_00 = na_or_nb;

// cd = 01: F_01 = ~b
wire F_01 = nb;

// cd = 10: F_10 = ~a
wire F_10 = na;

// cd = 11: F_11 = a | b
wire F_11 = a_or_b;

// One-hot select lines for cd:
// cd=00 -> c=0,d=0
wire sel_00 = nc & nd;
// cd=01 -> c=0,d=1
wire sel_01 = nc & d;
// cd=10 -> c=1,d=0
wire sel_10 = c  & nd;
// cd=11 -> c=1,d=1
wire sel_11 = c  & d;

// Mux logic - one-hot select lines enable exactly one partial function output
wire out_00 = sel_00 & F_00;
wire out_01 = sel_01 & F_01;
wire out_10 = sel_10 & F_10;
wire out_11 = sel_11 & F_11;

// Final output is OR of the selected partial function
assign out = out_00 | out_01 | out_10 | out_11;

endmodule