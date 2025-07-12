module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (a & ~b) | (b & c) | (a & b);

endmodule