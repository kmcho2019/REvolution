// Define the main adder module
module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Define the number of pipeline stages
parameter STAGES = 4;

// Define the width of each stage
parameter STAGE_WIDTH = 16;

// Define the input registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;

// Define the output register
reg [64:0] result_reg;

// Define the pipeline stages
reg [15:0] stage1_sum;
reg stage1_cout;
reg [15:0] stage2_sum;
reg stage2_cout;
reg [15:0] stage3_sum;
reg stage3_cout;
reg [15:0] stage4_sum;
reg stage4_cout;

// Capture the input data
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Calculate the sum and carry for each stage
always @(posedge clk) begin
    {stage1_sum, stage1_cout} = adda_reg[15:0] + addb_reg[15:0];
    {stage2_sum, stage2_cout} = adda_reg[31:16] + addb_reg[31:16] + stage1_cout;
    {stage3_sum, stage3_cout} = adda_reg[47:32] + addb_reg[47:32] + stage2_cout;
    {stage4_sum, stage4_cout} = adda_reg[63:48] + addb_reg[63:48] + stage3_cout;
end

// Assign the result
always @(posedge clk) begin
    if (i_en) begin
        result_reg <= {stage4_cout, stage4_sum, stage3_sum, stage2_sum, stage1_sum};
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

assign result = result_reg;

endmodule