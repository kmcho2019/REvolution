module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

wire and_1;
wire and_2;

// First layer: AND gates
assign and_1 = a & b;
assign and_2 = c & d;

// Second layer: OR gate and NOT gate
assign out = and_1 | and_2;
assign out_n = ~out;

endmodule