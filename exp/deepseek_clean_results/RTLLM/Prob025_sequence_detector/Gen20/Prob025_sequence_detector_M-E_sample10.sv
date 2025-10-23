module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

// Pipeline registers for each sequence position
reg stage1;  // Looking for '1' (first bit)
reg stage2;  // Looking for '0' (second bit)
reg stage3;  // Looking for '0' (third bit)
reg stage4;  // Looking for '1' (fourth bit)

// Pipeline progression logic
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
        stage3 <= 1'b0;
        stage4 <= 1'b0;
    end else begin
        // Stage 1: Always check for first bit '1'
        stage1 <= (data_in == 1'b1);
        
        // Stage 2: Progress if previous stage matched and current bit is '0'
        stage2 <= stage1 & (data_in == 1'b0);
        
        // Stage 3: Progress if previous stage matched and current bit is '0'
        stage3 <= stage2 & (data_in == 1'b0);
        
        // Stage 4: Final detection if previous stage matched and current bit is '1'
        stage4 <= stage3 & (data_in == 1'b1);
    end
end

// Detection occurs when final stage is active
assign sequence_detected = stage4;

endmodule