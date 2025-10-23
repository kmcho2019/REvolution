module TopModule(x, y, z);
    input x, y;
    output z;
    wire a1, b1, a2, b2, or_out, and_out;

    // Directly implement ModuleA logic for a1 and a2
    assign a1 = (x ^ y) & x;
    assign a2 = (x ^ y) & x;

    // Directly implement ModuleB logic for b1 and b2
    assign b1 = (x & y) | (!x & !y);
    assign b2 = (x & y) | (!x & !y);

    // Implement the OR and AND gates
    assign or_out = a1 | b1;
    assign and_out = a2 & b2;

    // Final XOR operation to produce z
    assign z = or_out ^ and_out;
endmodule