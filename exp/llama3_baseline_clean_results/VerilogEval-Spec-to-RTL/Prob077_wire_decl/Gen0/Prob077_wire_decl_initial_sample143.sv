module TopModule(a, b, c, d, out, out_n);
    input a, b, c, d;
    output out, out_n;

    wire and1_out, and2_out;

    assign and1_out = a & b;
    assign and2_out = c & d;
    assign out = and1_out | and2_out;
    assign out_n = ~out;

endmodule