module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [3:0] stage_ctr;
reg [15:0] partial_product;

// Stage 1: Initialization
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        stage_ctr <= 0;
        partial_product <= 0;
        rdy <= 0;
    end
end

// Pipeline stages
reg [15:0] stage1_out, stage2_out, stage3_out, stage4_out;
always @(posedge clk) begin
    if (!reset) begin
        // Stage 1
        if (stage_ctr == 0) begin
            if (multiplier[0]) begin
                stage1_out <= multiplicand;
            end else begin
                stage1_out <= 0;
            end
            stage_ctr <= stage_ctr + 1;
        end
        // Stage 2
        else if (stage_ctr == 1) begin
            if (multiplier[1]) begin
                stage2_out <= multiplicand << 1;
            end else begin
                stage2_out <= 0;
            end
            stage_ctr <= stage_ctr + 1;
        end
        // Stage 3
        else if (stage_ctr == 2) begin
            if (multiplier[2]) begin
                stage3_out <= multiplicand << 2;
            end else begin
                stage3_out <= 0;
            end
            stage_ctr <= stage_ctr + 1;
        end
        // Stage 4
        else if (stage_ctr == 3) begin
            if (multiplier[3]) begin
                stage4_out <= multiplicand << 3;
            end else begin
                stage4_out <= 0;
            end
            stage_ctr <= stage_ctr + 1;
        end
        // Final stage
        else if (stage_ctr == 4) begin
            partial_product <= stage1_out + stage2_out + stage3_out + stage4_out;
            rdy <= 1;
        end
    end
end

// Final product calculation
always @(posedge clk) begin
    if (rdy) begin
        p <= partial_product;
    end
end

endmodule