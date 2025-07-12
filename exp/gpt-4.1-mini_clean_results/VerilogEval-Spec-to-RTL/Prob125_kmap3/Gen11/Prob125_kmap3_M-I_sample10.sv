module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored
    output out
);

wire not_a = ~a;
wire not_b = ~b;

assign out = a | (c & not_b & not_a);

endmodule