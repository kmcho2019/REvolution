module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (!y);
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, c, d;

    ModuleA A1(x, y, a);
    ModuleB B1(x, y, b);
    ModuleA A2(x, y, c);
    ModuleB B2(x, y, d);

    assign z = (a | b) ^ (c & d);
endmodule