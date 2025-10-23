module A(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module B(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y);
endmodule

module top_module(x, y, z);
    input x, y;
    output z;
    wire w1, w2;
    A a1(x, y, w1);
    B b1(x, y, w2);
    A a2(x, y, w1);
    B b2(x, y, w2);
    assign z = (w1 | w2) ^ (w1 & w2);
endmodule