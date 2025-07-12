module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

reg [7:0] stage1, stage2, stage3;
reg valid_stage1, valid_stage2, valid_stage3;

always @(posedge clk) begin
    if (reset) begin
        stage1 <= 0;
        stage2 <= 0;
        stage3 <= 0;
        valid_stage1 <= 0;
        valid_stage2 <= 0;
        valid_stage3 <= 0;
        done <= 0;
    end else begin
        // First stage: check for start byte
        if (in[3]) begin
            stage1 <= in;
            valid_stage1 <= 1;
        end else if (valid_stage1) begin
            // Shift bytes through pipeline
            stage1 <= stage2;
            valid_stage1 <= valid_stage2;
        end else begin
            stage1 <= 0;
            valid_stage1 <= 0;
        end

        // Second stage: store next byte
        if (valid_stage1) begin
            stage2 <= in;
            valid_stage2 <= 1;
        end else if (valid_stage2) begin
            stage2 <= stage3;
            valid_stage2 <= valid_stage3;
        end else begin
            stage2 <= 0;
            valid_stage2 <= 0;
        end

        // Third stage: store third byte
        if (valid_stage2) begin
            stage3 <= in;
            valid_stage3 <= 1;
        end else begin
            stage3 <= 0;
            valid_stage3 <= 0;
        end

        // Assert done signal when all stages are valid
        if (valid_stage3) begin
            done <= 1;
            out_bytes <= {stage1, stage2, stage3};
        end else begin
            done <= 0;
        end
    end
end

endmodule