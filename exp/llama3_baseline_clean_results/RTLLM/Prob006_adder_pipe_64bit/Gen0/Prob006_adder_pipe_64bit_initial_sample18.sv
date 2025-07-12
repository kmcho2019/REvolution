module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input   [63:0]      adda,
    input   [63:0]      addb,
    output  [64:0]      result,
    output              o_en
);

reg [63:0]         stage1_sum;
reg [63:0]         stage1_carry;
reg [63:0]         stage2_sum;
reg [63:0]         stage2_carry;
reg [63:0]         stage3_sum;
reg [63:0]         stage3_carry;
reg [63:0]         stage4_sum;
reg [63:0]         stage4_carry;
reg                stage1_en;
reg                stage2_en;
reg                stage3_en;
reg                stage4_en;
reg                stage5_en;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_en <= 1'b0;
        stage2_en <= 1'b0;
        stage3_en <= 1'b0;
        stage4_en <= 1'b0;
        stage5_en <= 1'b0;
    end else begin
        stage1_en <= i_en;
        stage2_en <= stage1_en;
        stage3_en <= stage2_en;
        stage4_en <= stage3_en;
        stage5_en <= stage4_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum  <= 64'd0;
        stage1_carry <= 1'b0;
    end else if (stage1_en) begin
        {stage1_carry, stage1_sum} <= adda + addb;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum  <= 64'd0;
        stage2_carry <= 1'b0;
    end else if (stage2_en) begin
        {stage2_carry, stage2_sum} <= stage1_sum + {63'd0, stage1_carry};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_sum  <= 64'd0;
        stage3_carry <= 1'b0;
    end else if (stage3_en) begin
        {stage3_carry, stage3_sum} <= stage2_sum + {63'd0, stage2_carry};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage4_sum  <= 64'd0;
        stage4_carry <= 1'b0;
    end else if (stage4_en) begin
        {stage4_carry, stage4_sum} <= stage3_sum + {63'd0, stage3_carry};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result     <= 65'd0;
        o_en      <= 1'b0;
    end else if (stage5_en) begin
        result     <= {stage4_carry, stage4_sum};
        o_en      <= 1'b1;
    end else begin
        o_en      <= 1'b0;
    end
end

endmodule