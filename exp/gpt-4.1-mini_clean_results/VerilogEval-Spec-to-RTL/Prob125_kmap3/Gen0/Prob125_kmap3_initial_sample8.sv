module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire term1, term2, term3;

    assign term1 = a & ~b;
    assign term2 = c & ((~a & ~b) | a);
    assign term3 = a & b & ~c & ~d;

    assign out = term1 | term2 | term3;

endmodule