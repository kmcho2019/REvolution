module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (b & (a | ~a)) | (~a & ~b & c & ~d) | (~a & b & ~c);
endmodule