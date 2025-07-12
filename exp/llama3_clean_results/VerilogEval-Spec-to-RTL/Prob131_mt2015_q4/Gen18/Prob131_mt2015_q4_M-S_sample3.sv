module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & (x ^ y);
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x &!y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    ModuleA A1(x, y, a);
    ModuleB B1(x, y, b);

    assign z = (a | b) ^ (a & b);
endmodule