module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

wire and_out_1;
wire and_out_2;

and and_gate_1(and_out_1, a, b);
and and_gate_2(and_out_2, c, d);
or or_gate(out, and_out_1, and_out_2);
not not_gate(out_n, out);

endmodule