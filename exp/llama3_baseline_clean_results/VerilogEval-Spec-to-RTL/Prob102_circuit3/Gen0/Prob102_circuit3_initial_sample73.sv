module TopModule(a, b, c, d, q);
    input a;
    input b;
    input c;
    input d;
    output q;
    assign q = (a & b) | (a & c) | (b & c) | (d & (a | b));
endmodule