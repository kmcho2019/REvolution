module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (a == 1'b1) || (c == 1'b1 && b == 1'b1);

endmodule