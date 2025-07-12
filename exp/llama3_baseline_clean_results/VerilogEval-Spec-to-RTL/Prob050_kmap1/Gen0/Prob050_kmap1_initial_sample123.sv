module TopModule(a, b, c, out);
    input a, b, c;
    output out;

    assign out = a | (b & c) | (b & ~c) | (~b & c);
endmodule