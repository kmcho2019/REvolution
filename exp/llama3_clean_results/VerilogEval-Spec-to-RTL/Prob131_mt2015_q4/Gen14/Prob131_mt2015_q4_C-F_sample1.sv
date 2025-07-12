module ModuleA(x, y, z);
    input x, y;
    output z;
    assign z = (x ^ y) & x;
endmodule

module ModuleB(x, y, z);
    input x, y;
    output z;
    assign z = (x & y) | (!(x | y)); // Simplified logic for ModuleB
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, or_out, and_out;

    ModuleA A1(x, y, a);
    ModuleB B1(x, y, b);

    assign or_out = a | b; // Directly compute OR of ModuleA and ModuleB outputs
    assign and_out = a & b; // Directly compute AND of ModuleA and ModuleB outputs
    assign z = or_out ^ and_out; // Apply XOR to OR and AND results
endmodule