module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;

    ModuleA A1(x, y, z1);
    ModuleB B1(x, y, z2);
    ModuleA A2(x, y, z3);
    ModuleB B2(x, y, z4);
    wire z1, z2, z3, z4;

    assign z = ((z1 | z2) ^ (z3 & z4));
endmodule