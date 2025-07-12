module ModuleA(x, y, z);
    input x, y;
    output z;
    // Optimized logic for ModuleA: x & ~y
    assign z = x & ~y;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    // Optimized logic for ModuleB: ~(x ^ y)
    assign z = ~(x ^ y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;

    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    // Connecting outputs to OR and AND gates as specified
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;
    // Final XOR operation
    assign z = or_out ^ and_out;
endmodule