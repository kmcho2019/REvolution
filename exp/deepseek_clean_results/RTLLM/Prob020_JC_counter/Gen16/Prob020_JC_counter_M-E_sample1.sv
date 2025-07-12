module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Pipeline registers
reg [15:0] stage1, stage2, stage3, stage4;
wire stage1_msb = ~stage4[0];  // Feedback from last stage

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 16'b0;
        stage2 <= 16'b0;
        stage3 <= 16'b0;
        stage4 <= 16'b0;
    end else begin
        // Pipeline stage 1 (MSB)
        stage1 <= {stage1_msb, stage1[15:1]};
        
        // Pipeline stage 2
        stage2 <= {stage1[0], stage2[15:1]};
        
        // Pipeline stage 3
        stage3 <= {stage2[0], stage3[15:1]};
        
        // Pipeline stage 4 (LSB)
        stage4 <= {stage3[0], stage4[15:1]};
    end
end

// Combine pipeline stages for output
always @(*) begin
    Q = {stage1, stage2, stage3, stage4};
end

// Synthesis attributes for pipeline optimization
// synthesis attribute async_reg of stage1 is "true";
// synthesis attribute async_reg of stage2 is "true";
// synthesis attribute async_reg of stage3 is "true";
// synthesis attribute async_reg of stage4 is "true";
// synthesis attribute shreg_extract of stage1 is "no";
// synthesis attribute shreg_extract of stage2 is "no";
// synthesis attribute shreg_extract of stage3 is "no";
// synthesis attribute shreg_extract of stage4 is "no";

endmodule