module TopModule(a, b, c, d, out, out_n);
    input a;
    input b;
    input c;
    input d;
    output out;
    output out_n;

    wire and1_out;
    wire and2_out;

    and g1(and1_out, a, b);
    and g2(and2_out, c, d);
    or g3(out, and1_out, and2_out);
    not g4(out_n, out);

endmodule