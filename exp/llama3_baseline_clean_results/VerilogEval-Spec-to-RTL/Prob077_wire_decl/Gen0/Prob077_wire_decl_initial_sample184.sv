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

    and and_gate1(and_out1, a, b);
    and and_gate2(and_out2, c, d);
    or or_gate(out, and_out1, and_out2);
    not not_gate(out_n, out);

endmodule