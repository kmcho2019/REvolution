module TopModule(x, y, z);
    input x, y;
    output z;

    // Simplified logic for ModuleA
    wire a_out = x & (~y);

    // Simplified logic for ModuleB
    wire b_out = ~(x ^ y);

    // Apply OR, AND, and XOR operations
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule