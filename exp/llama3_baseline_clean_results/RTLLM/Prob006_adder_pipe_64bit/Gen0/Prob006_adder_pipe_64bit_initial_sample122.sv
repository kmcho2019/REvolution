module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output     [64:0] result,
    output             o_en
);

// Internal signals
reg   [63:0]  stage1_adda;
reg   [63:0]  stage1_addb;
reg   [63:0]  stage2_adda;
reg   [63:0]  stage2_addb;
reg   [63:0]  stage3_sum;
reg             stage1_i_en;
reg             stage2_i_en;
reg             stage3_o_en;

// Pipeline stage 1: Register input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_adda  <= 64'd0;
        stage1_addb  <= 64'd0;
        stage1_i_en  <= 1'd0;
    end else begin
        stage1_adda  <= adda;
        stage1_addb  <= addb;
        stage1_i_en  <= i_en;
    end
end

// Pipeline stage 2: Register input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_adda  <= 64'd0;
        stage2_addb  <= 64'd0;
        stage2_i_en  <= 1'd0;
    end else begin
        stage2_adda  <= stage1_adda;
        stage2_addb  <= stage1_addb;
        stage2_i_en  <= stage1_i_en;
    end
end

// Pipeline stage 3: Calculate sum
wire    [63:0] sum;
wire             carry_out;
assign sum = stage2_adda + stage2_addb;
assign carry_out = (sum[63] + stage2_adda[63] + stage2_addb[63]) > 1? 1'b1 : 1'b0;

// Pipeline stage 3: Register sum and update output enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum   <= 64'd0;
        stage3_o_en  <= 1'd0;
    end else begin
        stage3_sum   <= sum;
        stage3_o_en  <= stage2_i_en;
    end
end

// Output logic
assign result = {carry_out, stage3_sum};
assign o_en = stage3_o_en;

endmodule