module TopModule(x, y, z);
    input x, y;
    output z;

    // Directly compute the output of ModuleA and ModuleB
    wire a, b;
    assign a = (x ^ y) & x;
    assign b = (x & y) | (!x &!y);

    // Apply the OR and AND operations
    wire or_out, and_out;
    assign or_out = a | b;
    assign and_out = a & b;

    // Finally, apply the XOR operation to get the output z
    assign z = or_out ^ and_out;
endmodule