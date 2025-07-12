module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = x & ~y; // Simplified expression for ModuleA
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = ~(x ^ y); // Simplified expression for ModuleB
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    ModuleA A(x, y, a);
    ModuleB B(x, y, b);

    assign z = a ^ b; // Simplified expression for TopModule
endmodule