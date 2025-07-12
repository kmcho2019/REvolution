// Module A: z = (x ^ y) & x
module A(input x, input y, output z);
    assign z = (x ^ y) & x;
endmodule

// Module B: z = ~(x ^ y)
module B(input x, input y, output z);
    assign z = ~(x ^ y);
endmodule

// Optimized top-level module with direct Boolean expression for z
module TopModule(input x, input y, output z);
    wire a_val, b_val;

    // Compute A and B outputs as wires (no module instantiation needed)
    assign a_val = (x ^ y) & x;
    assign b_val = ~(x ^ y);

    // Final output z = A XOR B
    assign z = a_val ^ b_val;
endmodule