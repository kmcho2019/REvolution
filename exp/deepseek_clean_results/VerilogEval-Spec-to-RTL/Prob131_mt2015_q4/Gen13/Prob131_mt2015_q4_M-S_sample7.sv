module TopModule(
    input x,
    input y,
    output z
);
    wire a_out = x & ~y;    // Simplified ModuleA logic
    wire b_out = ~(x | y);  // Simplified ModuleB logic
    
    assign z = a_out ^ b_out;
endmodule