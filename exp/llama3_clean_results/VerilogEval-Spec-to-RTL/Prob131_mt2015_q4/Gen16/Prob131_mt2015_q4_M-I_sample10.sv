module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (x ^ y);
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, or_ab;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    assign or_ab = a | b;
    assign z = or_ab ^ (a & b);
endmodule