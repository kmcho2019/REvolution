module UnifiedProcessingUnit(
    input x,
    input y,
    input select,  // 0 for ModuleA function, 1 for ModuleB function
    output z
);
    // Combined implementation using multiplexed logic
    wire module_a_out = x & ~y;      // Original ModuleA function
    wire module_b_out = ~(x ^ y);   // Original ModuleB function
    
    assign z = select ? module_b_out : module_a_out;
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Control pattern to select between functions
    // Pattern: 0 (ModuleA), 1 (ModuleB), 0 (ModuleA), 1 (ModuleB)
    reg [1:0] select_pattern = 2'b01;  // Alternating pattern
    
    wire out1, out2, out3, out4;
    
    // Instantiate four processing units with alternating select
    UnifiedProcessingUnit U1(.x(x), .y(y), .select(select_pattern[0]), .z(out1));
    UnifiedProcessingUnit U2(.x(x), .y(y), .select(select_pattern[1]), .z(out2));
    UnifiedProcessingUnit U3(.x(x), .y(y), .select(select_pattern[0]), .z(out3));
    UnifiedProcessingUnit U4(.x(x), .y(y), .select(select_pattern[1]), .z(out4));
    
    // Combine outputs as per original specification
    wire or_out = out1 | out2;
    wire and_out = out3 & out4;
    
    assign z = or_out ^ and_out;
endmodule