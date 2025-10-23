module SharedProcessingUnit(
    input x,
    input y,
    input op_select,  // 0 for ModuleA, 1 for ModuleB
    output reg z
);
    always @(*) begin
        if (!op_select) begin
            // ModuleA operation: (x^y) & x
            z = (x ^ y) & x;
        end else begin
            // ModuleB operation: XNOR (from waveform)
            z = ~(x ^ y);
        end
    end
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    reg op_select;
    wire a_out, b_out;
    wire stage1_out, stage2_out;
    
    // Shared processing unit
    SharedProcessingUnit spu(
        .x(x),
        .y(y),
        .op_select(op_select),
        .z(stage1_out)
    );
    
    // Simple 2-stage pipeline
    always @(*) begin
        // First cycle: compute ModuleA result
        op_select = 0;
        a_out = stage1_out;
        
        // Second cycle: compute ModuleB result
        op_select = 1;
        b_out = stage1_out;
    end
    
    // Pipeline register
    reg pipeline_reg;
    always @(*) begin
        pipeline_reg = a_out | b_out;
    end
    
    // Final computation
    assign stage2_out = pipeline_reg ^ (a_out & b_out);
    assign z = stage2_out;
endmodule