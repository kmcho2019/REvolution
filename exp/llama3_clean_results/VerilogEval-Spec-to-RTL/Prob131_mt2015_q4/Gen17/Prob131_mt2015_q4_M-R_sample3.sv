module RefactoredTopModule(x, y, z);
    input x, y;
    output z;

    // Directly implement ModuleA logic
    wire a = (x ^ y) & x;

    // Directly implement ModuleB logic
    wire b = (x == y);

    // Compute OR and AND outputs
    wire or_out = a | b;
    wire and_out = a & b;

    // Combine OR and AND outputs through XOR
    assign z = or_out ^ and_out;
endmodule

// Alternative implementation with further simplification
module SimplifiedRefactoredTopModule(x, y, z);
    input x, y;
    output z;

    // Directly compute the output
    assign z = ((x ^ y) & x) | (x == y) ^ (((x ^ y) & x) & (x == y));
endmodule