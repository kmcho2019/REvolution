module UnifiedProcessingUnit(
    input x,
    input y,
    input mode,  // 0 for ModuleA, 1 for ModuleB
    output reg z
);
    always @(*) begin
        if (!mode)
            z = x & ~y;  // ModuleA function
        else
            z = ~(x ^ y); // ModuleB function
    end
endmodule

module TopModule(
    input x,
    input y,
    input clk,
    output z
);
    reg toggle = 0;
    wire a_out, b_out;
    reg a_reg, b_reg;
    
    // Mode selector
    always @(posedge clk) begin
        toggle <= ~toggle;
    end
    
    // Unified processing unit
    UnifiedProcessingUnit UPU(
        .x(x),
        .y(y),
        .mode(toggle),
        .z(a_out)
    );
    
    // Store results on appropriate cycles
    always @(posedge clk) begin
        if (!toggle) a_reg <= a_out;  // Store ModuleA result
        else b_reg <= a_out;          // Store ModuleB result
    end
    
    // Output logic (same as original but with registered inputs)
    assign z = a_reg ^ b_reg;
endmodule