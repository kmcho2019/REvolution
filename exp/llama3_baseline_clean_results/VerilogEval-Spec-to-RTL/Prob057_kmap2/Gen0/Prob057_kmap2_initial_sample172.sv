module TopModule(a, b, c, d, out);
    input a, b, c, d;
    output out;

    assign out = (~a & ~b) | (~a & c & d) | (~b & c & ~d) | (a & ~b & c);

endmodule