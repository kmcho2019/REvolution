module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the pipeline stages
reg [63:0] stage1_sum;
reg [63:0] stage2_sum;
reg [63:0] stage3_sum;
reg [63:0] stage4_sum;

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;

reg [0:0] stage1_cout;
reg [0:0] stage2_cout;
reg [0:0] stage3_cout;
reg [0:0] stage4_cout;

reg i_en_reg1;
reg i_en_reg2;
reg i_en_reg3;

// Stage 1: Input registers and addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        i_en_reg1 <= 1'b0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
        i_en_reg1 <= 1'b1;
    end else begin
        stage1_adda <= stage1_adda;
        stage1_addb <= stage1_addb;
        i_en_reg1 <= i_en_reg1;
    end
end

// Stage 2: Addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 1'b0;
        i_en_reg2 <= 1'b0;
    end else if (i_en_reg1) begin
        {stage2_cout, stage2_sum[15:0]} <= stage1_adda[15:0] + stage1_addb[15:0];
        i_en_reg2 <= 1'b1;
    end else begin
        stage2_sum <= stage2_sum;
        stage2_cout <= stage2_cout;
        i_en_reg2 <= i_en_reg2;
    end
end

// Stage 3: Addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum <= 64'd0;
        stage3_cout <= 1'b0;
        i_en_reg3 <= 1'b0;
    end else if (i_en_reg2) begin
        {stage3_cout, stage3_sum[15:0]} <= stage1_adda[31:16] + stage1_addb[31:16] + stage2_cout;
        i_en_reg3 <= 1'b1;
    end else begin
        stage3_sum <= stage3_sum;
        stage3_cout <= stage3_cout;
        i_en_reg3 <= i_en_reg3;
    end
end

// Stage 4: Addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage4_sum <= 64'd0;
        stage4_cout <= 1'b0;
    end else if (i_en_reg3) begin
        {stage4_cout, stage4_sum[15:0]} <= stage1_adda[47:32] + stage1_addb[47:32] + stage3_cout;
    end else begin
        stage4_sum <= stage4_sum;
        stage4_cout <= stage4_cout;
    end
end

// Final addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_reg3) begin
        result <= {stage4_cout, stage4_sum[15:0]} + {stage1_adda[63:48], stage1_addb[63:48]} + stage4_cout;
        o_en <= 1'b1;
    end else begin
        result <= result;
        o_en <= o_en;
    end
end

endmodule