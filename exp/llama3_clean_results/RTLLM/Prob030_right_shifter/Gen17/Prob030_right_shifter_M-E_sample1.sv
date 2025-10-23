module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

reg [7:0] stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8;
reg clk_gated;

always @(posedge clk) begin
    // Clock gating
    if (d == 1'b1) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

always @(posedge clk_gated) begin
    // Pipeline stage 1
    stage1 <= {d, 7'b0};
    
    // Pipeline stage 2
    stage2 <= {stage1[0], stage1[7:1]};
    
    // Pipeline stage 3
    stage3 <= {stage2[0], stage2[7:1]};
    
    // Pipeline stage 4
    stage4 <= {stage3[0], stage3[7:1]};
    
    // Pipeline stage 5
    stage5 <= {stage4[0], stage4[7:1]};
    
    // Pipeline stage 6
    stage6 <= {stage5[0], stage5[7:1]};
    
    // Pipeline stage 7
    stage7 <= {stage6[0], stage6[7:1]};
    
    // Pipeline stage 8
    stage8 <= {stage7[0], stage7[7:1]};
    
    // Output
    q <= stage8;
end

endmodule