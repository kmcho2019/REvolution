module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1_out, b1_out, a2_out, b2_out, or_out, and_out;

    // ModuleA
    assign a1_out = x & (~x ^ ~y);
    assign a2_out = x & (~x ^ ~y);

    // ModuleB
    assign b1_out = ~(x ^ y);
    assign b2_out = ~(x ^ y);

    // Apply OR and AND operations
    assign or_out = a1_out | b1_out;
    assign and_out = a2_out & b2_out;

    // Apply XOR operation
    assign z = or_out ^ and_out;
endmodule