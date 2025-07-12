module ModuleA(x, y, z);
    input x, y;
    output z;
    // Optimization: Directly implement the logic to minimize operations
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    // Optimization: Simplify the logic for ModuleB
    assign z = (x & y) | (~x & ~y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;

    // Instantiate ModuleA and ModuleB, connecting inputs directly
    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    // Optimization: Directly implement the combinational logic
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    assign z = or_out ^ and_out;
endmodule