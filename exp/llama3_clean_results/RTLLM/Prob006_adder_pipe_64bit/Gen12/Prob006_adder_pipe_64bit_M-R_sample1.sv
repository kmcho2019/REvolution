module adder_pipe_64bit(
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
reg         i_en_reg;
reg         o_en_reg;

assign result = {1'b0, adda_reg} + {1'b0, addb_reg};

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
            i_en_reg <= 1'b1;
        end
        if (i_en_reg) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign o_en = o_en_reg;

endmodule