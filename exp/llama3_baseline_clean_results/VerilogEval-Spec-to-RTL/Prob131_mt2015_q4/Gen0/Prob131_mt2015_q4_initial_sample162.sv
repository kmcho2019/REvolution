// Define Module A
module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

// Define Module B
module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!x & !y);
endmodule

// Define the top-level module
module TopLevelModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

    // Instantiate the submodules
    ModuleA A1(x, y, a1_out);
    ModuleB B1(x, y, b1_out);
    ModuleA A2(x, y, a2_out);
    ModuleB B2(x, y, b2_out);

    // Connect the submodules to the OR and AND gates
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Connect the OR and AND gates to the XOR gate
    assign z = or_out ^ and_out;
endmodule