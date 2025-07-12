module TopModule(
    input x,
    input y,
    output z
);
    // Combined optimized implementation
    wire a_out = x & ~y;  // ModuleA equivalent
    wire b_out = ~(x ^ y); // ModuleB equivalent
    
    // Final optimized output
    assign z = a_out ^ b_out;
endmodule