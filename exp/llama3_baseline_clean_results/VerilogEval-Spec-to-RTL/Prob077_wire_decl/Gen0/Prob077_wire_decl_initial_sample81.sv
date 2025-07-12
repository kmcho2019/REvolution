module TopModule(a, b, c, d, out, out_n);
    input a;
    input b;
    input c;
    input d;
    output out;
    output out_n;
    wire and_or1;
    wire and_or2;

    and gate1(a, b, and_or1);
    and gate2(c, d, and_or2);
    or gate3(and_or1, and_or2, out);
    not gate4(out, out_n);
endmodule