module TopModule(a, b, c, d, out);
    input a;
    input b;
    input c;
    input d;
    output out;

    assign out = (c == 1'b1) ? (a || b) : 
                 (a && b) || (!a && !b && !d) || (a && !b && !d);

endmodule