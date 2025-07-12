module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg [63:0] sum_reg;
reg [63:0] carry_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
        sum_reg <= 64'd0;
        carry_reg <= 64'd0;
        o_en_reg <= 1'b0;
    end else begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
        
        // First pipeline stage: calculate sum and carry
        if (i_en_reg) begin
            sum_reg <= adda_reg + addb_reg;
            carry_reg <= (adda_reg[63] + addb_reg[63] + (adda_reg[62:0] + addb_reg[62:0] + {63{1'b0}}) > 63'd0);
        end else begin
            sum_reg <= 64'd0;
            carry_reg <= 64'd0;
        end
        
        // Second pipeline stage: calculate final result and output enable
        if (i_en_reg) begin
            result <= {1'b0, sum_reg} + {64{carry_reg[63]}};
            o_en_reg <= 1'b1;
        end else begin
            result <= 65'd0;
            o_en_reg <= 1'b0;
        end
    end
end

assign o_en = o_en_reg;

endmodule