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

// Calculate result
wire [DATA_WIDTH:0] sum;
assign sum = adda_reg + addb_reg;

// Output enable logic
reg [PIPELINE_DEPTH-1:0] o_en_shift;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_shift <= {PIPELINE_DEPTH{1'b0}};
    end else begin
        o_en_shift <= {i_en, o_en_shift[PIPELINE_DEPTH-2:0]};
    end
end

assign o_en = o_en_shift[PIPELINE_DEPTH-1];

// Result register
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= {DATA_WIDTH+1{1'b0}};
    end else begin
        result_reg <= sum;
    end
end

assign result = result_reg;

endmodule