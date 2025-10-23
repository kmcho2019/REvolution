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

logic [DATA_WIDTH-1:0] adda_reg;
logic [DATA_WIDTH-1:0] addb_reg;
logic [DATA_WIDTH:0] result_reg;
logic o_en_reg;
logic [PIPELINE_DEPTH-1:0] o_en_shift;

always_ff @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= '0;
        addb_reg <= '0;
        result_reg <= '0;
        o_en_reg <= 1'b0;
        o_en_shift <= '0;
    end else begin
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        o_en_shift <= {i_en, o_en_shift[PIPELINE_DEPTH-2:0]};
        if (o_en_shift[PIPELINE_DEPTH-1]) begin
            result_reg <= adda_reg + addb_reg;
        end
        o_en_reg <= o_en_shift[PIPELINE_DEPTH-1];
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule