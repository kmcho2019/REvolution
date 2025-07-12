module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA and ModuleB functions
    wire a_out = x & ~y;
    wire b_out = ~(x ^ y);
    
    // Final output logic
    assign z = a_out ^ b_out;
endmodule