module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't care, ignored
    output out
);

wire not_c = ~c;
wire not_b = ~b;
wire c_and_notb_or_a = c & (not_b | a);
wire notc_and_a = not_c & a;

assign out = notc_and_a | c_and_notb_or_a;

endmodule