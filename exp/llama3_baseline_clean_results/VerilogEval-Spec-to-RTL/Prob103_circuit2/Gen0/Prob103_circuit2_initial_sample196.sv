module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;

    assign q = ~(a & b & c & ~d) & ~(a & ~b & ~c & ~d) & ~(~a & b & c & ~d);
    // The equation can be optimized to:
    // assign q = ~((a & b & c & ~d) | (a & ~b & ~c & ~d) | (~a & b & c & ~d));
endmodule