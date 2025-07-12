module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

wire na_or_nb = na | nb;
wire a_or_b = a | b;

// c=0 term
wire out_c0 = (nd & na_or_nb) | (d & nb);
// c=1 term
wire out_c1 = (nd & na) | (d & a_or_b);

assign out = (nc & out_c0) | (c & out_c1);

endmodule