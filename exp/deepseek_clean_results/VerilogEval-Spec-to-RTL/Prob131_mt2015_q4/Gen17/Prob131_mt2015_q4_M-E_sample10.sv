module ModuleA(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule

module ModuleB(
    input x,
    input y,
    output reg z
);
    always @(*) begin
        z = ~(x ^ y);
    end
endmodule

module TopModule(
    input clk,
    input x,
    input y,
    output reg z
);
    reg sel;
    wire a_out, b_out;
    reg a_reg, b_reg;
    
    // Single instances with clock gating
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Time-multiplexing control
    always @(posedge clk) begin
        sel <= ~sel;
        
        if (sel) begin
            a_reg <= a_out;  // Store ModuleA result
        end else begin
            b_reg <= b_out;  // Store ModuleB result
        end
        
        // Compute final output
        z <= a_reg ^ b_reg;
    end
    
    // Clock gating for power savings
    wire gated_clk = clk & (x | y);  // Only clock when inputs are active
endmodule