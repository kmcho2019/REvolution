module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;

    assign q = (a & b) | (a & c) | (a & d) | (b & c) | (b & d) | (c & d);
endmodule