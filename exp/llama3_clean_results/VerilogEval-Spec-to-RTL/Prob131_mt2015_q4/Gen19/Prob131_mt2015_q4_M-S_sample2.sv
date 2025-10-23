module TopModule(x, y, z);
    input x, y;
    output z;
    wire a_out1, b_out1, a_out2, b_out2, or_out, and_out;

    // Compute ModuleA and ModuleB outputs
    assign a_out1 = (x ^ y) & x;
    assign b_out1 = ~(x ^ y);
    assign a_out2 = (x ^ y) & x;
    assign b_out2 = ~(x ^ y);

    // Apply OR and AND operations
    assign or_out = a_out1 | b_out1;
    assign and_out = a_out2 & b_out2;

    // Apply XOR operation
    assign z = or_out ^ and_out;
endmodule