module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (~a & ~c) | (~a & ~d) | (a & c & ~b) | (a & b & c) | (a & b & d);

endmodule