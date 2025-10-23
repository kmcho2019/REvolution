module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // don't-care input, ignored
    output out
);

wire not_a = ~a;
wire not_b = ~b;

wire c_and_notb = c & not_b;
wire c_and_notb_and_nota = c_and_notb & not_a;

assign out = a | c_and_notb_and_nota;

endmodule