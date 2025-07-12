module TopModule(x, y, z);
    input x, y;
    output z;
    wire a, b;

    assign a = x & ~y; // Directly implement ModuleA logic
    assign b = ~(x ^ y); // Directly implement ModuleB logic

    assign z = a ^ b; // Compute final output z
endmodule