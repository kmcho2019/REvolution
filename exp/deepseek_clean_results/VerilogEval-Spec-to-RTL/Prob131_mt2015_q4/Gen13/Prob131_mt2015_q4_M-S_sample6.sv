module TopModule(
    input x,
    input y,
    output z
);
    wire a_out = x & ~y;      // ModuleA functionality
    wire b_out = ~(x ^ y);    // ModuleB functionality
    
    assign z = a_out ^ b_out; // Final output logic
endmodule