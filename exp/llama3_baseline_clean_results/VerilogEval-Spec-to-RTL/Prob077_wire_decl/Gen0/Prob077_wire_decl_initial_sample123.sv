module TopModule(a, b, c, d, out, out_n);
    input a;
    input b;
    input c;
    input d;
    output out;
    output out_n;

    wire and_out1;
    wire and_out2;

    and gate1(and_out1, a, b);
    and gate2(and_out2, c, d);
    or  gate3(out, and_out1, and_out2);
    not gate4(out_n, out);

endmodule