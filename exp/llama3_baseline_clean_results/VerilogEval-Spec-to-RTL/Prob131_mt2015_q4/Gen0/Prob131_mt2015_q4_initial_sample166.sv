module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y);
endmodule

module top_level(x, y, z);
    input x, y;
    output z;
    wire w1, w2;

    ModuleA A1(x, y, w1);
    ModuleB B1(x, y, w2);
    assign z1 = w1 | w2;

    ModuleA A2(x, y, w3);
    ModuleB B2(x, y, w4);
    assign z2 = w3 & w4;

    assign z = z1 ^ z2;

    wire w3, w4, z1, z2;
endmodule