module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;
    assign out = (~a & ~c) | (~a & d) | (b & c) | (a & b & ~c);
endmodule