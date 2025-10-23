module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Input registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg sign_reg;

// Pipeline registers
reg [15:0] stage1_reg;
reg [15:0] stage2_reg;
reg [15:0] stage3_reg;
reg [15:0] stage4_reg;
reg [15:0] stage5_reg;
reg [15:0] stage6_reg;
reg [15:0] stage7_reg;
reg [15:0] stage8_reg;
reg [15:0] stage9_reg;

// Control signals
reg start;
reg [3:0] cnt;

// Initialize input registers
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        sign_reg <= 0;
        start <= 0;
        res_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        sign_reg <= sign;
        start <= 1;
    end
end

// Pipeline stage 1
always @(posedge clk) begin
    if (start) begin
        stage1_reg <= {8'b0, dividend_reg};
    end
end

// Pipeline stages 2-9
always @(posedge clk) begin
    if (start) begin
        case (cnt)
            1: stage2_reg <= stage1_reg;
            2: stage3_reg <= stage2_reg;
            3: stage4_reg <= stage3_reg;
            4: stage5_reg <= stage4_reg;
            5: stage6_reg <= stage5_reg;
            6: stage7_reg <= stage6_reg;
            7: stage8_reg <= stage7_reg;
            8: stage9_reg <= stage8_reg;
        endcase
        if (cnt < 8) begin
            cnt <= cnt + 1;
        end else begin
            start <= 0;
        end
    end
end

// Perform radix-2 division
always @(posedge clk) begin
    if (start) begin
        case (cnt)
            1: stage2_reg <= {stage1_reg[15:8] - divisor_reg, stage1_reg[7:0]};
            2: stage3_reg <= {stage2_reg[15:8] - divisor_reg, stage2_reg[7:0]};
            3: stage4_reg <= {stage3_reg[15:8] - divisor_reg, stage3_reg[7:0]};
            4: stage5_reg <= {stage4_reg[15:8] - divisor_reg, stage4_reg[7:0]};
            5: stage6_reg <= {stage5_reg[15:8] - divisor_reg, stage5_reg[7:0]};
            6: stage7_reg <= {stage6_reg[15:8] - divisor_reg, stage6_reg[7:0]};
            7: stage8_reg <= {stage7_reg[15:8] - divisor_reg, stage7_reg[7:0]};
            8: stage9_reg <= {stage8_reg[15:8] - divisor_reg, stage8_reg[7:0]};
        endcase
    end
end

// Form result
always @(posedge clk) begin
    if (!start && cnt == 8) begin
        result <= {stage9_reg[15:8], stage9_reg[7:0]};
        res_valid <= 1;
    end else begin
        res_valid <= 0;
    end
end

endmodule