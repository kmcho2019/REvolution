module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] result_reg;
reg [15:0] stage1_sum;
reg stage1_cout;
reg [15:0] stage2_sum;
reg stage2_cout;
reg [15:0] stage3_sum;
reg stage3_cout;
reg [15:0] stage4_sum;
reg stage4_cout;
reg [1:0] pipeline_counter;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        result_reg <= 65'd0;
        o_en <= 1'b0;
        pipeline_counter <= 2'd0;
    end else begin
        if (i_en && pipeline_counter == 2'd0) begin
            adda_reg <= adda;
            addb_reg <= addb;
            pipeline_counter <= pipeline_counter + 1;
        end else if (pipeline_counter == 2'd1) begin
            {stage1_sum, stage1_cout} = adda_reg[15:0] + addb_reg[15:0];
            pipeline_counter <= pipeline_counter + 1;
        end else if (pipeline_counter == 2'd2) begin
            {stage2_sum, stage2_cout} = adda_reg[31:16] + addb_reg[31:16] + stage1_cout;
            pipeline_counter <= pipeline_counter + 1;
        end else if (pipeline_counter == 2'd3) begin
            {stage3_sum, stage3_cout} = adda_reg[47:32] + addb_reg[47:32] + stage2_cout;
            pipeline_counter <= pipeline_counter + 1;
        end else if (pipeline_counter == 2'd4) begin
            {stage4_sum, stage4_cout} = adda_reg[63:48] + addb_reg[63:48] + stage3_cout;
            result_reg <= {stage4_cout, stage4_sum, stage3_sum, stage2_sum, stage1_sum};
            o_en <= 1'b1;
            pipeline_counter <= 2'd0;
        end else begin
            pipeline_counter <= pipeline_counter;
        end
    end
end

assign result = result_reg;

endmodule