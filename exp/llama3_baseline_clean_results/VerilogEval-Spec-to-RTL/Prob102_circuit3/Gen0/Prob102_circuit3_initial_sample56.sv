module TopModule(a, b, c, d, q);
    input a;
    input b;
    input c;
    input d;
    output q;
    assign q = (a & b) | (a & d) | (b & d) | (b & c) | (a & b & c) | (a & b & d) | (a & c & d) | (b & c & d) | (a & b & c & d);
endmodule