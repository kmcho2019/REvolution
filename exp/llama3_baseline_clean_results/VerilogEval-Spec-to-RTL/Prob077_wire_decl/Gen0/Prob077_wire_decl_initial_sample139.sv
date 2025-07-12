module TopModule(a, b, c, d, out, out_n);
    input a;
    input b;
    input c;
    input d;
    output out;
    output out_n;

    wire and_gate1_out;
    wire and_gate2_out;

    and gate1(a, b, and_gate1_out);
    and gate2(c, d, and_gate2_out);
    or  gate3(and_gate1_out, and_gate2_out, out);
    not gate4(out, out_n);

endmodule