module ModuleA_pipelined(
    input clk,
    input en,
    input x,
    input y,
    output reg z
);
    // Stage 1: Compute intermediate value
    wire stage1 = (x ^ y) & x;
    
    // Stage 2: Register output with clock gating
    always @(posedge clk) begin
        if (en) z <= stage1;
    end
endmodule

module ModuleB_pipelined(
    input clk,
    input en,
    input x,
    input y,
    output reg z
);
    // Stage 1: Compute XNOR
    wire stage1 = ~(x ^ y);
    
    // Stage 2: Register output with clock gating
    always @(posedge clk) begin
        if (en) z <= stage1;
    end
endmodule

module TopModule_optimized(
    input clk,
    input en,
    input x,
    input y,
    output reg z
);
    // Clock gating control
    wire inputs_changed = (x != x_prev) || (y != y_prev);
    reg x_prev, y_prev;
    wire computation_en = en && inputs_changed;
    
    // Pipeline registers
    reg stage1_or, stage1_and;
    reg stage2_xor;
    
    // Instantiate pipelined modules
    ModuleA_pipelined A1(.clk(clk), .en(computation_en), .x(x), .y(y), .z(a1_out));
    ModuleB_pipelined B1(.clk(clk), .en(computation_en), .x(x), .y(y), .z(b1_out));
    ModuleA_pipelined A2(.clk(clk), .en(computation_en), .x(x), .y(y), .z(a2_out));
    ModuleB_pipelined B2(.clk(clk), .en(computation_en), .x(x), .y(y), .z(b2_out));
    
    // Pipeline stage 1: OR and AND operations
    always @(posedge clk) begin
        if (computation_en) begin
            stage1_or <= a1_out | b1_out;
            stage1_and <= a2_out & b2_out;
            x_prev <= x;
            y_prev <= y;
        end
    end
    
    // Pipeline stage 2: Final XOR
    always @(posedge clk) begin
        if (computation_en) begin
            stage2_xor <= stage1_or ^ stage1_and;
        end
    end
    
    // Output register
    always @(posedge clk) begin
        if (en) z <= stage2_xor;
    end
endmodule