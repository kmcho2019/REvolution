module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    wire and_out1, and_out2;

    and gate1(a, b, and_out1);
    and gate2(c, d, and_out2);
    or  gate3(and_out1, and_out2, out);
    not gate4(out, out_n);

endmodule