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
reg [64:0] sum_reg;
reg [1:0]  i_en_reg;

assign result = {1'b0, adda_reg} + {1'b0, addb_reg};

// Pipeline stage management
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 2'b00;
        o_en <= 1'b0;
    end else begin
        i_en_reg <= {i_en_reg[0], i_en};
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        if (i_en_reg[1]) begin
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule