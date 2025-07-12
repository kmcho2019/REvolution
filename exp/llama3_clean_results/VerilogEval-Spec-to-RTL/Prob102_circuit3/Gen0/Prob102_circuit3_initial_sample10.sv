module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;

    assign q = (b) | (a & d);
endmodule