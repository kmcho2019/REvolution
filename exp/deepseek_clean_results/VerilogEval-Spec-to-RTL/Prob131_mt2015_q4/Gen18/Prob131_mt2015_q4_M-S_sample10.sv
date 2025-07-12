module TopModule(
    input x,
    input y,
    output z
);
    wire a_out = x & ~y;       // ModuleA implementation
    wire b_out = ~(x ^ y);     // ModuleB implementation (XNOR)
    
    assign z = a_out ^ b_out;  // Final output
endmodule