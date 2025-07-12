module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored
    output out
);

// Factorized logic:
// out = (~c & a) | (c & (~b | a))

wire not_c = ~c;
wire not_b = ~b;
wire inner_or = not_b | a;

assign out = (not_c & a) | (c & inner_or);

endmodule