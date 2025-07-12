module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    assign out = (a & b) | c | (b & ~a & ~c);
endmodule