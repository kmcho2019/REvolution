module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (c == 1'b0 && (a == 1'b0 && b == 1'b1 || a == 1'b1 && b == 1'b0 || a == 1'b1 && b == 1'b1)) ||
                  (c == 1'b1 && a == 1'b0 && b == 1'b0 && d == 1'b0) ||
                  (c == 1'b1 && (a == 1'b1 || b == 1'b1));

endmodule