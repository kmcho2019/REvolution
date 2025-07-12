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
    wire a, b;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    // Simplified expression for (a | b) ^ (a & b)
    assign z = a ^ b;
endmodule