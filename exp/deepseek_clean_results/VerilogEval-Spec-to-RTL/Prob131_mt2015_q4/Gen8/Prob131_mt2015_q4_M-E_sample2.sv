module TopModule(
    input x,
    input y,
    output z
);
    // Compute shared intermediate signals
    wire a_out = x & ~y;        // Simplified ModuleA function
    wire b_out = ~(x ^ y);      // Simplified ModuleB function (XNOR)
    
    // Compute first level logic
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule