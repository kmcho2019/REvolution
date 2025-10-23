module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (~a & ~d) | (~b & c) | (b & c & ~d);

endmodule