module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored
    output out
);

wire not_c = ~c;
wire not_b = ~b;

wire or_ab = not_b | a; // Shared OR term

assign out = (not_c & a) | (c & or_ab);

endmodule