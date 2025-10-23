module HybridModule(x, y, z);
    input x, y;
    output z;
    wire xor_out, and_out, or_out;

    // Shared logic for both ModuleA and ModuleB
    wire xy_xor = x ^ y;
    wire xy_and = x & y;
    wire not_x_not_y =!x &!y;

    // Calculate outputs for ModuleA and ModuleB
    wire a_out = xy_xor & x;
    wire b_out = xy_and | not_x_not_y;

    // Apply OR, AND, and XOR operations
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    assign z = or_out ^ and_out;
endmodule

module TopModule(x, y, z);
    input x, y;
    output z;
    wire hybrid_out;

    HybridModule hybrid_module(x, y, hybrid_out);
    assign z = hybrid_out;
endmodule