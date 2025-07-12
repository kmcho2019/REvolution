module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Define the internal signals for the pipeline stages
reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg [63:0] stage2_sum;
reg [0:0] stage2_cout;
reg [64:0] stage3_result;

// Define the internal signals for the synchronized input enable signal
reg sync_i_en;
reg sync_i_en_1;

// Synchronize the input enable signal with the clock and reset signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sync_i_en <= 1'b0;
        sync_i_en_1 <= 1'b0;
    end else begin
        sync_i_en <= i_en;
        sync_i_en_1 <= sync_i_en;
    end
end

// Define the combinational logic for the addition operation
always @(*) begin
    {stage2_cout, stage2_sum} = stage1_a + stage1_b;
    result = stage3_result;
end

// Define the clocked behavior of the pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage3_result <= 65'd0;
        o_en <= 1'b0;
    end else if (sync_i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        o_en <= 1'b0;
    end else if (sync_i_en_1) begin
        stage3_result <= {stage2_cout, stage2_sum};
        o_en <= 1'b1;
    end else begin
        stage3_result <= stage3_result;
        o_en <= o_en;
    end
end

endmodule