module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (a == 0 && b == 1) || (a == 1 && b == 1) || (c == 1 && a == 0 && b == 0);

endmodule