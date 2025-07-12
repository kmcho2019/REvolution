module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b, or_out, and_out;

    assign a = (x ^ y) & x; // Directly compute ModuleA's output
    assign b = (x & y) | (!(x | y)); // Directly compute ModuleB's output

    assign or_out = a | b; // Compute OR of ModuleA and ModuleB outputs
    assign and_out = a & b; // Compute AND of ModuleA and ModuleB outputs
    assign z = or_out ^ and_out; // Apply XOR to OR and AND results
endmodule