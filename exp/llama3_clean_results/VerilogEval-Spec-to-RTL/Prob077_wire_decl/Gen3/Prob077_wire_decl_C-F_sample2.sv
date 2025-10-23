module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out1;
wire and_out2;

// First layer: AND gates
assign and_out1 = a & b;
assign and_out2 = c & d;

// Second layer: OR gate
assign out = and_out1 | and_out2;

// Inverted output
assign out_n = ~out;

endmodule