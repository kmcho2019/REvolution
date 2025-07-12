module TopModule(a, b, c, d, out, out_n);
    input a, b, c, d;
    output out, out_n;

    wire and1_out, and2_out;

    and gate1(a, b, and1_out);
    and gate2(c, d, and2_out);
    or  gate3(and1_out, and2_out, out);
    not gate4(out, out_n);

endmodule