module TopModule(a, b, c, out);
    input a;
    input b;
    input c;
    output out;

    assign out = c | a;

endmodule