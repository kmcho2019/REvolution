module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;

    assign q = (a && b) || (a && c) || (b && c) || (a && d) || (b && d);
endmodule