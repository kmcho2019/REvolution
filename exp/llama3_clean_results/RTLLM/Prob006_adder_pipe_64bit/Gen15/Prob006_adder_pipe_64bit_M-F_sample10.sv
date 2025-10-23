module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8
) (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [DATA_WIDTH-1:0]  adda,
    input   [DATA_WIDTH-1:0]  addb,
    output  [DATA_WIDTH:0]  result,
    output          o_en
);

localparam PIPELINE_DEPTH = DATA_WIDTH / STG_WIDTH;

reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH:0] result_reg;
reg o_en_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 1'b0;
    end
end

reg [STG_WIDTH-1:0] carries [PIPELINE_DEPTH-1:0];
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        carries <= '{default: {STG_WIDTH{1'b0}}};
    end else begin
        carries[0] <= (adda_reg[STG_WIDTH-1:0] + addb_reg[STG_WIDTH-1:0]) > {STG_WIDTH{1'b1}} - 1? 1'b1 : 1'b0;
        for (int i = 1; i < PIPELINE_DEPTH; i++) begin
            carries[i] <= (adda_reg[(i*STG_WIDTH)+STG_WIDTH-1:(i*STG_WIDTH)] + addb_reg[(i*STG_WIDTH)+STG_WIDTH-1:(i*STG_WIDTH)] + (carries[i-1]? 1'b1 : 1'b0)) > {STG_WIDTH{1'b1}} - 1? 1'b1 : 1'b0;
        end
    end
end

// Result calculation and output enable logic
reg [PIPELINE_DEPTH-1:0] o_en_shift;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
        o_en_shift <= {PIPELINE_DEPTH{1'b0}};
    end else begin
        result_reg <= {carries[PIPELINE_DEPTH-1], (adda_reg + addb_reg)};
        o_en_shift <= {i_en, o_en_shift[PIPELINE_DEPTH-2:0]};
        if (o_en_shift[PIPELINE_DEPTH-1]) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule