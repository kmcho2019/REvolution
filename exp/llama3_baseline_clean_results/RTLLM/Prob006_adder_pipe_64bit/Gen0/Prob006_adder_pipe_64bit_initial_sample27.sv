module adder_pipe_64bit(
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg [63:0] stage2_sum;
reg        stage2_cout;
reg [64:0] stage3_result;
reg        stage3_o_en;

// Synchronize the input enable signal (i_en) and input operands (adda, addb)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
    end else if (i_en) begin
        stage1_adda <= adda;
        stage1_addb <= addb;
    end
end

// Calculate the sum of the input operands
reg [63:0] sum;
reg        cout;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        cout <= 1'b0;
    end else begin
        sum <= stage1_adda + stage1_addb;
        cout <= (stage1_adda[63] + stage1_addb[63] + 1'b0) > 1'b1;
    end
end

// Update the stage2_sum and stage2_cout
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_sum <= 64'd0;
        stage2_cout <= 1'b0;
    end else begin
        stage2_sum <= sum;
        stage2_cout <= cout;
    end
end

// Update the stage3_result
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_result <= 65'd0;
    end else begin
        stage3_result <= {stage2_cout, stage2_sum};
    end
end

// Update the output enable signal (o_en)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage3_o_en <= 1'b0;
    end else begin
        stage3_o_en <= i_en;
    end
end

// Update the output ports
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        result <= stage3_result;
        o_en <= stage3_o_en;
    end
end

endmodule