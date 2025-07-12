module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;

    assign q = (a && d) || (a && b) || (a && c) || (b && d) || (b && c);
endmodule