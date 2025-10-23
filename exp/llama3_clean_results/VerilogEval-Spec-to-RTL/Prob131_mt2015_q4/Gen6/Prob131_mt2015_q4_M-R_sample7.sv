// Refactored Version
module ModuleA(x, y, z);
    input x, y;
    output z;
    // Simplified logic using a single assign statement
    assign z = x & (x ^ y);
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    // Simplified logic for ModuleB
    assign z = (x & y) | (~x & ~y);
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;

    // Instantiating submodules
    ModuleA A1(x, y, a1);
    ModuleB B1(x, y, b1);
    ModuleA A2(x, y, a2);
    ModuleB B2(x, y, b2);

    // Calculating intermediate outputs
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;

    // Final output calculation
    assign z = or_out ^ and_out;
endmodule