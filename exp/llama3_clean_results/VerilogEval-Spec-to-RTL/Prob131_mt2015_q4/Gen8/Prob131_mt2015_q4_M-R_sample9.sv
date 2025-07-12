module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x & ~y); // Simplified logic: x and not y
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (~x & ~y); // Existing logic: x and y or not x and not y
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, or_out, and_out;

    ModuleA A1(x, y, a);
    ModuleB B1(x, y, b);

    assign or_out = a | b; // OR the outputs of ModuleA and ModuleB
    assign and_out = a & b; // AND the outputs of ModuleA and ModuleB
    assign z = or_out ^ and_out; // Simplified logic: XOR the outputs of OR and AND gates
endmodule