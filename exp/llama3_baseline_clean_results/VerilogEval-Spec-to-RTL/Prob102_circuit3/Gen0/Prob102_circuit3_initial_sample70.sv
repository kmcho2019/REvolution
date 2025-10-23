module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;

    assign q = (a & d) | (b & (c | d)) | (a & b);

endmodule