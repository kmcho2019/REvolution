module NovelModule(x, y, z);
    input x, y;
    output z;
    wire or_input1, or_input2, and_input1, and_input2;

    // Directly calculate the inputs to the OR and AND gates
    assign or_input1 = x & ~y; // ModuleA's output
    assign or_input2 = ~(x ^ y); // ModuleB's output
    assign and_input1 = x & ~y; // ModuleA's output
    assign and_input2 = ~(x ^ y); // ModuleB's output

    // Apply OR and AND operations
    wire or_out, and_out;
    assign or_out = or_input1 | or_input2;
    assign and_out = and_input1 & and_input2;

    // Final XOR operation to produce z
    assign z = or_out ^ and_out;
endmodule