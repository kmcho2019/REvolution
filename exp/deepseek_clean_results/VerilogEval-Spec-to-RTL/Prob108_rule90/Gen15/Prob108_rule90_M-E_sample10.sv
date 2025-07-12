module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [127:0] stage1_q, stage2_q, stage3_q, stage4_q;
    reg stage1_left_bound, stage1_right_bound;
    reg stage2_left_bound, stage2_right_bound;
    reg stage3_left_bound, stage3_right_bound;
    
    // Next state computation for each pipeline stage
    wire [127:0] next_stage1, next_stage2, next_stage3, next_stage4;
    
    // Pipeline stage 1 (bits 0-127)
    assign next_stage1[0] = 1'b0 ^ stage1_q[1]; // Left boundary = 0
    genvar i;
    generate
        for (i = 1; i < 127; i = i + 1) begin
            assign next_stage1[i] = stage1_q[i-1] ^ stage1_q[i+1];
        end
    endgenerate
    assign next_stage1[127] = stage1_q[126] ^ stage1_right_bound;
    
    // Pipeline stage 2 (bits 128-255)
    assign next_stage2[0] = stage2_left_bound ^ stage2_q[1];
    generate
        for (i = 1; i < 127; i = i + 1) begin
            assign next_stage2[i] = stage2_q[i-1] ^ stage2_q[i+1];
        end
    endgenerate
    assign next_stage2[127] = stage2_q[126] ^ stage2_right_bound;
    
    // Pipeline stage 3 (bits 256-383)
    assign next_stage3[0] = stage3_left_bound ^ stage3_q[1];
    generate
        for (i = 1; i < 127; i = i + 1) begin
            assign next_stage3[i] = stage3_q[i-1] ^ stage3_q[i+1];
        end
    endgenerate
    assign next_stage3[127] = stage3_q[126] ^ stage3_right_bound;
    
    // Pipeline stage 4 (bits 384-511)
    assign next_stage4[0] = stage4_left_bound ^ stage4_q[1];
    generate
        for (i = 1; i < 127; i = i + 1) begin
            assign next_stage4[i] = stage4_q[i-1] ^ stage4_q[i+1];
        end
    endgenerate
    assign next_stage4[127] = stage4_q[126] ^ 1'b0; // Right boundary = 0
    
    // Boundary propagation between stages
    always @(posedge clk) begin
        if (load) begin
            stage1_q <= data[127:0];
            stage2_q <= data[255:128];
            stage3_q <= data[383:256];
            stage4_q <= data[511:384];
            
            // Reset boundary conditions when loading
            stage1_left_bound <= 1'b0;
            stage1_right_bound <= data[128];
            stage2_left_bound <= data[127];
            stage2_right_bound <= data[256];
            stage3_left_bound <= data[255];
            stage3_right_bound <= data[384];
            stage4_left_bound <= data[383];
        end else begin
            // Update pipeline stages
            stage1_q <= next_stage1;
            stage2_q <= next_stage2;
            stage3_q <= next_stage3;
            stage4_q <= next_stage4;
            
            // Propagate boundary conditions
            stage1_left_bound <= 1'b0; // Constant left boundary
            stage1_right_bound <= stage2_q[0];
            stage2_left_bound <= stage1_q[127];
            stage2_right_bound <= stage3_q[0];
            stage3_left_bound <= stage2_q[127];
            stage3_right_bound <= stage4_q[0];
            stage4_left_bound <= stage3_q[127];
        end
    end
    
    // Output reassembly
    always @(*) begin
        q = {stage4_q, stage3_q, stage2_q, stage1_q};
    end

endmodule