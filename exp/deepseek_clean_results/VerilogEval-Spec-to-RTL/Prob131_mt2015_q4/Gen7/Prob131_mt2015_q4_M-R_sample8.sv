module TopModule(
    input x,
    input y,
    output z
);
    // Compute each unique function once
    wire a_out = (x ^ y) & x;  // ModuleA function
    wire b_out = ~(x ^ y);     // ModuleB function
    
    // Final logic - same as original but with shared computations
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule