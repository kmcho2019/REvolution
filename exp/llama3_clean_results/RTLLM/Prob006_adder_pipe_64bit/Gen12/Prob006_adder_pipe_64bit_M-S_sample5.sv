module adder_pipe_64bit #(
    parameter STAGES = 8
)(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [STAGES-1:0] carries;
reg [63:0] partial_sums;
reg [64:0] result_reg;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 1'b0;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        carries <= {STAGES{1'b0}};
        partial_sums <= 64'd0;
    end else begin
        // First stage
        partial_sums[7:0] <= adda_reg[7:0] + addb_reg[7:0];
        carries[0] <= (adda_reg[7:0] + addb_reg[7:0]) > 9'd255;

        // Remaining stages
        for (int i = 1; i < STAGES; i++) begin
            partial_sums[(i*8)+7:(i*8)] <= adda_reg[(i*8)+7:(i*8)] + addb_reg[(i*8)+7:(i*8)] + carries[i-1];
            carries[i] <= (adda_reg[(i*8)+7:(i*8)] + addb_reg[(i*8)+7:(i*8)] + carries[i-1]) > 9'd255;
        end
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        result_reg <= {carries[STAGES-1], partial_sums};
        if (i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule