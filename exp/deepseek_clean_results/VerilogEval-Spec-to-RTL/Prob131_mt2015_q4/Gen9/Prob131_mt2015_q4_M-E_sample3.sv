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
    
    // Single instances of each module
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Clock divider for time multiplexing
    always @(posedge clk) begin
        sel <= ~sel;
    end
    
    // Capture results on appropriate cycles
    always @(posedge clk) begin
        if (sel) a_reg <= a_out;
        else b_reg <= b_out;
    end
    
    // Combine results (equivalent to original logic)
    always @(posedge clk) begin
        z <= (a_reg | b_reg) ^ (a_reg & b_reg);
    end
endmodule