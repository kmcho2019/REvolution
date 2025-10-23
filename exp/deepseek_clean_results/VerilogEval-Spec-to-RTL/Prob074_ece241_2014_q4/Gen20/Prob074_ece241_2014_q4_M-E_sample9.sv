module TopModule (
    input clk,
    input x,
    output reg z
);

    // First stage flip-flops
    reg stage1_xor, stage1_and, stage1_or;
    
    // Second stage flip-flops (feedback registers)
    reg stage2_xor, stage2_and, stage2_or;
    
    // Gate outputs
    wire xor_out, and_out, or_out;
    
    // Synchronous reset flag
    reg reset_flag = 1'b1;

    // Gate implementations using pipelined feedback
    assign xor_out = x ^ stage2_xor;
    assign and_out = x & (~stage2_and);
    assign or_out  = x | (~stage2_or);

    // Three-input NOR of second stage outputs
    wire z_next = ~(stage2_xor | stage2_and | stage2_or);

    // Main sequential logic
    always @(posedge clk) begin
        // First pipeline stage
        stage1_xor <= xor_out;
        stage1_and <= and_out;
        stage1_or  <= or_out;
        
        // Second pipeline stage (feedback)
        stage2_xor <= reset_flag ? 1'b0 : stage1_xor;
        stage2_and <= reset_flag ? 1'b0 : stage1_and;
        stage2_or  <= reset_flag ? 1'b0 : stage1_or;
        
        // Output register
        z <= reset_flag ? 1'b1 : z_next;
        
        // Clear reset flag after first cycle
        reset_flag <= 1'b0;
    end

endmodule