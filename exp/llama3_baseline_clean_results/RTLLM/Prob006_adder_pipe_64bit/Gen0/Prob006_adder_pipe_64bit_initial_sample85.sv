module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Internal wires for full adder and pipeline stages
wire [63:0] adda_reg, addb_reg, adda_pipeline, addb_pipeline;
wire [64:0] sum_pipeline;
reg [63:0] adda_reg_d, addb_reg_d, adda_pipeline_d, addb_pipeline_d;
reg [64:0] sum_pipeline_d;
reg [2:0] i_en_pipeline, o_en_pipeline;

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg_d <= 64'd0;
        addb_reg_d <= 64'd0;
        i_en_pipeline[0] <= 1'b0;
    end else if (i_en) begin
        adda_reg_d <= adda;
        addb_reg_d <= addb;
        i_en_pipeline[0] <= 1'b1;
    end else begin
        adda_reg_d <= adda_reg;
        addb_reg_d <= addb_reg;
        i_en_pipeline[0] <= 1'b0;
    end
end

assign adda_reg = adda_reg_d;
assign addb_reg = addb_reg_d;

// Pipeline stage 1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipeline_d <= 64'd0;
        addb_pipeline_d <= 64'd0;
        sum_pipeline_d <= 65'd0;
        i_en_pipeline[1] <= 1'b0;
    end else if (i_en_pipeline[0]) begin
        adda_pipeline_d <= adda_reg;
        addb_pipeline_d <= addb_reg;
        sum_pipeline_d <= {1'b0, adda_reg} + {1'b0, addb_reg};
        i_en_pipeline[1] <= 1'b1;
    end else begin
        adda_pipeline_d <= adda_pipeline;
        addb_pipeline_d <= addb_pipeline;
        sum_pipeline_d <= sum_pipeline;
        i_en_pipeline[1] <= 1'b0;
    end
end

assign adda_pipeline = adda_pipeline_d;
assign addb_pipeline = addb_pipeline_d;
assign sum_pipeline = sum_pipeline_d;

// Pipeline stage 2
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipeline_d <= 64'd0;
        addb_pipeline_d <= 64'd0;
        sum_pipeline_d <= 65'd0;
        i_en_pipeline[2] <= 1'b0;
    end else if (i_en_pipeline[1]) begin
        adda_pipeline_d <= adda_pipeline;
        addb_pipeline_d <= addb_pipeline;
        sum_pipeline_d <= sum_pipeline;
        i_en_pipeline[2] <= 1'b1;
    end else begin
        adda_pipeline_d <= adda_pipeline;
        addb_pipeline_d <= addb_pipeline;
        sum_pipeline_d <= sum_pipeline;
        i_en_pipeline[2] <= 1'b0;
    end
end

// Pipeline stage 3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_en_pipeline <= 3'b0;
    end else begin
        o_en_pipeline <= {i_en_pipeline[2], o_en_pipeline[1:0]};
    end
end

// Output
assign result = sum_pipeline;
assign o_en = o_en_pipeline[2];

endmodule