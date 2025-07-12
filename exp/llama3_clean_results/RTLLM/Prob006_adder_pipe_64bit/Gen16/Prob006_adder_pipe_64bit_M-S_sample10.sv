module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Parameters
parameter DATA_WIDTH = 64;

// Pipeline stages
reg [DATA_WIDTH-1:0] adda_reg;
reg [DATA_WIDTH-1:0] addb_reg;
reg [DATA_WIDTH:0] sum_reg;
reg               o_en_reg;
reg               i_en_reg;
reg               i_en_reg_2;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
        i_en_reg <= 1'b0;
        i_en_reg_2 <= 1'b0;
        o_en_reg <= 1'b0;
        sum_reg <= {DATA_WIDTH+1{1'b0}};
    end else begin
        i_en_reg <= i_en;
        i_en_reg_2 <= i_en_reg;
        if (i_en) begin
            adda_reg <= adda;
            addb_reg <= addb;
        end
        if (i_en_reg_2) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
        {sum_reg[64], sum_reg[63:0]} <= adda_reg + addb_reg;
    end
end

// Output assignment
assign result = sum_reg;
assign o_en = o_en_reg;

endmodule