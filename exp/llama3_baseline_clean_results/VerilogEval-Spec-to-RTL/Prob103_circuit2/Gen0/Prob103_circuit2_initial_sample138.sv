module TopModule(a, b, c, d, q);
    input  a;
    input  b;
    input  c;
    input  d;
    output q;

    assign q = (~a & ~b & ~d) | (~a & b & c & ~d) | (~a & b & ~c & d) | (~a & ~b & c & d) | (a & ~b & d) | (a & ~b & c & ~d) | (a & b & ~c & ~d) | (a & b & c & d);
endmodule