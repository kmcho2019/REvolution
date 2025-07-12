module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    assign out = (~a & ~b & c) | (~a & b & c) | (a & ~b & ~c) | (a & ~b & c) | (a & b & ~c) | (a & b & c);
endmodule