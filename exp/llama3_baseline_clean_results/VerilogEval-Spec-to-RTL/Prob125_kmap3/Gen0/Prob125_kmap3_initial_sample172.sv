module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (b && !a) || (a && c) || (a && b);
endmodule